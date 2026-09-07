# Tracer — iOS v1 design spec

Overlay a reference photo on the live camera so an artist can trace it onto paper.
One screen. iPhone only. SwiftUI + AVFoundation + PhotosUI.

Reference prototype: `Tracer.dc.html`.

> **Implementation note:** Controls ship as a **collapsible corner menu** (`ControlsMenu`) rather than a always-visible bottom bar, so the canvas stays clear while tracing. Visual tokens and overlay behavior below still apply.

---

## 1. Scope

**In v1**
- Full-bleed live camera preview (back camera, photo preset, no capture).
- Photo selection via `PhotosPicker`.
- Overlay image with pan, pinch-scale, rotate, and live opacity (default 40%).
- Faint rule-of-thirds grid over the preview.
- Camera + Photos permission strings and denied-state handling.

**Out of scope for v1**
- ARKit plane pinning / world-locked overlays
- Drawing or annotation tools
- Export, capture, or saving composites
- Multiple overlays, layers, blend modes
- iPad, Mac Catalyst
- (Landscape on iPhone is supported so landscape reference photos can be traced.)

---

## 2. Screen

A single `CameraOverlayView`. Z-order, bottom to top:

1. **Camera preview** — `AVCaptureVideoPreviewLayer`, `.resizeAspectFill`, ignores safe area.
2. **Grid** — three-by-three, 1px lines at `white.opacity(0.13)`, `allowsHitTesting(false)`.
3. **Overlay image** — centered, transformed by the gesture state, `allowsHitTesting(false)`;
   gestures live on a transparent layer above the preview, not on the image itself.
4. **Empty-state plate** (only when no photo) — flush-left dark block, 2px accent top rule,
   inset 24pt from each side, vertically centered at 47% of the screen.
   Title "Choose a reference" / subtitle "Then drag to position it, pinch to scale and rotate."
   Never white type directly over the preview: the plate exists because the camera can be bright.
5. **Bottom bar** — see below.
6. **Photos sheet** — `PhotosPicker` presentation.

### Bottom bar

Pinned to the bottom, `padding(.bottom, 34)` clear of the home indicator, over a
`LinearGradient(.clear → .black.opacity(0.72))` scrim.

| Element | Spec |
| --- | --- |
| Photos button | 44pt tall, flush-left label, uppercase 13pt semibold, 1px `white.opacity(0.45)` border, `.ultraThinMaterial` fill, `photo.on.rectangle` leading icon, zero corner radius |
| Opacity label | Uppercase 10.5pt, `white.opacity(0.62)`; live percentage in solid white, right-aligned |
| Slider | Custom track: 2pt `white.opacity(0.35)`; thumb 16×28pt solid accent `#EC3013`, square. 44pt hit height. |

No other chrome. Reset, flip and lock are deliberately absent in v1 — every other
adjustment is a gesture.

### Visual tokens

