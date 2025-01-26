# sewahealth_web

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

    flutter build web --web-renderer html
    firebase deploy

Run the emulator locally for the development
    firebase emulators:start --only firestore,auth --import tmp --export-on-exit

Troubleshooting
    # if the ports are taken and you need to free up the ports kill the processes using the ports
    # with the following command
    lsof -t -i :9099,8080,5000,4000,4400,4500 | xargs kill