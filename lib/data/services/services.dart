import '../../core.dart';

class Services{
  static initialiseServices() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();

    // LocalNotificationService localNotificationService = LocalNotificationService();
    // localNotificationService.init();
    // final notificationService = NotificationService();
    // await notificationService.init();

  }
}