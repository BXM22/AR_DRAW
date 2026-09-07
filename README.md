# AR Draw (Tracer)

**Trace any reference photo onto paper using your iPhone camera.**

AR Draw overlays a translucent image from your Photo Library on a live camera feed so you can line it up with a blank page and draw what you see. One screen. No accounts. No ARKit world tracking for v1 — just a fast camera + overlay tool built for artists, students, and anyone who learns by tracing.

[![Platform](https://img.shields.io/badge/platform-iOS%2026%2B-black)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://swift.org)
[![UI](https://img.shields.io/badge/UI-SwiftUI-blue)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/license-TBD-lightgrey)](#license)

> **Repo:** [github.com/BXM22/AR_DRAW](https://github.com/BXM22/AR_DRAW)

---

## Table of contents

- [Features](#features)
- [How it works](#how-it-works)
- [Screenshots](#screenshots)
- [Requirements](#requirements)
- [Quick start](#quick-start)
- [Permissions](#permissions)
- [Project structure](#project-structure)
- [Tech stack](#tech-stack)
- [Documentation](#documentation)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Features

| Feature | Description |
| --- | --- |
| **Live camera preview** | Full-bleed back camera, optimized for fast startup |
| **Photo Library picker** | Choose any reference image via `PhotosPicker` |
| **Translucent overlay** | Default **40%** opacity; fade from invisible to solid |
| **Pan / pinch / rotate** | Align the overlay to your paper with multitouch gestures |
| **Collapsible controls** | Corner menu keeps Photos + opacity off the canvas while you draw |
| **Rule-of-thirds grid** | Faint composition guides over the preview |
| **Portrait & landscape** | Rotate the phone for landscape reference photos |
| **Permission handling** | Clear denied-state UI with a link to Settings |
| **Session lifecycle** | Capture stops in the background and resumes on return |

### Deliberately not in v1

- ARKit plane pinning / world-locked overlays  
- On-screen drawing or annotation tools  
- Export / capture of composites  
- Multiple layers or blend modes  
- iPad or Mac Catalyst targets  

See [docs/ROADMAP.md](docs/ROADMAP.md) for planned work.

---

## How it works

```
┌─────────────────────────────────────┐
│         Live camera (full bleed)    │
│                                     │
│     ┌───────────────────────┐       │
│     │  Reference overlay    │       │
│     │  (opacity 0–100%)     │       │
│     └───────────────────────┘       │
│                                     │
│                          ┌───┐      │
│                          │ ≡ │ menu │
└─────────────────────────────────────┘
```

1. Open the app and allow **Camera** access.  
2. Tap the **corner menu** → **Photos** and pick a reference image.  
3. The menu closes automatically so the canvas stays clear.  
4. **Drag** to move, **pinch** to scale, **twist** to rotate until the image sits on your paper.  
5. Re-open the menu anytime to tweak **opacity** or change the photo.  
6. Trace the outline with a pencil on real paper.

---

## Screenshots

> Add device screenshots here after you capture them (Simulator or a physical iPhone).

| Empty state | Overlay aligned | Menu open |
| --- | --- | --- |
| *TODO: `docs/images/empty.png`* | *TODO: `docs/images/tracing.png`* | *TODO: `docs/images/menu.png`* |

Suggested shot list is in [docs/USER_GUIDE.md](docs/USER_GUIDE.md#screenshots-for-github).

---

## Requirements

| Item | Version / note |
| --- | --- |
| **Xcode** | 26+ (matches project settings) |
| **iOS deployment target** | 26.0 |
| **Device** | **Physical iPhone recommended** (Simulator has no real camera) |
| **Languages / frameworks** | Swift 5, SwiftUI, AVFoundation, PhotosUI |
| **Orientations** | Portrait, landscape left, landscape right |
| **Bundle ID** | `com.app.com.AR-DRAW` |

---

## Quick start

```bash
git clone https://github.com/BXM22/AR_DRAW.git
cd AR_DRAW
open AR_DRAW.xcodeproj
```

1. Select the **AR_DRAW** scheme and your connected iPhone.  
2. Ensure your **Team** is set under *Signing & Capabilities*.  
3. Build and run (`⌘R`).  
4. Grant camera access when prompted.  
5. Open the corner menu → pick a photo → align → trace.

Full setup notes (signing, permissions, common issues): **[docs/SETUP.md](docs/SETUP.md)**.

---

## Permissions

| Key | Purpose |
| --- | --- |
| `NSCameraUsageDescription` | Live preview so you can line a reference up with paper |
| `NSPhotoLibraryUsageDescription` | Fallback string for loading a reference image |

`PhotosPicker` runs out-of-process and usually does not require full library access; the photo usage string remains declared for compatibility.

---

## Project structure

```
AR_DRAW/
├── AR_DRAW/                      # App sources
│   ├── AR_DRAWApp.swift          # App entry → CameraOverlayView
│   ├── Camera/
│   │   ├── CameraSession.swift   # AVCaptureSession, auth, start/stop
│   │   └── CameraPreview.swift   # UIViewRepresentable preview layer
│   ├── Overlay/
│   │   ├── OverlayTransform.swift
│   │   ├── OverlayImageView.swift
│   │   └── OverlayGestures.swift
│   ├── Screens/
│   │   ├── CameraOverlayView.swift   # Single app screen
│   │   └── PermissionPlate.swift
│   ├── Controls/
│   │   ├── BottomBar.swift           # ControlsMenu (corner toggle)
│   │   ├── OpacitySlider.swift
│   │   └── GridOverlay.swift
│   ├── Support/
│   │   ├── Theme.swift
│   │   └── ImageLoader.swift
│   └── Assets.xcassets/
├── AR_DRAWTests/
├── AR_DRAWUITests/
├── AR_DRAW.xcodeproj/
└── docs/                         # Extended documentation
```

Architecture deep dive: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.

---

## Tech stack

| Layer | Choice | Why |
| --- | --- | --- |
| UI | SwiftUI | Single-screen composition, modern state |
| Camera | AVFoundation (`AVCaptureSession`) | Reliable live preview without ARKit cost |
| Photos | PhotosUI (`PhotosPicker`) | Privacy-friendly picker |
| Overlay | SwiftUI transforms + simultaneous gestures | 1:1 finger tracking for tracing |
| Design | Custom tokens (accent `#EC3013`, ink, paper) | Sharp, zero-radius Tracer visual language |

Performance notes for camera startup live in [docs/ARCHITECTURE.md#camera-pipeline](docs/ARCHITECTURE.md#camera-pipeline).

---

## Documentation

| Document | Contents |
| --- | --- |
| [docs/SETUP.md](docs/SETUP.md) | Install, signing, run on device, troubleshooting |
| [docs/USER_GUIDE.md](docs/USER_GUIDE.md) | End-user how-to, gestures, tips |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Modules, data flow, gestures, lifecycle |
| [docs/design.md](docs/design.md) | Tracer v1 design specification |
| [docs/AR_DRAW_PLAN.md](docs/AR_DRAW_PLAN.md) | Original product / implementation plan |
| [docs/PRIVACY.md](docs/PRIVACY.md) | On-device camera & photo handling |
| [docs/CHANGELOG.md](docs/CHANGELOG.md) | Release history |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Near-term and future ideas |
| [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) | How to contribute |

---

## Roadmap

**Near term**

- [ ] In-menu reset transform  
- [ ] Optional overlay flip (mirror)  
- [ ] App icon & launch assets polish  
- [ ] GitHub screenshot set  

**Later**

- [ ] ARKit horizontal-plane pinning  
- [ ] Save / share a composite frame  
- [ ] iPad layout  

Details: [docs/ROADMAP.md](docs/ROADMAP.md).

---

## Contributing

Issues and pull requests are welcome. Please read **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)** before opening a PR.

```bash
# Typical flow
git checkout -b feature/my-change
# …edit, build on device…
git commit -m "Describe why this change helps tracing"
git push -u origin HEAD
```

---

## License

License not yet declared. If you fork or redistribute, please open an issue requesting a license choice (e.g. MIT), or contact the repository owner.

---

## Acknowledgments

- Built with SwiftUI, AVFoundation, and PhotosUI  
- Visual language inspired by the Tracer design spec in `docs/design.md`  

---

**Made for tracing on real paper.** Hold the phone over your sketchbook, fade the reference, and draw.
