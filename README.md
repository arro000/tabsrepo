# ClassTab Catalog

A Flutter application for cataloging and viewing classical guitar tablatures from [ClassTab.org](https://www.classtab.org).

## Features

### 🎵 Tablature Cataloging
- Over 3000 classical guitar tablatures
- Organized by composer
- Advanced search by title, composer, and opus
- Filters for difficulty, features (MIDI, LHF, Video)

### 🎼 Visualization
- Optimized display of tablatures in text format
- Monospace font for perfect alignment
- Font size control
- Option to show line numbers
- Highlighting of important information

### 🎹 MIDI Playback
- Playback of MIDI files associated with tablatures
- Playback controls (play, pause, stop)
- Volume and tempo control
- Loop mode
- Local cache for offline playback

### ⭐ Favorites Management
- Save favorite tablatures
- Quick access to favorite pieces
- Complete favorites list management

### 🔄 Synchronization
- Automatic download from ClassTab.org
- ZIP file extraction and parsing (13MB)
- Update checking
- Incremental synchronization

## Tablature Structure

Tablatures come from ClassTab.org and include:

- **Composer**: Composer's name
- **Title**: Piece title
- **Opus**: Opus number (when available)
- **Key**: Musical key
- **Difficulty**: Difficulty level (easy, intermediate, advanced)
- **MIDI**: MIDI file for listening
- **LHF**: Left Hand Fingering
- **Video**: Links to demonstration videos

## Technologies Used

### Framework and Languages
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language

### State Management
- **Provider**: State management pattern

### Database and Storage
- **SQLite**: Local database for tablatures
- **SharedPreferences**: App settings
- **Path Provider**: File path management

### Networking and Parsing
- **Dio**: HTTP client for downloads
- **HTML Parser**: Web page parsing
- **Archive**: ZIP file handling

### Audio
- **Flutter MIDI Command**: MIDI file playback

### UI Components
- **Material Design Icons**: Additional icons
- **Flutter SpinKit**: Loading indicators
- **Flutter TypeAhead**: Search with suggestions

## Installation

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator

### Quick Setup

Use the provided setup scripts to configure all platforms:

**Linux/macOS:**
```bash
./setup_platforms.sh
```

**Windows:**
```cmd
setup_platforms.bat
```

### Manual Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd classtab_catalog
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform Support

The app supports multiple platforms:
- 📱 **Android** (API 21+)
- 🍎 **iOS** (iOS 12.0+)
- 🌐 **Web** (Modern browsers)
- 🐧 **Linux** (Ubuntu 18.04+)
- 🍎 **macOS** (macOS 10.14+)
- 🪟 **Windows** (Windows 10+)

## Building and Releases

### Automated Builds

The project includes GitHub Actions workflows for automated building and releasing:

- **CI Workflow**: Runs tests and basic builds on every push/PR
- **Release Workflow**: Builds for all platforms and creates releases

### Creating a Release

1. **Tag a version:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **The workflow automatically:**
   - Builds for all supported platforms
   - Runs tests
   - Creates a GitHub release
   - Uploads build artifacts

### Manual Building

Build for specific platforms:

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build linux --release    # Linux only
flutter build macos --release    # macOS only
flutter build windows --release  # Windows only
```

## Usage

### Initial Setup
1. Open the app
2. Tap the synchronization button on the home screen
3. Confirm the download (about 13MB)
4. Wait for synchronization to complete

### Searching Tablatures
1. Go to the "Search" tab
2. Enter search term
3. Use filters to refine results
4. Tap a tablature to view it

### MIDI Playback
1. Open a tablature with MIDI file
2. Use MIDI player controls
3. Adjust volume and speed according to preferences

### Managing Favorites
1. Tap the heart icon on a tablature
2. Go to the "Favorites" tab to see them all
3. Remove from favorites by tapping the heart again

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── tablature.dart
├── providers/                # State management
│   ├── tablature_provider.dart
│   └── midi_provider.dart
├── services/                 # Business logic services
│   ├── database_service.dart
│   └── classtab_service.dart
├── screens/                  # App screens
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── favorites_screen.dart
│   ├── composers_screen.dart
│   ├── composer_detail_screen.dart
│   ├── tablature_detail_screen.dart
│   └── settings_screen.dart
└── widgets/                  # Reusable widgets
    ├── tablature_card.dart
    ├── statistics_card.dart
    ├── search_filters.dart
    └── midi_player_widget.dart
```

## Future Features

- [ ] PDF export of tablatures
- [ ] Tablature sharing
- [ ] Complete offline mode
- [ ] Support for custom tablatures
- [ ] YouTube integration for videos
- [ ] Integrated metronome
- [ ] Guitar tuner

## Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is distributed under the MIT License. See the `LICENSE` file for details.

## Acknowledgments

- **ClassTab.org**: For the fantastic collection of classical guitar tablatures
- **Flutter Team**: For the excellent framework
- **Open Source Community**: For the libraries used

## Support

For support, bug reports, or feature requests:
- Open an issue on GitHub
- Contact the development team

---

**Note**: This application is an unofficial client for ClassTab.org. All rights to the tablatures belong to their respective authors and ClassTab.org.