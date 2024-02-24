import '../../core.dart';
import 'dart:developer';

Future<void> _firebaseHandleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.messageId}');
  log('Title : ${message.notification!.title}');
  log('Body : ${message.notification!.body}');
  log('Payload : ${message.data}');
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    NotificationSettings settings =
        await _firebaseMessaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  Future<void> init() async {
    await requestPermission();

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _firebaseMessaging.getToken();
    log("FCM Token: $token");

    FirebaseMessaging.onBackgroundMessage(_firebaseHandleBackgroundMessage);
    await FirebaseMessaging.instance.getInitialMessage().then(handleNotificationClick);

    // Handle the notification when the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("onMessage: $message");
      LocalNotificationService.showNotification(message);
    });

    // Handle the notification when the app is in the background and the user taps it.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("onMessageOpenedApp: $message");
      handleNotificationClick(message);
    });
  }

  void handleNotificationClick(RemoteMessage? message) {
    log("Notification clicked $message");
    if(message?.notification == null) return;
    if(navigatorKey.currentContext == null) return;
    Navigator.of(navigatorKey.currentContext!).pushNamed(RoutesName.todoView);
  }
}
