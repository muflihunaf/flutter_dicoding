import 'dart:convert';

import 'package:restaurant_app/data/model/restoran.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationAndroid = AndroidInitializationSettings('app_icon');
    var initializationIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    var initializationSettings = InitializationSettings(
        android: initializationAndroid, iOS: initializationIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print("notification_payload" + payload);
      }
      selectNotificationSubject.add(payload ?? "empty payload");
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var data = (restaurant.restaurants!.toList()..shuffle()).first;
    var _channelId = "01";
    var _channelName = "channel 01";
    var _channelDescription = "dicoding news channel";
    var androidPlatformSpesifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true));

    var _iOSPlatformSpesifics = IOSNotificationDetails();
    var platformChannelSpesifics = NotificationDetails(
        android: androidPlatformSpesifics, iOS: _iOSPlatformSpesifics);
    var titleNotification = "<b>Restaurant </b>";
    var titleNews = data.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleNews, platformChannelSpesifics,
        payload: json.encode(restaurant.toJson()));
  }
}
