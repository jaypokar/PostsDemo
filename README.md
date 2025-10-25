# Social Posts App

A Flutter social media application with real-time posting, Firebase authentication, and BLoC state management.

## Features

✅ **User Authentication**
- Firebase Authentication with Email/Password
- Google Sign-In integration
- User profile management with Firestore

✅ **Post Management**
- Create, read, update, delete posts
- Real-time updates using Firestore streams
- Character limit validation (500 characters)

✅ **Modern UI/UX**
- Material Design 3
- Responsive design
- Pull-to-refresh functionality
- Loading states and error handling

✅ **Architecture**
- BLoC pattern for state management
- Repository pattern for data layer
- Clean architecture principles

✅ **Firebase Integration**
- Firestore for data storage
- Firebase Auth for authentication
- Cloud Functions for server-side logic (optional)

## Screenshots

[Add screenshots of your app here]

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Firebase project
- Android Studio / VS Code
- Git

### Firebase Setup

1. **Create a Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Authentication and Firestore

2. **Configure Authentication**
   - Enable Email/Password authentication
   - Enable Google Sign-In
   - Add your app's SHA-1 fingerprint for Google Sign-In

3. **Setup Firestore**
   - Create a Firestore database
   - Set up security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Posts are readable by all authenticated users
    // Posts can only be created/updated/deleted by their owner
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                   request.auth.uid == resource.data.userId;
      allow update, delete: if request.auth != null && 
                           request.auth.uid == resource.data.userId;
    }
  }
}
```

4. **Add Firebase Configuration**
   - Install Firebase CLI: `npm install -g firebase-tools`
   - Run: `firebase login`
   - Run: `flutterfire configure`
   - This will generate `firebase_options.dart` with your project configuration

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd post_task
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration
   - Or run `flutterfire configure` to auto-generate the file

4. **Run the app**
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   └── post_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       └── posts_repository.dart
├── presentation/
│   ├── blocs/
│   │   ├── auth/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   └── posts/
│   │       ├── posts_bloc.dart
│   │       ├── posts_event.dart
│   │       └── posts_state.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   └── home/
│   │       └── home_screen.dart
│   └── widgets/
│       ├── post_card.dart
│       └── create_post_dialog.dart
├── firebase_options.dart
└── main.dart
```

## Key Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6          # State management
  firebase_core: ^3.6.0         # Firebase core
  firebase_auth: ^5.3.1         # Authentication
  cloud_firestore: ^5.4.3       # Database
  google_sign_in: ^6.2.1        # Google authentication
  equatable: ^2.0.5             # Value equality
  timeago: ^3.7.0               # Time formatting
  intl: ^0.19.0                 # Internationalization
```

## Firebase Security Rules

The app uses the following Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.auth.uid == resource.data.userId;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

## Cloud Functions (Optional)

The project includes Cloud Functions for server-side logic:

1. **Setup Functions**
```bash
cd functions
npm install
```

2. **Deploy Functions**
```bash
firebase deploy --only functions
```

## Testing

Run tests with:
```bash
flutter test
```

## Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you encounter any issues or have questions, please create an issue in the repository.

---

**Note**: This is a demo application built for interview purposes. Make sure to configure your own Firebase project and update the configuration files accordingly.


