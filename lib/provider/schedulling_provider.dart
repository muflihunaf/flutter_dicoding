import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_app/common/background_service.dart';
import 'package:restaurant_app/common/datetime_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedullingProvider extends ChangeNotifier {
  bool? _isScheduled = false;
  bool? get isScheduled => _isScheduled;
  SharedPreferences? _preferences;
  SchedullingProvider() {
    getDefaultValue();
  }

  Future<bool?> getDefaultValue() async {
    _preferences = await SharedPreferences.getInstance();
    print(_preferences!.getBool('value'));
    notifyListeners();
    return _isScheduled = _preferences!.getBool('value') ?? _isScheduled;
  }

  Future<bool> scheduledNews(bool value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences!.setBool('value', _isScheduled!);
    _isScheduled = value;
    if (_isScheduled!) {
      print("Restaurant Notif Activated");
      notifyListeners();
      return await AndroidAlarmManager.periodic(
          Duration(hours: 24), 1, BackgroundService.callback,
          startAt: DateTimeHelper.format(), exact: true, wakeup: true);
    } else {
      print("Schedulling News Canceled");
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
