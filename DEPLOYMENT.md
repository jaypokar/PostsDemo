# Deployment Guide

## Pre-deployment Checklist

- [ ] Firebase project configured
- [ ] Authentication methods enabled
- [ ] Firestore security rules applied
- [ ] App tested on both Android and iOS
- [ ] All dependencies updated
- [ ] Tests passing

## Android Deployment

### 1. Generate Signing Key

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Configure Signing

Create `android/key.properties`:
```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file>
```

### 3. Configure Build

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 4. Build Release APK

```bash
flutter build apk --release
```

### 5. Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

## iOS Deployment

### 1. Configure Xcode Project

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner project
3. Update Bundle Identifier
4. Configure signing with your Apple Developer account

### 2. Build for Release

```bash
flutter build ios --release
```

### 3. Archive and Upload

1. In Xcode, select "Generic iOS Device"
2. Product → Archive
3. Upload to App Store Connect

## Firebase Hosting (Web)

### 1. Build Web App

```bash
flutter build web --release
```

### 2. Deploy to Firebase Hosting

```bash
firebase init hosting
firebase deploy --only hosting
```

## Environment Configuration

### Production Environment Variables

Create different Firebase projects for development and production:

1. **Development**: `your-app-dev`
2. **Production**: `your-app-prod`

### Build Flavors (Advanced)

Configure different flavors for dev/staging/prod environments.

## Performance Optimization

### 1. Enable Code Shrinking (Android)

In `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        shrinkResources true
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

### 2. Optimize Images

- Use WebP format for images
- Compress images before including in assets
- Use vector graphics where possible

### 3. Bundle Size Analysis

```bash
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

## Monitoring and Analytics

### 1. Firebase Crashlytics

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_crashlytics: ^3.4.8
```

### 2. Firebase Analytics

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_analytics: ^10.7.4
```

### 3. Performance Monitoring

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_performance: ^0.9.3+8
```

## Security Considerations

### 1. Firestore Security Rules

Ensure production rules are restrictive:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                   request.auth.uid == resource.data.userId &&
                   validatePostData(request.resource.data);
      allow update, delete: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
    }
  }
}

function validatePostData(data) {
  return data.keys().hasAll(['content', 'userId', 'username', 'createdAt', 'updatedAt']) &&
         data.content is string &&
         data.content.size() <= 500 &&
         data.userId is string &&
         data.username is string;
}
```

### 2. API Keys

- Never commit API keys to version control
- Use environment variables for sensitive data
- Restrict API key usage in Firebase Console

## CI/CD Pipeline

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Firebase

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test
    
    - name: Build web
      run: flutter build web --release
    
    - name: Deploy to Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        projectId: your-project-id
```

## Post-Deployment

### 1. Monitor Performance

- Check Firebase Performance dashboard
- Monitor Crashlytics for errors
- Review user analytics

### 2. User Feedback

- Implement in-app feedback
- Monitor app store reviews
- Set up user support channels

### 3. Updates

- Plan regular updates
- Use Firebase Remote Config for feature flags
- Implement A/B testing for new features

## Troubleshooting

### Common Deployment Issues

1. **Build failures**: Check Flutter and dependency versions
2. **Signing issues**: Verify keystore and certificates
3. **Firebase connection**: Check configuration files
4. **Performance issues**: Profile and optimize critical paths

### Support Resources

- [Flutter Deployment Documentation](https://docs.flutter.dev/deployment)
- [Firebase Documentation](https://firebase.google.com/docs)
- [App Store Guidelines](https://developer.apple.com/app-store/guidelines/)
- [Google Play Guidelines](https://developer.android.com/distribute/google-play/policies)