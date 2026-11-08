# 🚀 DEPLOYMENT.md — CI/CD, Build & Release Pipeline

> **Platforms:** Android (APK / App Bundle) & iOS (IPA) • Firebase App Hosting

---

## 1. Build Flavors & Environments

The app supports three build environments configured via compile-time variables:

| Environment | Flavor | Purpose | Backend URL / Firebase Project |
|---|---|---|---|
| **Development** | `dev` | Local development & unit testing (Mock Simulator active) | `obd-project-dev` |
| **Staging** | `staging` | Hardware benchtop & QA testing | `obd-project-staging` |
| **Production** | `prod` | Official release for real vehicles and workshops | `obd-project-prod` |

---

## 2. Android Build & Release Commands

```bash
# Build Development APK with Simulated OBD mode
flutter build apk --debug

# Build Production Release Android App Bundle (AAB) for Google Play
flutter build appbundle --release --obfuscate --split-debug-info=./build/app/outputs/symbols
```

### Required Android Permissions (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

---

## 3. iOS Configuration (`Info.plist`)
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app requires Bluetooth access to connect to your vehicle's OBD-II diagnostic scanner.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app connects to OBD-II hardware adapters to stream vehicle telemetry.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is used to locate nearby automotive service centers and workshops.</string>
```
