import 'package:cosmospedia/src/core/service_locator.dart';
import 'package:cosmospedia/src/logic/services/notification_service.dart';
import 'package:cosmospedia/src/presentation/my_application.dart';//Imports your root widget (MyApplication).This is where:MaterialApp, theme, routes, navigation
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';//Required for: runApp, Flutter widgets, app lifecycle
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';//needed for SystemChrome,device orientation, status bar / system UI control

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
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

  // 2. Firebase initialize karo
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ServiceLocator.setup();
  //  Service initialize karein
  await NotificationService.initialize();

  NotificationService.setupInteractedMessage();

  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const MyApplication());
}


