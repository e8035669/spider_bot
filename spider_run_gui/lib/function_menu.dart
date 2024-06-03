import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_run_gui/center_setting.dart';
import 'package:spider_run_gui/common_page.dart';
import 'package:spider_run_gui/raw_control.dart';
import 'package:spider_run_gui/src/rust/api/serial.dart';

class FunctionMenuBody extends StatefulWidget {
  final String deviceName;

  const FunctionMenuBody(this.deviceName, {super.key});

  @override
  State<FunctionMenuBody> createState() => _FunctionMenuBodyState();
}

class MenuItem {
  String title;
  void Function(BuildContext context)? func;

  MenuItem(this.title, this.func);
}

class _FunctionMenuBodyState extends State<FunctionMenuBody> {
  Future<String>? connectState;

  late List<MenuItem> menuItems = [
    MenuItem("Raw Control", openRawControl),
    MenuItem("Center Setting", openCenterSetting),
  ];

  @override
  void initState() {
    super.initState();

    var model = context.read<SerialConnectModel>();
    connectState = model.connect(widget.deviceName).then((value) => "OK");
  }

  Widget buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        value: null,
      ),
    );
  }

  void openRawControl(BuildContext context) {
    var model = context.read<SerialConnectModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Provider.value(
            value: model,
            child: CommonPage(
              Text(widget.deviceName),
              RawControlBody(widget.deviceName),
            ),
          );
        },
      ),
    );
  }

  void openCenterSetting(BuildContext context) {
    var model = context.read<SerialConnectModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Provider.value(
            value: model,
            child: CommonPage(
              Text(widget.deviceName),
              CenterSettingPage(widget.deviceName),
              actions: CenterSettingPage.getPageActions(),
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return ListView(
      children: menuItems
          .map(
            (m) => Card(
              child: ListTile(
                title: Text(m.title),
                onTap: m.func != null ? () => m.func!(context) : null,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildError(BuildContext context) {
    return Center(
      child: Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: connectState,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return buildError(context);
        }

        if (snapshot.hasData) {
          return buildContent(context);
        } else {
          return buildLoading(context);
        }
      },
    );
  }
}

class CenterTweak {
  bool invert = false;
  double center = 90.0;
  double multiply = 1.0;
}

class SerialConnectModel {
  SerialConnection conn = SerialConnection();

  List<bool> motorEnable = List.filled(18, false);
  List<double> motorValue = List.filled(18, 90.0);
  List<CenterTweak> tweaks = List.generate(18, (index) => CenterTweak());

  Future<Null> connect(String deviceName) async {
    await conn.connect(deviceName: deviceName, mock: false);
  }

  void disconnect() async {
    await conn.disconnect();
  }

  Future<bool> isConnected() async {
    return await conn.isConnected();
  }

  Future<void> write(int pin, int deg) async {
    await conn.write(pin: pin, deg: deg);
  }

  Future<void> updateSetting(int pin, double centerDeg, double multiply) async {
    await conn.update(pin: pin, centerDeg: centerDeg, multiply: multiply);
  }

  Future<void> getAllSetting() async {
    for (int i = 0; i < 18; ++i) {
      var setting = await conn.getSetting(pin: i);
      var tweak = tweaks[i];
      tweak.invert = setting.multiply.isNegative;
      tweak.center = setting.centerDeg;
      tweak.multiply = setting.multiply.abs();
    }
  }

  Future<void> getAllStatus() async {
    for (int i = 0; i < 18; ++i) {
      var cur = await conn.getStatus(pin: i);
      motorEnable[i] = cur.enabled;
      motorValue[i] = cur.deg.toDouble();
    }
  }

  Future<void> save() async {
    await conn.save();
  }

  Future<void> reset() async {
    await conn.reset();
  }
}