Zero corner radius everywhere. Archivo (or the system's condensed grotesque) for labels;
uppercase with `.tracking(0.06em)` on button and section labels.

```
accent      #EC3013
ink         #201E1D
paper       #F3F2F2
on-camera   white, white.opacity(0.78) secondary, white.opacity(0.62) tertiary
```

---

## 3. Overlay transform

State lives in one value type:

```swift
struct OverlayTransform: Equatable {
    var offset: CGSize = .init(width: 0, height: -20)
    var scale: CGFloat = 1
    var rotation: Angle = .zero
    static let initial = OverlayTransform()
}
```

Applied in order: `.scaleEffect(scale).rotationEffect(rotation).offset(offset)`.

Gestures, composed with `SimultaneousGesture` so pinch and rotate run together:

| Gesture | Behavior |
| --- | --- |
| `DragGesture` | Adds translation to a committed offset on `.onEnded`. |
| `MagnificationGesture` | Multiplies committed scale, clamped `0.15…6.0`. |
| `RotationGesture` | Adds to committed rotation; no snapping in v1. |

Keep a `committed` and a `live` copy; the view renders `committed * live` so a gesture
never accumulates twice. Nothing animates during a gesture — the overlay must track the
finger exactly. Only the reset action animates (`.snappy(duration: 0.22)`).

Opacity is separate from the transform (`@State var opacity: Double = 0.4`) and applies
as `.opacity(opacity)` on the image. It updates continuously while the slider drags.

---

## 4. Photo selection

```swift
@State private var pickedItem: PhotosPickerItem?
@State private var overlayImage: Image?
```

- `PhotosPicker(selection:matching: .images, photoLibrary: .shared())`.
- On change, `loadTransferable(type: Data.self)` off the main actor, downsample to a
  max dimension of ~2048px before creating the `UIImage`, then publish on the main actor.
- Selecting a new photo resets the transform to `.initial` and keeps the current opacity.
- No library read permission prompt is needed for `PhotosPicker` — it runs out of process.
  The `NSPhotoLibraryUsageDescription` string is still declared for the fallback path.

---

## 5. Permissions

`Info.plist`:

```
NSCameraUsageDescription
  Tracer shows your camera so you can line a reference photo up with your paper.
NSPhotoLibraryUsageDescription
  Tracer needs your photo library to load the reference image you want to trace.
```

Flow:

1. On first appearance, show the empty state with the camera preview dark.
2. Request camera access with `AVCaptureDevice.requestAccess(for: .video)` on first appear.
3. Denied or restricted: replace the preview with a flush-left dark plate —
   "Camera access is off" plus a button opening `UIApplication.openSettingsURLString`.
   The Photos button and opacity slider stay disabled at 45% opacity.

---

## 6. File layout

```
Tracer/
  TracerApp.swift
  Camera/
    CameraSession.swift        // AVCaptureSession setup, start/stop, authorization
    CameraPreview.swift        // UIViewRepresentable wrapping AVCaptureVideoPreviewLayer
  Overlay/
    OverlayTransform.swift     // value type + clamping
    OverlayImageView.swift     // image + transform + opacity
    OverlayGestures.swift      // ViewModifier composing drag/magnify/rotate
  Screens/
    CameraOverlayView.swift    // the one screen
    PermissionPlate.swift      // denied-state block
  Controls/
    BottomBar.swift
    OpacitySlider.swift        // custom track + square thumb
    GridOverlay.swift
  Support/
    ImageLoader.swift          // PhotosPickerItem → downsampled UIImage
    Theme.swift                // colors, type, spacing constants
  Info.plist
```

---

## 7. Build order

1. `CameraSession` + `CameraPreview`, full-bleed, running on device.
2. Camera authorization and `PermissionPlate`.
3. `GridOverlay` and the empty-state plate.
4. `BottomBar` shell with the Photos button wired to `PhotosPicker`.
5. `ImageLoader` and `OverlayImageView` at fixed 40% opacity.
6. `OpacitySlider` driving opacity live.
7. `OverlayGestures` — drag first, then pinch, then rotation, then simultaneous composition.
8. Clamping, transform reset on new photo, session lifecycle on background/foreground.

---

## 8. Acceptance criteria

- Launching with camera permission granted shows a live full-bleed preview within 1s, no letterboxing.
- With no photo chosen, the empty-state plate is legible against a white wall and a dark room.
- Choosing a photo places it centered at 40% opacity with the transform reset.
- Dragging moves the overlay 1:1 with the finger, no lag or drift on release.
- Pinch and rotate work simultaneously with drag; scale clamps at 0.15× and 6×.
- The opacity slider updates the overlay continuously during the drag, reaching a fully
  invisible 0% and a fully opaque 100%.
- Backgrounding stops the capture session; returning restarts it and preserves the overlay
  transform and opacity.
- Denying camera access shows the permission plate with a working Settings link and never
  a black empty screen.
- Portrait and landscape are both supported; the camera preview rotates with the interface.
