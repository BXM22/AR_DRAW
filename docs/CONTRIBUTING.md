# Contributing

Thanks for helping improve **AR Draw**. This guide keeps the tracing experience fast, clear, and easy to maintain.

---

## Ground rules

1. **Prefer device testing** for camera changes — Simulator is not enough.  
2. **Don’t block the main thread** with `AVCaptureSession` configure/start/stop.  
3. **Keep the canvas clear** — new chrome should collapse or sit in the corner menu.  
4. **No duplicate Swift basenames** inside `AR_DRAW/` (synchronized Xcode group).  
5. **Match Tracer visuals** — zero corner radius, accent `#EC3013`, condensed uppercase labels (see [design.md](design.md)).

---

## Getting started

1. Fork and clone, or clone directly if you have write access.  
2. Follow [SETUP.md](SETUP.md).  
3. Read [ARCHITECTURE.md](ARCHITECTURE.md) before camera/overlay PRs.  
4. Create a branch:

```bash
git checkout -b fix/short-description
# or
git checkout -b feature/short-description
```

---

## Development workflow

```bash
open AR_DRAW.xcodeproj
# Build to a physical iPhone (⌘R)
```

Checklist before you push:

- [ ] Builds without warnings you introduced  
- [ ] Camera still starts quickly with permission already granted  
- [ ] Overlay gestures work with the menu closed  
- [ ] Menu open does not leave gestures stuck on  
- [ ] Landscape still rotates the preview correctly  
- [ ] Denied-camera path still shows Settings  

---

## Commit messages

Prefer short, imperative summaries focused on **why**:

```text
Speed up camera start by using HD preset on a session queue

Collapse controls into a corner menu while tracing
```

Avoid noisy “fix stuff” or “wip” on `main`.

---

## Pull requests

1. Push your branch.  
2. Open a PR against `main` on [BXM22/AR_DRAW](https://github.com/BXM22/AR_DRAW).  
3. Include:

```markdown
## Summary
- What changed and why it helps tracing / DX

## Test plan
- [ ] Device: model + iOS
- [ ] Camera permission allow / deny
- [ ] Pick photo, pan/pinch/rotate
- [ ] Opacity 0% and 100%
- [ ] Menu open/close + auto-close after pick
- [ ] Background / foreground session
```

UI changes: attach a short screen recording or before/after stills when possible.

---

## Code style

- SwiftUI views stay focused; extract controls into `Controls/` or `Overlay/`.  
- Use `Theme` tokens instead of one-off colors.  
- Prefer value types for transform math (`OverlayTransform`).  
- Keep files well under ~300–400 lines when practical.  
- No secrets, API keys, or credentials in the repo.

---

## Issues

Use GitHub Issues for bugs and feature requests. Include:

- iPhone model and iOS version  
- Whether camera permission was allowed  
- Steps to reproduce  
- Expected vs actual behavior  

---

## Documentation PRs

Docs live under `docs/` plus the root `README.md`. When behavior changes (gestures, menu, permissions), update the matching guide in the same PR:

| Change area | Update |
| --- | --- |
| User-facing flow | `USER_GUIDE.md`, root `README.md` |
| Setup / signing | `SETUP.md` |
| Internals | `ARCHITECTURE.md` |
| Scope / future | `ROADMAP.md` |
| Visual system | `design.md` |

---

## Code of conduct

Be respectful. Assume good intent. Harassment or spam will not be tolerated; maintainers may close PRs/issues that violate that bar.

---

## License

Upstream license is not yet declared in the repository. Do not assume MIT (or any specific license) until a `LICENSE` file is added — ask in an issue if you need clarity for redistribution.
