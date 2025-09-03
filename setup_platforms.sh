#!/bin/bash

# ClassTab Catalog - Platform Setup Script
# This script sets up all supported platforms for the Flutter app

echo "🚀 Setting up ClassTab Catalog for all platforms..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Enable all desktop platforms
echo "🖥️  Enabling desktop platforms..."
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Create platform directories if they don't exist
echo "📁 Creating platform directories..."

if [ ! -d "ios" ]; then
    echo "📱 Creating iOS platform..."
    flutter create --platforms=ios .
fi

if [ ! -d "macos" ]; then
    echo "🍎 Creating macOS platform..."
    flutter create --platforms=macos .
fi

if [ ! -d "windows" ]; then
    echo "🪟 Creating Windows platform..."
    flutter create --platforms=windows .
fi

# Web and Linux should already exist, but let's make sure
if [ ! -d "web" ]; then
    echo "🌐 Creating Web platform..."
    flutter create --platforms=web .
fi

# Android should already exist
if [ ! -d "android" ]; then
    echo "🤖 Creating Android platform..."
    flutter create --platforms=android .
fi

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run flutter doctor to check setup
echo "🔍 Running Flutter doctor..."
flutter doctor

echo ""
echo "✅ Platform setup complete!"
echo ""
echo "Available platforms:"
echo "  📱 iOS (requires macOS and Xcode)"
echo "  🤖 Android (requires Android SDK)"
echo "  🌐 Web"
echo "  🐧 Linux (requires Linux)"
echo "  🍎 macOS (requires macOS)"
echo "  🪟 Windows (requires Windows)"
echo ""
echo "To build for a specific platform:"
echo "  flutter build android"
echo "  flutter build ios"
echo "  flutter build web"
echo "  flutter build linux"
echo "  flutter build macos"
echo "  flutter build windows"
echo ""
echo "To run the app:"
echo "  flutter run"