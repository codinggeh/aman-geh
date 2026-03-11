# Aman-Geh

> **Simple offline watermark tool for document photos.**

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
  <img src="https://img.shields.io/badge/Privacy-100%25_Offline-brightgreen" />
</p>

## About

**Aman-Geh** helps you add a watermark to document photos before sharing them. The app runs entirely on-device, with no uploads, no tracking, and no dependency on external services.

> *"Aman"* means **safe** in Indonesian.

## Features

- 📷 **Camera & Gallery** — Take a new photo or pick from your library
- 🎨 **Customizable Watermark** — Text, opacity, size, rotation, color, and repeating pattern
- ⚡ **Real-time Preview** — See your watermark applied instantly
- 📤 **Share Result** — Share the processed image through the system share menu
- 🌙 **Light & Dark Theme** — Switch between system, light, and dark mode
- 🌐 **Multi-language** — English & Indonesian (Easy Localization)
- 🔒 **100% Offline** — No internet connection required, ever

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** pattern with feature-driven structure:

```
lib/
├── main.dart
├── app_router.dart
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/           # Material 3 theme (light & dark)
│   ├── image_engine/    # Watermark rendering (dart:ui Canvas)
│   └── utils/           # File & share helpers
└── features/
    ├── watermarker/
    │   ├── model/       # Data classes (WatermarkSettings)
    │   ├── data/        # Data sources & repository
    │   ├── viewmodel/   # Riverpod notifiers (state management)
    │   └── view/        # Screens & widgets
    └── settings/
        ├── viewmodel/   # Theme & locale state
        └── view/        # Settings & About screens
```

### Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter & Dart |
| State Management | Riverpod (Notifier) |
| Navigation | GoRouter |
| Internationalization | Easy Localization |
| Image Rendering | dart:ui Canvas API |
| Sharing | share_plus |

## Getting Started

```bash
# Clone the repository
git clone <repo-url>
cd aman_geh

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Privacy

- **All image processing is done locally on-device**
- **No internet connection required**
- **No data collection or telemetry**
- **No analytics, no ads**
- Images are processed within the app sandbox; watermarked output is not saved to the public gallery unless you choose to share it
- You decide if and where the watermarked image is shared

## Supported Languages

| Language | Code |
|---|---|
| English | `en` |
| Indonesian | `id` |

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<p align="center">Made with ❤ in Indonesia</p>
