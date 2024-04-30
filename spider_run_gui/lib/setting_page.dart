import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_run_gui/main.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    MyAppThemeModel model = context.watch();
    var isDark = model.brightness == Brightness.dark;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Theme settings',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          title: const Text('Dark theme'),
          trailing: Switch(
            value: isDark,
            onChanged: (value) {
              MyAppThemeModel model = context.read();
              model.toggleBrightness();
            },
          ),
          onTap: () {
            MyAppThemeModel model = context.read();
            model.toggleBrightness();
          },
        ),
      ],
    );
  }
}
