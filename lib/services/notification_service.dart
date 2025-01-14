// ignore_for_file: avoid_dynamic_calls

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:times_up_flutter/common_widgets/show_logger.dart';
import 'package:times_up_flutter/models/notification_model/notification_model.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.max,
);

class NotificationService {
  // Here the set up for cloud Messaging Android is being configured
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // The LocalPlugin method configures the android channel
  Future<void> localPlugin() async => await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

// Create a new instance of Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Set the list on Notification messages
  NotificationModel _setNotifications(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final title = notification['title'] as String;
    final body = notification['body'] as String;
    final mMessage = data['Message'] as String;
    final not = NotificationModel(
      id: null,
      title: title,
      body: body,
      message: mMessage,
    );

    return not;
  }

  /// this function calls the Firebase Push notification

  void configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ),
          );
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      JHLogger.$.d('A new onMessageOpenedApp event was published!');
      _setNotifications(
        {'message': message.messageId, 'notification': message.notification},
      );
      JHLogger.$.d('Message : $message');
    });
  }
}
