# Setup guide

How to clone, configure, and run **AR Draw** on a physical iPhone.

---

## 1. Prerequisites

- A Mac with **Xcode 26+** (or the version that matches the project’s iOS 26 deployment target)
- An **Apple ID** (free provisioning works for personal devices; a paid Developer Program membership is required for distribution)
- A physical **iPhone** on a supported iOS version  
  - The **Simulator cannot provide a real camera feed**. You can still build and exercise Photos / UI there, but tracing requires a device.

---

## 2. Clone and open

```bash
git clone https://github.com/BXM22/AR_DRAW.git
cd AR_DRAW
open AR_DRAW.xcodeproj
```

Alternatively, use *File → Clone* in Xcode and paste the repo URL.

---

## 3. Signing

1. Select the **AR_DRAW** project in the Project Navigator.  
2. Select the **AR_DRAW** target → **Signing & Capabilities**.  
3. Enable **Automatically manage signing**.  
4. Choose your **Team**.  
5. If the bundle ID `com.app.com.AR-DRAW` conflicts on your account, change it to something unique (e.g. `com.yourname.AR-DRAW`).

The Tests and UITests targets can use the same team or remain unsigned for local UI experiments.

---

## 4. Run on device

1. Connect the iPhone with a cable (or pair via wireless debugging).  
2. Trust the computer on the device if prompted.  
3. In Xcode, select the **AR_DRAW** scheme and your iPhone as the run destination.  
4. Press **Run** (`⌘R`).  
5. On first launch from a free/personal team, open **Settings → General → VPN & Device Management** and trust the developer certificate.  
6. When the app asks for **Camera**, choose **Allow**.

---

## 5. Permissions checklist

| Prompt | Expected copy (summary) | If denied |
| --- | --- | --- |
| Camera | Tracer shows your camera so you can line a reference photo up with your paper | In-app plate → **Open Settings** |
| Photos | Handled mainly by `PhotosPicker`; library string is declared as fallback | Re-open the picker; grant access if iOS asks |

Usage strings live in the target’s generated Info.plist keys inside `AR_DRAW.xcodeproj/project.pbxproj`:

- `INFOPLIST_KEY_NSCameraUsageDescription`
- `INFOPLIST_KEY_NSPhotoLibraryUsageDescription`

---

## 6. Orientations

Supported interface orientations (iPhone):

- Portrait  
- Landscape Left  
- Landscape Right  

Enable **Portrait Orientation Lock** off on the device when tracing landscape references.

---

## 7. Build from the command line

```bash
# List simulators / devices
xcodebuild -project AR_DRAW.xcodeproj -scheme AR_DRAW -showdestinations

# Simulator compile check (no real camera)
xcodebuild \
  -project AR_DRAW.xcodeproj \
  -scheme AR_DRAW \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build

# Device (replace id)
xcodebuild \
  -project AR_DRAW.xcodeproj \
  -scheme AR_DRAW \
  -destination 'id=YOUR_DEVICE_UDID' \
  build
```

---

## 8. Troubleshooting

### Black screen / “stuck” camera

- Confirm Camera permission is **Allow** in Settings → AR Draw.  
- Force-quit the app and relaunch.  
- Unplug/replug the device; ensure no other app holds the camera.  
- Clean build folder in Xcode (`⇧⌘K`), then rebuild.

The session uses a dedicated queue and an `.hd1280x720` preset for faster preview startup. Stopping only happens on **background**, not brief inactive interruptions.

### “Multiple commands produce … OverlayImageView.stringsdata”

The app target uses a **synchronized root group**. Do **not** keep duplicate Swift filenames at both `AR_DRAW/` and `AR_DRAW/Overlay/`. Keep a single path per type (see [ARCHITECTURE.md](ARCHITECTURE.md)).

### Signing / “Failed to install”

- Refresh the Team and bundle ID.  
- Trust the developer profile on the device.  
- Delete any old install of the app, then re-run.

### Photos button does nothing

- Controls may be disabled when camera access is denied.  
- Open the **corner menu** (slider icon); Photos lives inside the panel.

### Overlay won’t move

- Close the menu first. Overlay gestures are disabled while the menu is open so opacity adjustments don’t drag the image.

---

## 9. Project configuration reference

| Setting | Value |
| --- | --- |
| Product name | AR_DRAW |
| Bundle identifier | `com.app.com.AR-DRAW` |
| Marketing version | 1.0 |
| Deployment target | iOS 26.0 |
| Device family | iPhone (`TARGETED_DEVICE_FAMILY = 1`) |
| Mac Catalyst | Disabled |

---

## 10. Next steps

- Read the [User guide](USER_GUIDE.md) for gesture tips.  
- Browse [Architecture](ARCHITECTURE.md) before changing camera or overlay code.  
- Follow [Contributing](CONTRIBUTING.md) for pull requests.
