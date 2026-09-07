# Roadmap

Living list of ideas for **AR Draw**. Order is preference, not a commitment.

---

## Shipped (v1)

- [x] Full-bleed back-camera preview  
- [x] PhotosPicker reference selection  
- [x] Pan / pinch / rotate overlay  
- [x] Live opacity (default 40%)  
- [x] Rule-of-thirds grid  
- [x] Permission denied plate  
- [x] Portrait + landscape  
- [x] Fast camera startup (session queue + HD preset)  
- [x] Collapsible corner controls menu  

---

## Near term

| Item | Notes |
| --- | --- |
| Reset transform | Menu action → `OverlayTransform.initial` with snappy animation |
| Mirror / flip | Useful for tracing transfers and left-handed layouts |
| App icon & display name | “Tracer” / “AR Draw” branding polish |
| README screenshots | Capture set under `docs/images/` |
| License file | Declare MIT (or other) explicitly |
| Unit tests | Clamp + transform combine + image downsample |

---

## Medium term

| Item | Notes |
| --- | --- |
| Flashlight toggle | Helpful in dim rooms |
| Grid on/off | Some users want a clean view |
| Aspect lock / fit-to-paper presets | One-tap scale helpers |
| Remember last opacity | `AppStorage` |
| Haptics on menu open/close | Subtle feedback |

---

## Longer term

| Item | Notes |
| --- | --- |
| ARKit plane pinning | World-lock overlay to a desk; keep screen-space fallback |
| Snapshot / export | Save camera + overlay composite (privacy-sensitive; on-device only) |
| Multiple references | Swap stack or simple layer list |
| iPad layout | Larger canvas, optional sidebar controls |
| Pencil / markup (optional) | Only if it stays secondary to paper tracing |

---

## Explicit non-goals (for now)

- Accounts, cloud sync, or social feeds  
- Generative AI “auto draw”  
- Android port (separate project if ever)  
- Requiring ARKit for the core tracing loop  

---

## Feedback welcome

Open a [GitHub Issue](https://github.com/BXM22/AR_DRAW/issues) with:

- **Bug** — device model, iOS version, steps  
- **Feature** — the tracing problem it solves  
- **Design** — screenshots or references welcome  
