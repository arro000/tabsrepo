@echo off
REM ClassTab Catalog - Platform Setup Script for Windows
REM This script sets up all supported platforms for the Flutter app

echo 🚀 Setting up ClassTab Catalog for all platforms...

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter found
flutter --version | findstr /C:"Flutter"

REM Enable all desktop platforms
echo 🖥️  Enabling desktop platforms...
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

REM Create platform directories if they don't exist
echo 📁 Creating platform directories...

if not exist "ios" (
    echo 📱 Creating iOS platform...
    flutter create --platforms=ios .
)

if not exist "macos" (
    echo 🍎 Creating macOS platform...
    flutter create --platforms=macos .
)

if not exist "windows" (
    echo 🪟 Creating Windows platform...
    flutter create --platforms=windows .
)

REM Web and Linux should already exist, but let's make sure
if not exist "web" (
    echo 🌐 Creating Web platform...
    flutter create --platforms=web .
)

REM Android should already exist
if not exist "android" (
    echo 🤖 Creating Android platform...
    flutter create --platforms=android .
)

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Run flutter doctor to check setup
echo 🔍 Running Flutter doctor...
flutter doctor

echo.
echo ✅ Platform setup complete!
echo.
echo Available platforms:
echo   📱 iOS (requires macOS and Xcode)
echo   🤖 Android (requires Android SDK)
echo   🌐 Web
echo   🐧 Linux (requires Linux)
echo   🍎 macOS (requires macOS)
echo   🪟 Windows (requires Windows)
echo.
echo To build for a specific platform:
echo   flutter build android
echo   flutter build ios
echo   flutter build web
echo   flutter build linux
echo   flutter build macos
echo   flutter build windows
echo.
echo To run the app:
echo   flutter run
echo.
pause