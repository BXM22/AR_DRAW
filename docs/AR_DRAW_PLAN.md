# AR Draw — Product & Implementation Plan

## Goal

A simple iPhone app that lets someone pick a photo from their library, overlay it on the live camera feed, and adjust opacity so they can **trace the outline** onto paper (or any surface).

This is a **camera + translucent image overlay** experience (classic “trace AR”), not a full ARKit world-tracking app for v1.

---

## Core user flow

1. Open app → live camera fills the screen.
2. Tap **Photos** → pick an image from the photo library.
3. Selected image appears over the camera as a translucent overlay.
4. Drag / pinch to **move, scale, and rotate** the overlay until it lines up with the paper.
5. Use the **opacity slider** to fade the photo in/out while tracing.
6. Optional: hide chrome / lock overlay so hands don’t bump controls while drawing.

---

## Simple UI (one screen)

Keep a single composition: camera as the full-bleed canvas; controls as a light bottom bar.

```
┌─────────────────────────────┐
│                             │
│     Live camera preview     │
│                             │
│   ┌───────────────────┐     │
│   │  Photo overlay    │     │
│   │  (opacity 0–1)    │     │
│   └───────────────────┘     │
│                             │
│  [Photos]  Opacity ━━●━━    │
│            [Flip] [Lock]    │
└─────────────────────────────┘
```

### Controls (minimal)

| Control | Role |
|--------|------|
| **Photos** | Opens system photo picker |
| **Opacity slider** | 0% (invisible) → 100% (solid) overlay |
| **Flip** (optional) | Mirrors the image for front-facing / easier tracing |
| **Lock** (optional) | Freezes position/scale so gestures don’t move it while drawing |

No tabs, no onboarding maze, no cards. First open should feel like: camera on, pick photo, slide opacity, start tracing.

---

## Technical approach (SwiftUI + AVFoundation)

| Piece | Choice | Why |
|------|--------|-----|
| UI | SwiftUI | Already the project base (`ContentView.swift`) |
| Camera | `AVCaptureSession` via `UIViewRepresentable` | Reliable live preview |
| Photo library | `PhotosPicker` (PhotosUI) | Modern, privacy-friendly picker |
| Overlay | `Image` + `.opacity` + gestures | Simple, no ARKit required for tracing |
| Transform | `DragGesture` + `MagnificationGesture` + rotation | Align photo to paper |

### Why not ARKit for v1?

ARKit plane anchoring is useful later (stick image to a table that stays put as you move). For **hand tracing on paper**, a fixed screen overlay + transform gestures is simpler, faster to ship, and matches how most “AR draw / sketch” apps work.

**Later (v2):** optional ARKit horizontal-plane pinning so the reference image stays glued to the desk in 3D space.

---

## Permissions

Add usage descriptions in Xcode target → Info (or `INFOPLIST_KEY_*` in the project):

| Key | Example string |
|-----|----------------|
| `NSCameraUsageDescription` | “AR Draw needs the camera so you can see your paper while tracing.” |
| `NSPhotoLibraryUsageDescription` | “AR Draw needs photo access so you can choose an image to trace.” |

`PhotosPicker` often avoids full library access; keep the photo string anyway for broader device/OS behavior.

---

## Suggested file layout

```
AR_DRAW/
  AR_DRAWApp.swift          # App entry
  ContentView.swift         # Root: camera + overlay + controls
  CameraPreview.swift       # AVCaptureSession wrapper
  OverlayImageView.swift    # Photo layer + gestures + opacity
  TraceControlsView.swift   # Photos button + opacity slider
```

Keep each file focused and under ~200 lines.

---

## Feature specs

### 1. Camera preview
- Back camera, continuous session while view is visible.
- Pause/tear down session on background to save battery.
- Handle denied camera permission with a short inline message + link to Settings.

### 2. Photo library
- `PhotosPicker` for a single image.
- Load as `UIImage` / SwiftUI `Image`.
- If canceled, keep previous overlay (or none).

### 3. Overlay + opacity
- Default opacity ~**0.4** (good starting trace visibility).
- Slider range **0.0 – 1.0**, live update (1:1 with finger — no delayed animation).
- Overlay sits above camera, below controls.
- Gestures: pan, pinch-to-scale, two-finger rotate.
- Optional mirror toggle for left/right flip.

### 4. Trace-friendly behavior
- Controls use a dim / material bar so the drawing area stays clear.
- Lock mode disables overlay gestures.
- Prefer portrait; landscape supported if easy.

---

## Acceptance criteria (v1)

- [ ] App launches to a live camera preview.
- [ ] User can pick a photo from the library.
- [ ] Photo overlays the camera feed.
- [ ] Opacity slider fades the overlay from invisible to solid.
- [ ] User can move and scale the overlay to line up with paper.
- [ ] Camera and Photos permission prompts show clear purpose strings.
- [ ] Denied permissions show a recoverable empty/error state.

---

## Out of scope (v1)

- Saving drawings / exporting sketches
- In-app digital drawing tools (pencil on screen)
- Social sharing, accounts, paywall
- Full ARKit plane detection / 3D anchors
- Apple Pencil–specific tooling
- iPad-first layouts (nice-to-have later)

---

## Build order

1. **Camera shell** — full-screen preview + permission handling  
2. **Controls bar** — Photos button + opacity slider (wired to state)  
3. **Photo picker** — select image → set overlay state  
4. **Overlay layer** — render image with opacity  
5. **Gestures** — pan / pinch / rotate (+ optional lock & flip)  
6. **Polish** — background session pause, denied states, default opacity  

---

## State model (sketch)

```swift
@Observable
final class TraceSession {
    var selectedImage: UIImage?
    var opacity: Double = 0.4
    var offset: CGSize = .zero
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
    var isLocked: Bool = false
    var isMirrored: Bool = false
}
```

`ContentView` owns `TraceSession`, passes bindings into overlay + controls.

---

## Success definition

A user can open the app, pick a reference photo, fade it with the slider, align it over blank paper via the camera, and physically trace the outline — without menus or setup friction.
