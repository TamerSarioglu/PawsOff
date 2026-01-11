# 🐾 PawsOff

A simple macOS utility to temporarily block your keyboard — perfect for cleaning your keyboard or keeping curious paws away!

![macOS](https://img.shields.io/badge/macOS-13.0+-blue?logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange?logo=swift)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- **One-click keyboard lock** — Instantly disable all keyboard input
- **Mouse still works** — Click the unlock button when you're done
- **Touch Bar support** — Lock/unlock from the Touch Bar (MacBook Pro)
- **Visual feedback** — Clear status indicators show keyboard state
- **Auto permission check** — Guides you through accessibility setup

## 📥 Installation

```bash
git clone https://github.com/YOUR_USERNAME/PawsOff.git
cd PawsOff
open PawsOff.xcodeproj
```

Then press `⌘+R` in Xcode to build and run.

## 🔐 Accessibility Permission (Required)

PawsOff needs **Accessibility** permission to intercept keyboard events. Here's how to enable it:

1. Open **System Settings** (or use the button in the app)
2. Go to **Privacy & Security** → **Accessibility**
3. Click the **+** button and add **PawsOff**
4. Toggle the switch **ON** for PawsOff

> **Note**: If you move the app after granting permission, you may need to re-add it.

## 🚀 How to Use

1. **Launch PawsOff** — The app opens a small window
2. **Grant permission** — Follow the on-screen guide if prompted
3. **Click "Lock Keyboard"** — All keyboard input is now blocked
4. **Clean your keyboard!** — Press keys, wipe it down, let the cat walk on it
5. **Click "Unlock Keyboard"** — Your keyboard works again!

### Tips

- The mouse always works, so you can click the unlock button anytime
- The keyboard icon pulses red when locked
- Touch Bar users can toggle lock from the Touch Bar

## 🔧 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Lock Keyboard" button is disabled | Grant Accessibility permission in System Settings |
| Permission granted but still not working | Remove and re-add PawsOff in Accessibility settings |
| App won't open (unidentified developer) | Right-click → Open → Click "Open" in the dialog |
| Built from source but not working | Disable App Sandbox in Xcode project settings |

## 🛠 Development

### Requirements

- macOS 13.0+
- Xcode 15.0+

### Building

1. Clone the repository
2. Open `PawsOff.xcodeproj` in Xcode
3. Build and run (`⌘+R`)

### Important for Development

The **App Sandbox must be disabled** for `CGEvent` tap functionality to work. This is already configured in the project.

## 📄 License

MIT License — feel free to use, modify, and distribute.

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

Made with ❤️ for clean keyboards everywhere
# PawsOff
