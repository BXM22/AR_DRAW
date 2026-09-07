# Changelog

All notable changes to **AR Draw** are documented here.

Format inspired by [Keep a Changelog](https://keepachangelog.com/).

---

## [Unreleased]

Documentation pack for GitHub (README, setup, architecture, contributing, privacy, roadmap).

---

## [1.0.0] — 2026-09-06

### Added

- Live back-camera preview with authorization and denied-state UI  
- PhotosPicker reference selection with ~2048px downsample  
- Overlay pan, pinch-scale (0.15…6), and rotation  
- Opacity slider (default 40%)  
- Rule-of-thirds grid  
- Portrait and landscape support with preview rotation  
- Collapsible corner **ControlsMenu** (Photos + opacity)  
- Tracer visual tokens (accent `#EC3013`, ink/paper, zero radius)  
- Design and product planning docs under `docs/`  

### Performance

- Camera configure/start on a dedicated session queue  
- Preview preset `.hd1280x720` instead of `.photo`  
- Warm start when camera permission already granted  
- Stop capture only on background (not inactive)  

### Fixed

- Duplicate synchronized Swift filenames causing “Multiple commands produce” build errors  

---

## Versioning notes

The Xcode **Marketing Version** is `1.0`. Git tags may be added later (`v1.0.0`) when cutting releases.
