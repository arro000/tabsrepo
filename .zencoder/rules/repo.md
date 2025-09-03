---
description: Repository Information Overview
alwaysApply: true
---

# ClassTab Catalog Information

## Summary
ClassTab Catalog is a Flutter application for cataloging and viewing classical guitar tablatures from ClassTab.org. It provides features for browsing over 3000 tablatures, advanced search capabilities, MIDI playback, and favorites management.

## Structure
- **lib/**: Core application code (models, providers, services, screens, widgets)
- **assets/**: Application resources (images, sounds)
- **android/**: Android platform-specific configuration
- **test/**: Test files for the application
- **build/**: Generated build files
- **fonts/**: Font resources for the application

## Language & Runtime
**Language**: Dart
**Version**: SDK >=3.0.0 <4.0.0
**Framework**: Flutter >=3.10.0
**Build System**: Flutter build system
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- flutter: Core framework
- provider: ^6.1.1 (State management)
- sqflite: ^2.3.0 (Local database)
- flutter_midi_command: ^0.4.15 (MIDI playback)
- dio: ^5.3.2 (HTTP client)
- html: ^0.15.4 (HTML parsing)
- archive: ^3.4.9 (ZIP file handling)
- shared_preferences: ^2.2.2 (Settings storage)

**Development Dependencies**:
- flutter_test: Testing framework
- flutter_lints: ^3.0.0 (Code linting)

## Build & Installation
```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the application
flutter run

# Build for Android
flutter build apk

# Build for web
flutter build web
```

## Testing
**Framework**: flutter_test
**Test Location**: test/
**Naming Convention**: *_test.dart
**Run Command**:
```bash
flutter test
```

## Project Components

### Models
- **tablature.dart**: Data model for guitar tablatures

### Providers (State Management)
- **tablature_provider.dart**: Manages tablature data state
- **midi_provider.dart**: Handles MIDI playback state

### Services
- **database_service.dart**: SQLite database operations
- **classtab_service.dart**: Handles communication with ClassTab.org

### Screens
- **home_screen.dart**: Main application screen
- **search_screen.dart**: Search functionality
- **favorites_screen.dart**: Saved tablatures
- **composers_screen.dart**: Browse by composer
- **composer_detail_screen.dart**: Composer information
- **tablature_detail_screen.dart**: Tablature viewer
- **settings_screen.dart**: Application settings

### Widgets
- **tablature_card.dart**: Displays tablature preview
- **statistics_card.dart**: Shows usage statistics
- **search_filters.dart**: Search filtering options
- **midi_player_widget.dart**: MIDI playback controls