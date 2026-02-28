import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/presentation/my_application.dart';//Imports your root widget (MyApplication).This is where:MaterialApp, theme, routes, navigation
import 'package:flutter/material.dart';//Required for: runApp, Flutter widgets, app lifecycle
import 'package:flutter/services.dart';//needed for SystemChrome,device orientation, status bar / system UI control

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /*“this line means that it is telling Flutter,to initialize all engine bindings before anything else.
  WidgetsFlutterBinding.ensureInitialized() ensures that Flutter’s engine and platform services are fully initialized
   before accessing system-level APIs or running the app.
  Flutter:
  Sets up the engine
  Creates message channels
  Prepares rendering
  Enables platform communication

  When should you use it? (very important)
  If your main() does more than just runApp() → use ensureInitialized()
  Use it ONLY IF you do something before runApp() like:
* SystemChrome.setPreferredOrientations()
* Firebase initialization
* SharedPreferences
* Screen size / device info
* Platform channels
  Here It is needed because SystemChrome talks to native Android/iOS code.
  So Flutter must be initialized first.
  Simple rule to remember:
  If you use platform channels, Firebase, orientation, shared preferences .”*/
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  ServiceLocator.setup();
  runApp(const MyApplication());
}


