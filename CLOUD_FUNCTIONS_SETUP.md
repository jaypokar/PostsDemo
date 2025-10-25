# 🔥 Cloud Functions Setup Guide

## ✅ What's Already Done

Your Cloud Functions are already set up in the `functions/` folder with:

- ✅ **onPostCreated**: Triggers console log when new post is added
- ✅ **onPostUpdated**: Logs when posts are updated  
- ✅ **onPostDeleted**: Logs when posts are deleted
- ✅ **onUserCreated**: Logs when new users register
- ✅ **Statistics tracking**: Updates post/user counts

## 🚀 Deploy Cloud Functions

### 1. Install Firebase CLI (if not already installed)
```bash
npm install -g firebase-tools
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Initialize Functions (already done, but for reference)
```bash
firebase init functions
```

### 4. Deploy Functions
```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

## 📊 What the Functions Do

### **onPostCreated Function**
Triggers when a new post is added to Firestore:
```
🎉 NEW POST NOTIFICATION 🎉
📝 Post ID: abc123
👤 Author: TestUser
💬 Content: Hello World!
⏰ Created: 2024-01-01T12:00:00Z
================================
```

### **onUserCreated Function**  
Triggers when a new user registers:
```
👋 NEW USER REGISTERED 👋
🆔 User ID: user123
📧 Email: test@example.com
👤 Username: TestUser
⏰ Registered: 2024-01-01T12:00:00Z
================================
```

## 🔍 View Function Logs

### Option 1: Firebase Console
1. Go to: https://console.firebase.google.com/project/flutter-social-practical
2. Click **Functions** in left menu
3. Click on any function to see logs

### Option 2: Command Line
```bash
firebase functions:log
```

### Option 3: Real-time Logs
```bash
firebase functions:log --follow
```

## 🧪 Test the Functions

### 1. Create a Post in App
- Open the Flutter app
- Create a new post
- Check Firebase Console → Functions → Logs
- You should see the notification log

### 2. Register New User
- Sign up with a new account
- Check the logs for user registration notification

## 📁 Function Files Structure

```
functions/
├── package.json          # Dependencies
├── index.js             # Main functions code
└── node_modules/        # Installed packages
```

## 🔧 Customize Functions

Edit `functions/index.js` to:
- Add email notifications
- Send push notifications  
- Integrate with third-party services
- Add more complex business logic

## 🚀 Deploy Commands

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:onPostCreated

# Deploy with debug info
firebase deploy --only functions --debug
```

