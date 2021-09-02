import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/schedulling_provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';
  static const routeName = '/settings_page';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(settingsTitle),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: Text("Schedulling News"),
            trailing: Consumer<SchedullingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                    value: scheduled.isScheduled!,
                    onChanged: (value) async {
                      scheduled.scheduledNews(value);
                    });
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAndroid(context);
  }
}
