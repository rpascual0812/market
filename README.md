# market

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development

./android/local.properties
 - flutter.minSdkVersion=21
 - flutter.compileSdkVersion=33

./android/app/build.gradle
 - compileSdkVersion localProperties.getProperty('flutter.compileSdkVersion').toInteger()
 - minSdkVersion localProperties.getProperty('flutter.minSdkVersion').toInteger()