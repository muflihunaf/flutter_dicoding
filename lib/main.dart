import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/background_service.dart';
import 'package:restaurant_app/common/notification_helper.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/favorite_page.dart';
import 'package:restaurant_app/home_page.dart';
import 'package:restaurant_app/provider/restoran_provider.dart';
import 'package:restaurant_app/provider/schedulling_provider.dart';
import 'package:restaurant_app/restaurant_detail_page.dart';
import 'package:restaurant_app/restaurant_page.dart';
import 'package:restaurant_app/serach_page.dart';
import 'package:restaurant_app/settings_page.dart';
import 'package:restaurant_app/splash_screen_page.dart';
import 'package:restaurant_app/styles.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _backgroundService = BackgroundService();
  _backgroundService.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotification(flutterLocalNotificationsPlugin);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestoranProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => SchedullingProvider())
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          textTheme: myTextTheme,
          primarySwatch: Colors.yellow,
        ),
        initialRoute: SplashScreenPage.routeName,
        routes: {
          SplashScreenPage.routeName: (context) => SplashScreenPage(),
          HomePage.routeName: (context) => HomePage(),
          RestaurantListPage.routeName: (context) => RestaurantListPage(),
          DetailRestaurantPage.routeName: (context) => DetailRestaurantPage(),
          SearchPage.routeName: (context) => SearchPage(),
          FavoritePage.routeName: (context) => FavoritePage(),
          SettingsPage.routeName: (context) => SettingsPage()
        },
      ),
    );
  }
}
