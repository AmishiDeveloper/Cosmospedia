// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> initialize() async {
//     // 1. Permission request
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // 2. FCM Token
//     String? token = await _messaging.getToken();
//     debugPrint("FCM Token: $token");
//
//     // 3. Local Notifications Initialization
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings();
//
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     // 🎯 FIXED: Sirf 'settings' naam ke sath call karein
//     await _localNotifications.initialize(
//       settings: initSettings, // Agar aapka version naya hai toh aise hi chalega
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         debugPrint("Notification Clicked: ${details.payload}");
//       },
//     );
//
//     // 💡 NOTE: Agar upar wali line abhi bhi red hai, toh use niche wali line se replace karein:
//     // await _localNotifications.initialize(settings: initSettings, onSelectNotification: (payload) async {});
//
//     // 4. Android Channel Setup
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//     );
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     // 5. Listeners setup
//     _setupListeners(channel);
//   }
//
//   static void _setupListeners(AndroidNotificationChannel channel) {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       if (notification != null && android != null) {
//         _localNotifications.show(
//           id: notification.hashCode,
//           title: notification.title,
//           body: notification.body,
//           notificationDetails: NotificationDetails( // Check karo yahan 'notificationDetails' hi hona chahiye
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: android.smallIcon ?? "@mipmap/ic_launcher",
//               importance: Importance.max,
//               priority: Priority.high,
//               ticker: 'ticker',
//             ),
//           ),
//           payload: message.data.toString(),
//         );
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("Notification clicked from Background!");
//     });
//   }
//
//   static Future<void> handleInitialMessage() async {
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint("App opened from Terminated state!");
//     }
//   }
// }

import 'package:cosmospedia/src/data/model/space_news_models/space_news_common_model/notification_mock_data.dart';
import 'package:cosmospedia/src/data/repository/space_dev_repo/space_news_repo/space_news_repository.dart';
import 'package:cosmospedia/src/presentation/screens/space_news_screen/space_content_detail_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cosmospedia/main.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _messaging.getToken();
    debugPrint("FCM Token: $token");

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          // Payload String mein hota hai "{id: 123, ...}"
          // Iska logic thoda complex ho sakta hai parse karne mein
          // Lekin testing ke liye background/terminated check karna kaafi hai
          debugPrint("Foreground notification clicked: ${details.payload}");
          // Agar aap local notification click par bhi navigate karna chahte hain:
          // Yahan payload ko parse karke _handleMessage jaisa logic laga sakte hain.
        }
      }
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _setupListeners(channel);
  }

  static void _setupListeners(AndroidNotificationChannel channel) {
    // 1. Foreground Message (Jab app chal rahi ho)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon ?? "@mipmap/ic_launcher",
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // 🎯 Background Click Listener (Yahan se setupInteractedMessage ka kaam start hota hai)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message); // Purane debugPrint ki jagah handleMessage call kiya
    });
  }

  // Is function ko main() mein initialize() ke baad call karna h
  static Future<void> setupInteractedMessage() async {
    // Terminated state (App band ho) ke liye handling
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  //  Asli Navigation Logic
  static void _handleMessage(RemoteMessage message) {
    // 🎯 Hum notification se hi saara data nikaal rahe hain
    if (message.data.containsKey('id')) {

      // Ek temporary object banana jo SpaceContent interface ko follow kare
      final mockContent = NotificationMockData(
        id: message.data['id'] ?? "0",
        title: message.data['title'] ?? "Space Update",
        summary: message.data['summary'] ?? "Click to read more details about this space event.",
        imageUrl: message.data['image'] ?? "",
        type: message.data['type'] ?? "news",
        newsSite: message.data['source'] ?? "CosmosPedia",
        date: message.data['date'] ?? "Just Now",
      );

      // Seedha navigate kar jao
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => SpaceContentDetailScreen(content: mockContent),
        ),
      );
    }
  }
}