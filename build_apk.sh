#!/bin/bash

# Social Posts App - Build Script
# This script builds the APK for the social posts application

echo "🚀 Building Social Posts App APK..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Run tests
echo "🧪 Running tests..."
flutter test

if [ $? -eq 0 ]; then
    echo "✅ Tests passed!"
else
    echo "❌ Tests failed! Please fix the issues before building."
    exit 1
fi

# Build APK
echo "🔨 Building APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo "✅ APK built successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    
    # Get APK size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "📊 APK size: $APK_SIZE"
    
    echo ""
    echo "🎉 Build completed successfully!"
    echo "You can now install the APK on your Android device."
else
    echo "❌ APK build failed!"
    exit 1
fi