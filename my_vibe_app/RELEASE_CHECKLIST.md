# Byzantine Keyboard - Release Readiness Checklist

## ✅ CRITICAL - Must Complete Before Release

### 1. App Identity & Branding
- [ ] **Change Application ID** (Currently: `com.example.my_vibe_app`)
  - File: `android/app/build.gradle.kts` (line 24)
  - Recommended: `com.yourcompany.byzantinekeyboard` or similar
  - Must be unique on Google Play Store
  
- [ ] **Update App Name**
  - File: `android/app/src/main/AndroidManifest.xml` (line 3)
  - Change from `my_vibe_app` to `Byzantine Keyboard`
  
- [ ] **Create App Icon**
  - Replace default launcher icon in `android/app/src/main/res/mipmap-*/ic_launcher.png`
  - Recommended tool: https://icon.kitchen/ or Android Studio Image Asset Studio
  - Sizes needed: mdpi (48x48), hdpi (72x72), xhdpi (96x96), xxhdpi (144x144), xxxhdpi (192x192)

### 2. App Signing (CRITICAL for Play Store)
- [ ] **Generate Release Keystore**
  ```bash
  keytool -genkey -v -keystore byzantine-keyboard-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias byzantine-keyboard
  ```
  - Store keystore file securely (NOT in git)
  - Remember password and alias
  
- [ ] **Configure Signing in Gradle**
  - Create `android/key.properties`:
    ```properties
    storePassword=YOUR_KEYSTORE_PASSWORD
    keyPassword=YOUR_KEY_PASSWORD
    keyAlias=byzantine-keyboard
    storeFile=../byzantine-keyboard-release.jks
    ```
  - Update `android/app/build.gradle.kts` to use signing config (see template below)

### 3. Permissions & Manifest
- [ ] **Add Required Permissions** to `AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.WAKE_LOCK" />
  ```
  
- [ ] **Set Screen Orientation** (if needed):
  ```xml
  android:screenOrientation="landscape"
  ```
  in the activity tag

### 4. Version Management
- [ ] **Update Version** in `pubspec.yaml` (currently 1.0.0+1)
  - Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`
  - Example: `1.0.0+1` for first release

### 5. Legal & Documentation
- [ ] **Create Privacy Policy**
  - Required by Google Play if app uses internet or collects data
  - Host on a public URL
  
- [ ] **Add to Play Store Listing**:
  - App description (short: 80 chars, full: 4000 chars)
  - Screenshots (minimum 2, recommended 4-8)
  - Feature graphic (1024x500)
  - Category: Music & Audio
  - Content rating questionnaire
  
- [ ] **Update README.md** with:
  - App description
  - Features list
  - Installation instructions
  - Credits/attribution

## ⚠️ RECOMMENDED - Should Complete

### 6. Code Quality & Performance
- [ ] **Remove Debug Code**
  - Remove `debugShowCheckedModeBanner: false` or keep it
  - Remove any console logs in production
  
- [ ] **Optimize Build**
  - Enable code shrinking and obfuscation
  - Add ProGuard rules if needed
  
- [ ] **Test on Multiple Devices**
  - Different screen sizes
  - Different Android versions (minimum API 21)
  - Test audio quality on different devices

### 7. App Store Optimization
- [ ] **Prepare Store Assets**:
  - App icon (512x512 PNG)
  - Feature graphic (1024x500)
  - Screenshots (phone: 16:9 ratio, tablet optional)
  - Promo video (optional but recommended)
  
- [ ] **Write Compelling Description**:
  - Highlight Byzantine music features
  - Mention 8 modes/echoi
  - Emphasize microtonal tuning capabilities
  - List key features (Piano/Organ modes, tuning controls, etc.)

### 8. Testing
- [ ] **Test All Features**:
  - Piano mode
  - Organ mode with all genera
  - All 8 Byzantine echoi
  - Microtonal sliders
  - Keyboard scrolling
  - Multi-touch support
  
- [ ] **Performance Testing**:
  - No audio glitches with multiple keys
  - Smooth UI transitions
  - No memory leaks during extended use

### 9. Compliance
- [ ] **Content Rating**
  - Complete Google Play content rating questionnaire
  - Likely rating: Everyone
  
- [ ] **Target API Level**
  - Ensure targetSdk is set to latest (API 34 for 2024)
  - Test on Android 14

## 📋 OPTIONAL - Nice to Have

### 10. Additional Features
- [ ] **Add Tutorial/Help Screen**
  - Explain Byzantine music theory basics
  - Show how to use tuning controls
  
- [ ] **Add Settings**
  - Audio quality settings
  - Default mode selection
  - Visual theme options
  
- [ ] **Analytics** (optional)
  - Firebase Analytics
  - Crash reporting (Firebase Crashlytics)

### 11. Marketing
- [ ] **Create Promotional Materials**
  - Demo video showing app features
  - Social media posts
  - Website or landing page
  
- [ ] **Prepare Launch Strategy**
  - Beta testing group
  - Launch date
  - Marketing channels

## 🔧 Build Commands

### Debug Build (Testing)
```bash
flutter build apk --debug
```

### Release Build (Play Store)
```bash
flutter build appbundle --release
```

### Install Release APK (Testing)
```bash
flutter build apk --release
flutter install --release
```

## 📝 Files to Update

### Priority 1 (Must Update)
1. `android/app/build.gradle.kts` - Application ID, signing config
2. `android/app/src/main/AndroidManifest.xml` - App name, permissions
3. `pubspec.yaml` - Version number, app description
4. Create keystore file
5. Create app icons

### Priority 2 (Should Update)
6. `README.md` - Documentation
7. Create privacy policy
8. Prepare Play Store assets

### Priority 3 (Nice to Have)
9. Add ProGuard rules
10. Add analytics configuration

## 🚀 Release Process

1. Complete all CRITICAL items
2. Test thoroughly on real devices
3. Generate signed release bundle: `flutter build appbundle --release`
4. Create Google Play Console account ($25 one-time fee)
5. Upload app bundle to Play Console
6. Complete store listing
7. Submit for review
8. Wait for approval (typically 1-3 days)

## 📞 Support

For Flutter/Android specific issues:
- Flutter docs: https://docs.flutter.dev/deployment/android
- Play Console help: https://support.google.com/googleplay/android-developer

---

**Current Status**: Development build - NOT ready for release
**Next Steps**: Complete items in "CRITICAL" section
