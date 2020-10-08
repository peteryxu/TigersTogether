import 'package:flutter/material.dart';
import 'main_app.dart';
import 'splash_app.dart';

// Flutter Splash Screen — A simple way to handle async dependencies
// https://levelup.gitconnected.com/flutter-splash-screen-a-simple-way-to-handle-async-dependencies-7a9f559eb280

void main() {
  runApp(
    SplashApp(
      key: UniqueKey(),
      onInitializationComplete: () => runMainApp(),
    ),
  );
}

void runMainApp() {
  runApp(
    MainApp(),
  );
}
