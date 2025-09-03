# GitHub Workflows

This directory contains GitHub Actions workflows for the ClassTab Catalog Flutter application.

## Workflows

### 1. CI Workflow (`ci.yml`)

**Trigger**: Push to `main` or `develop` branches, Pull Requests

**Purpose**: Continuous Integration - runs tests and basic builds on every push/PR

**Jobs**:
- **Test**: Runs Flutter tests, formatting checks, and analysis
- **Build Test**: Tests building for Android and Web platforms

### 2. Build and Release Workflow (`build-release.yml`)

**Trigger**: 
- Push to tags matching `v*` (e.g., `v1.0.0`)
- Manual workflow dispatch

**Purpose**: Builds the app for all supported platforms and creates a GitHub release

**Jobs**:
- **build-android**: Builds APK and AAB for Android
- **build-web**: Builds web application
- **build-linux**: Builds Linux desktop application
- **build-windows**: Builds Windows desktop application
- **build-macos**: Builds macOS desktop application
- **build-ios**: Builds iOS application (unsigned)
- **create-release**: Creates GitHub release with all artifacts

## Supported Platforms

| Platform | Build Output | Notes |
|----------|--------------|-------|
| Android | APK, AAB | Ready for distribution |
| iOS | IPA (unsigned) | Requires code signing for App Store |
| Web | Static files | Can be deployed to any web server |
| Windows | Executable + DLLs | Windows 10+ |
| macOS | .app bundle | macOS 10.14+ |
| Linux | Executable | Ubuntu 18.04+ or equivalent |

## Creating a Release

### Automatic Release (Recommended)

1. Create and push a version tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. The workflow will automatically:
   - Build for all platforms
   - Run tests
   - Create a GitHub release
   - Upload all build artifacts

### Manual Release

1. Go to the "Actions" tab in your GitHub repository
2. Select "Build and Release" workflow
3. Click "Run workflow"
4. Enter the version tag (e.g., `v1.0.0`)
5. Click "Run workflow"

## Build Artifacts

Each platform build produces the following artifacts:

### Android
- `ClassTab-Catalog-vX.X.X-android.apk` - APK for sideloading
- `ClassTab-Catalog-vX.X.X-android.aab` - App Bundle for Google Play

### iOS
- `ClassTab-Catalog-vX.X.X-ios.tar.gz` - iOS app (requires code signing)

### Web
- `ClassTab-Catalog-vX.X.X-web.tar.gz` - Web application files

### Desktop
- `ClassTab-Catalog-vX.X.X-windows.zip` - Windows application
- `ClassTab-Catalog-vX.X.X-macos.tar.gz` - macOS application
- `ClassTab-Catalog-vX.X.X-linux.tar.gz` - Linux application

## Platform Setup

Before the workflows can build for all platforms, you may need to set up platform support locally:

### Using Setup Scripts

**Linux/macOS**:
```bash
./setup_platforms.sh
```

**Windows**:
```cmd
setup_platforms.bat
```

### Manual Setup

```bash
# Enable desktop platforms
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# Create platform directories
flutter create --platforms=ios,macos,windows .
```

## Workflow Requirements

### Secrets

No secrets are required for basic building. However, for signed releases you may want to add:

- `ANDROID_KEYSTORE` - Android signing keystore
- `ANDROID_KEY_ALIAS` - Android key alias
- `ANDROID_KEY_PASSWORD` - Android key password
- `APPLE_CERTIFICATE` - iOS/macOS signing certificate
- `APPLE_PROVISIONING_PROFILE` - iOS provisioning profile

### Repository Settings

1. Ensure "Actions" are enabled in repository settings
2. Set appropriate branch protection rules if needed
3. Configure release permissions

## Troubleshooting

### Common Issues

1. **Platform not found**: Run the setup scripts to create missing platform directories
2. **Build failures**: Check Flutter doctor output and ensure all dependencies are installed
3. **Permission errors**: Ensure the repository has proper permissions for creating releases

### Debug Builds

For debugging, you can modify the workflows to create debug builds by changing:
```yaml
flutter build <platform> --release
```
to:
```yaml
flutter build <platform> --debug
```

### Local Testing

Test builds locally before pushing:
```bash
# Test Android build
flutter build apk --release

# Test Web build
flutter build web --release

# Test desktop builds (platform-specific)
flutter build linux --release    # Linux only
flutter build windows --release  # Windows only
flutter build macos --release    # macOS only
```

## Customization

### Adding New Platforms

To add support for new platforms:

1. Add a new job in `build-release.yml`
2. Configure the appropriate runner (ubuntu-latest, windows-latest, macos-latest)
3. Add platform-specific build steps
4. Upload the artifact
5. Add release asset upload in the `create-release` job

### Modifying Build Configuration

- Edit `pubspec.yaml` for app metadata
- Modify platform-specific configuration files:
  - `android/app/build.gradle` for Android
  - `ios/Runner.xcodeproj` for iOS
  - `web/index.html` for Web
  - `linux/CMakeLists.txt` for Linux
  - `macos/Runner.xcodeproj` for macOS
  - `windows/CMakeLists.txt` for Windows

## Performance Optimization

### Build Time Optimization

- Use caching for Flutter SDK and dependencies
- Parallel builds where possible
- Conditional builds based on changed files

### Artifact Size Optimization

- Use `--split-per-abi` for Android builds
- Enable tree-shaking for web builds
- Compress artifacts before upload

## Security Considerations

- Never commit signing keys or certificates
- Use GitHub Secrets for sensitive data
- Regularly update workflow dependencies
- Review third-party actions before use