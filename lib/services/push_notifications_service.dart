//SHA1 = F0:8F:17:73:33:25:E2:EB:E1:BA:45:45:78:F0:EE:84:41:E0:3E:98

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    log('onBackground Handler ${message.messageId}');
    log('${message.data}');
    _messageStream.add(message.data['producto'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    log('onMessage Handler ${message.messageId}');
    log('${message.data}');
    _messageStream.add(message.data['producto'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    log('onMessageOpenApp Handler ${message.messageId}');
    log('${message.data}');
    _messageStream.add(message.data['producto'] ?? 'No data');
  }

  static Future initializeApp() async {
    // push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    log("token: $token");

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    // local notifications
  }

  static closeStreams() {
    _messageStream.close();
  }
}
