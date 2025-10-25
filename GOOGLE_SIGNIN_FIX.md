# 🔧 Google Sign-In Fix - URGENT

## Error: `ApiException: 10`
This means Google Sign-In is not properly configured.

## IMMEDIATE FIX STEPS:

### 1. Get SHA-1 Fingerprint
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### 2. Add SHA-1 to Firebase Console
1. Go to: https://console.firebase.google.com/project/flutter-social-practical
2. Click **Project Settings** (gear icon)
3. Scroll to **Your apps** section
4. Click on **Android app** (com.post.task.post_task)
5. Click **Add fingerprint**
6. Paste your SHA-1 fingerprint
7. Click **Save**

### 3. Enable Google Sign-In
1. Go to **Authentication** → **Sign-in method**
2. Click **Google**
3. Click **Enable**
4. Add your email as support email
5. Click **Save**

### 4. Download Updated Config
1. In Project Settings → Your Android App
2. Click **Download google-services.json**
3. Replace the file in `android/app/google-services.json`

### 5. Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter run --debug
```

## Alternative: Use Email Sign-Up for Now

If Google Sign-In setup takes time, use email sign-up:
1. Click "Don't have an account? Sign up"
2. Enter any email: `test@example.com`
3. Enter password: `test123456`
4. Enter username: `TestUser`
5. Click Sign Up

This should work immediately while you set up Google Sign-In.