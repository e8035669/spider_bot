import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_run_gui/src/rust/frb_generated.dart';
import 'package:spider_run_gui/home_page.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppThemeModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyAppThemeModel model = context.watch();

    return MaterialApp(
      title: "Spider GUI",
      home: const HomePage2(),
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
        // primaryColor: Colors.purple,
        brightness: model.brightness,
      ),
    );
  }
}

class MyAppThemeModel extends ChangeNotifier {
  var brightness = Brightness.light;

  void toggleBrightness() {
    if (brightness == Brightness.light) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }
    notifyListeners();
  }
}
