# Architecture

Technical overview of **AR Draw (Tracer)** for contributors.

---

## High-level design

AR Draw is a **single-screen** SwiftUI app. The mental model is a layered compositor:

```
┌──────────────────────────────────────────┐
│ ControlsMenu (corner toggle + panel)     │  hit-tested chrome
├──────────────────────────────────────────┤
│ Empty / permission plates (conditional)  │
├──────────────────────────────────────────┤
│ Gesture layer (Color.clear)              │  only when menu closed
├──────────────────────────────────────────┤
│ OverlayImageView (no hit testing)        │  photo + transform + opacity
├──────────────────────────────────────────┤
│ GridOverlay                              │  decorative, no hits
├──────────────────────────────────────────┤
│ CameraPreview (AVCaptureVideoPreviewLayer)│ full-bleed preview
└──────────────────────────────────────────┘
```

There is **no ARKit** session in v1. World tracking is intentionally deferred; screen-space overlay + gestures are enough for paper tracing and start faster.

---

## Module map

| Folder | Responsibility |
| --- | --- |
| `AR_DRAWApp.swift` | `@main` entry; hosts `CameraOverlayView` |
| `Camera/` | Capture session ownership + preview representable |
| `Overlay/` | Transform value type, image view, gesture modifier |
| `Screens/` | Root UI composition + permission/empty plates |
| `Controls/` | Menu, opacity slider, grid |
| `Support/` | Theme tokens + image downsampling |

Xcode uses a **PBXFileSystemSynchronizedRootGroup** for `AR_DRAW/`. Files added under that folder are picked up automatically — **do not duplicate basenames** (e.g. two `CameraPreview.swift` files).

---

## State ownership

All tracing UI state lives in `CameraOverlayView`:

| State | Role |
| --- | --- |
| `camera: CameraSession` | Auth + `AVCaptureSession` |
| `pickedItem: PhotosPickerItem?` | Picker selection |
| `overlayImage: Image?` | Loaded reference |
| `committed` / `live: OverlayTransform` | Gesture math (see below) |
| `opacity: Double` | 0…1, default `0.4` |
| `isMenuOpen: Bool` | Controls visibility; starts `true` |

`CameraSession` is `@Observable`. UI reacts to `authorizationStatus` only; session start/stop does not thrash the view tree with running flags.

---

## Camera pipeline

### Goals

- Preview visible quickly after launch when permission is already granted  
- No main-thread stalls on `startRunning`  
- No start/stop races during brief `.inactive` interruptions  

### Implementation (`CameraSession`)

1. **`init`** reads `AVCaptureDevice.authorizationStatus` synchronously.  
2. If already **authorized**, `start()` is scheduled immediately (does not wait for SwiftUI `.task`).  
3. All configure / start / stop work runs on a dedicated serial queue:  
   `com.ardraw.camera.session`.  
4. Preset prefers **`.hd1280x720`** (falls back to `.high`).  
   Avoid `.photo` for preview-only — it warms a still-capture path and slows open.  
5. `CameraOverlayView` stops the session only on **`.background`**, and restarts on **`.active`**.

### Preview (`CameraPreview`)

- `UIViewRepresentable` wrapping `AVCaptureVideoPreviewLayer`  
- `videoGravity = .resizeAspectFill`  
- Rotation via `connection.videoRotationAngle` from the window scene’s `interfaceOrientation`  
- `updateUIView` only rebinds the session if the instance changed  

---

## Overlay transforms

`OverlayTransform` is a value type:

```swift
struct OverlayTransform: Equatable {
    var offset: CGSize   // default (0, -20)
    var scale: CGFloat   // default 1, clamped 0.15…6
    var rotation: Angle
}
```

### Committed vs live

Gestures never accumulate twice:

- **`live`** holds in-flight deltas (translation / magnification / rotation).  
- **`committed`** stores values after `.onEnded`.  
- The view renders `committed.combining(live:)`.

Apply order on the image:

```text
scaleEffect → rotationEffect → offset → opacity
```

### Gestures (`OverlayGestures`)

`SimultaneousGesture` of:

- `DragGesture`  
- `MagnificationGesture`  
- `RotationGesture`  

Attached to a **transparent full-screen layer**, not the image. The image uses `allowsHitTesting(false)` so opacity/visuals stay independent of hit targets.

Gestures are **disabled while `isMenuOpen`** so slider interaction cannot drag the overlay.

---

## Photo loading (`ImageLoader`)

1. `PhotosPickerItem.loadTransferable(type: Data.self)`  
2. Background downsample with `CGImageSource` thumbnail API (`maxDimension ≈ 2048`)  
3. Publish `Image(uiImage:)` on the main actor  
4. Reset transform to `.initial`; **keep** current opacity  
5. Auto-close the controls menu after a successful load  

---

## Controls menu

`ControlsMenu` (in `Controls/BottomBar.swift`):

- Collapsed: 48×48 material button, `slider.horizontal.3` / `xmark`  
- Expanded: panel with Photos picker + custom opacity slider + accent top rule  
- Scrim tap dismisses  
- Animation: `.snappy(duration: 0.22)`  

`OpacitySlider` is a custom track (2pt) + square accent thumb (16×28), 44pt hit height — matches the Tracer design tokens in `Theme`.

---

## Theming (`Theme`)

| Token | Value |
| --- | --- |
| Accent | `#EC3013` |
| Ink | `#201E1D` |
| Paper | `#F3F2F2` |
| On-camera text | white / 0.78 / 0.62 opacities |
| Shape language | Zero corner radius |
| Labels | Condensed system grotesque, uppercase tracking |

---

## Permissions UX

| Status | UI |
| --- | --- |
| `notDetermined` | Ink backdrop; request on appear |
| `authorized` | Live `CameraPreview` |
| `denied` / `restricted` | `PermissionPlate` + Settings link; menu controls dimmed (45%) |

---

## Testing targets

| Target | Role |
| --- | --- |
| `AR_DRAWTests` | Unit test host (scaffold) |
| `AR_DRAWUITests` | UI test host (scaffold) |

Priority unit-test seams if you extend coverage:

- `OverlayTransform.combining` / scale clamping  
- `ImageLoader` downsample bounds  
- Auth status → UI branch mapping (with a protocol over `CameraSession`)

---

## Extension points (safe places to change)

| Want… | Touch… |
| --- | --- |
| New control in the menu | `ControlsMenu` panel only |
| Different default opacity | `CameraOverlayView` `@State opacity` |
| Faster/lower-res preview | `CameraSession.configureIfNeeded` preset |
| ARKit pinning later | New module; keep screen overlay as fallback |
| Flip / reset | Menu actions mutating `OverlayTransform` |

---

## Anti-patterns to avoid

- Configuring `AVCaptureSession` on the main thread  
- Stopping the session on `.inactive`  
- Putting hit-testing on the overlay image itself  
- Committing gesture scale *and* keeping magnification as a multiplier without reset  
- Duplicating Swift filenames under the synchronized `AR_DRAW` group  
