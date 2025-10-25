# Google Sign-In Setup Guide

## Current Status
✅ App is running on Android emulator
✅ Firebase Auth is working (email/password)
❌ Google Sign-In needs configuration

## Steps to Enable Google Sign-In

### 1. Get SHA-1 Fingerprint
Run this command in your terminal:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Look for the SHA1 fingerprint (something like: `AA:BB:CC:DD:EE:FF:...`)

### 2. Add SHA-1 to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your "Flutter Social Practical" project
3. Go to **Project Settings** (gear icon)
4. Scroll down to **Your apps** section
5. Click on your Android app
6. Click **Add fingerprint**
7. Paste your SHA-1 fingerprint
8. Click **Save**

### 3. Download Updated google-services.json

1. In the same Android app settings
2. Click **Download google-services.json**
3. Replace the file in `android/app/google-services.json`

### 4. Enable Google Sign-In in Firebase

1. Go to **Authentication** → **Sign-in method**
2. Click on **Google**
3. Click **Enable**
4. Add your email as the project support email
5. Click **Save**

### 5. Test Google Sign-In

After completing the above steps:
1. Hot restart the app: `R` in the Flutter terminal
2. Try the "Continue with Google" button
3. It should open Google sign-in flow

## Troubleshooting

### If Google Sign-In still doesn't work:

1. **Check the SHA-1**: Make sure you added the correct debug SHA-1
2. **Clean and rebuild**: 
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. **Check Firebase project**: Ensure you're using the correct Firebase project
4. **Check internet**: Make sure the emulator has internet access

### Alternative: Test with Email/Password First

The email/password authentication is already working! You can:
1. Try signing up with a different email
2. Or sign in with existing credentials
3. Test the post creation and real-time updates

## Current Working Features

✅ **Email/Password Authentication**
✅ **User Registration** 
✅ **Firebase Connection**
✅ **Real-time Database** (Firestore)
✅ **Post Creation** (once authenticated)
✅ **BLoC State Management**

## Next Steps

1. Set up Google Sign-In (follow steps above)
2. Test post creation and real-time updates
3. Add Firestore security rules
4. Test on physical device