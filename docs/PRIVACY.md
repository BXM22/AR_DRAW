# Privacy

AR Draw is designed to keep tracing **on your device**.

---

## Data the app uses

| Data | Purpose | Leaves the device? |
| --- | --- | --- |
| Camera frames | Live preview behind the overlay | **No** (not recorded or uploaded in v1) |
| Photo you pick | Reference overlay image | **No** (loaded locally via system picker) |
| Gesture / opacity state | Align and fade the overlay | **No** (in-memory only; not persisted in v1) |

---

## Permissions

- **Camera** — required for the live preview. You can revoke access in iOS Settings; the app shows a permission plate instead of a black screen.  
- **Photos** — selection uses Apple’s `PhotosPicker`. The app receives only the image you choose. A photo library usage string is declared for compatibility.

---

## What we do not do (v1)

- No accounts or sign-in  
- No analytics SDKs in the project tree  
- No ads  
- No cloud backup of camera frames or overlays  
- No sharing features that upload images  

If future versions add export or network features, this document should be updated in the same release.

---

## Contact

Questions about privacy: open an issue on [BXM22/AR_DRAW](https://github.com/BXM22/AR_DRAW/issues).
