# User guide

How to use **AR Draw** to trace a reference onto paper.

---

## What this app is for

AR Draw turns your iPhone into a see-through lightbox:

1. Point the camera at blank paper.  
2. Overlay a photo from your library.  
3. Fade it so you can still see pencil lines.  
4. Trace the outlines by hand.

It does **not** draw digitally on the screen. Your artwork stays on the paper.

---

## First launch

1. Install and open **AR Draw**.  
2. Allow **Camera** access.  
3. You’ll see a live preview and an empty-state card: **Choose a reference**.  
4. The **controls menu** (slider icon) starts open in the bottom-right corner.

If camera access is off, a dark plate explains why and offers **Open Settings**.

---

## Pick a reference photo

1. Tap the corner **slider** icon if the menu is closed.  
2. Tap **PHOTOS** (or **CHANGE PHOTO** if one is already loaded).  
3. Select an image from the system picker.  
4. The photo appears centered at **40%** opacity.  
5. The menu **closes automatically** so you can start aligning.

Images are downsampled (max ~2048px on the long edge) for smooth transforms.

---

## Align the overlay

With the menu **closed**:

| Gesture | Action |
| --- | --- |
| One-finger drag | Move the image |
| Pinch | Scale (clamped roughly 15%–600%) |
| Two-finger twist | Rotate |

Tips:

- Start with opacity around **30–50%** so pencil lines stay visible.  
- Use the faint **rule-of-thirds grid** to keep the composition steady.  
- For landscape artwork, rotate the phone to landscape and re-align.

---

## Opacity

1. Open the corner menu.  
2. Drag the **OPACITY** slider.  
3. **0%** = fully invisible · **100%** = fully opaque.  
4. Tap outside the panel (or the **X**) to close and keep tracing.

While the menu is open, overlay drag/pinch/rotate are paused so you don’t nudge the image by accident.

---

## Suggested tracing workflow

1. Tape or weight your paper so it doesn’t shift.  
2. Prop or hold the phone so the camera looks straight down at the page.  
3. Load the reference; scale until key landmarks match the paper size you want.  
4. Drop opacity until edges are clear but the page isn’t washed out.  
5. Close the menu. Trace major shapes first, then details.  
6. Raise opacity briefly to check accuracy, then lower it again.

---

## Landscape photos

- Unlock portrait orientation on the iPhone.  
- Rotate into landscape.  
- The camera preview rotates with the interface.  
- Reposition the overlay; transforms are preserved across brief backgrounding.

---

## Privacy

- Camera frames are used **only** for the on-device preview.  
- Nothing is uploaded by the app in v1.  
- Photo selection uses the system picker; the app receives the image you choose.

---

## Screenshots for GitHub

Capture on a real device for the README:

| File | Content |
| --- | --- |
| `docs/images/empty.png` | Live camera + empty-state plate + open menu |
| `docs/images/tracing.png` | Overlay aligned over paper, menu closed |
| `docs/images/menu.png` | Menu open showing Photos + opacity |
| `docs/images/landscape.png` | Landscape orientation with a wide reference |

Then update the Screenshots table in the root `README.md`.

---

## FAQ

**Can I save my drawing in the app?**  
Not in v1 — your drawing is on paper. Future versions may export a camera composite.

**Does it work on iPad?**  
The current target is iPhone-only.

**Why won’t the image move?**  
Close the corner menu, then drag.

**The preview is black.**  
Check Camera permission, or see [SETUP.md](SETUP.md#8-troubleshooting).
