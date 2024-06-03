import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_run_gui/function_menu.dart';

class CenterSettingPage extends StatefulWidget {
  final String deviceName;
  const CenterSettingPage(this.deviceName, {super.key});

  @override
  State<CenterSettingPage> createState() => _CenterSettingPageState();

  static List<Widget> getPageActions() {
    return [const CenterSettingSaveBtn()];
  }
}

class _CenterSettingPageState extends State<CenterSettingPage> {
  Future<String>? loadFuture;

  @override
  void initState() {
    super.initState();

    loadFuture = loadStatus();
  }

  Future<String> loadStatus() async {
    var serial = context.read<SerialConnectModel>();
    await serial.getAllStatus();
    await serial.getAllSetting();
    return "OK";
  }

  Widget buildCircle(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildError(BuildContext context) {
    return const Center(
      child: Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("There are error ${snapshot.error}");
          return buildError(context);
        }

        if (snapshot.hasData) {
          return CenterSettingContent(widget.deviceName);
        } else {
          return buildCircle(context);
        }
      },
    );
  }
}

class CenterSettingContent extends StatefulWidget {
  final String deviceName;

  const CenterSettingContent(this.deviceName, {super.key});

  @override
  State<CenterSettingContent> createState() => _CenterSettingContentState();
}

class _CenterSettingContentState extends State<CenterSettingContent> {
  void writeToMotor(
      BuildContext context, SerialConnectModel serial, int n) async {
    if (serial.motorEnable[n]) {
      var tweak = serial.tweaks[n];
      var multiply = tweak.multiply;
      if (tweak.invert) {
        multiply = -multiply;
      }
      debugPrint("updateSetting $n ${tweak.center} $multiply");
      await serial.updateSetting(n, tweak.center, multiply);
      var deg = serial.motorValue[n];
      debugPrint("write $n ${deg.toInt()}");
      await serial.write(n, deg.toInt());
    } else {
      debugPrint("write $n -1");
      await serial.write(n, -1);
    }
  }

  Widget buildTweak(BuildContext context, SerialConnectModel serial, int n) {
    var tweaks = serial.tweaks;
    var motorValue = serial.motorValue;

    var multiplyValue = tweaks[n].multiply;
    if (tweaks[n].invert) {
      multiplyValue = -multiplyValue;
    }

    var ret = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            const Text("Center"),
            Slider(
              label: tweaks[n].center.toStringAsFixed(0),
              value: tweaks[n].center,
              min: 0.0,
              max: 180.0,
              divisions: 180,
              onChanged: (v) {
                setState(() {
                  tweaks[n].center = v;
                });
                writeToMotor(context, serial, n);
              },
            ),
            const Text(""),
          ],
        ),
        TableRow(
          children: [
            const Text("Multiply"),
            Slider(
              label: multiplyValue.toStringAsFixed(2),
              value: tweaks[n].multiply,
              min: 0.5,
              max: 2.0,
              divisions: 150,
              onChanged: (v) {
                setState(() {
                  tweaks[n].multiply = v;
                });
                writeToMotor(context, serial, n);
              },
            ),
            Row(
              children: [
                const Text("Invert"),
                Checkbox(
                  value: tweaks[n].invert,
                  onChanged: (value) {
                    setState(() {
                      tweaks[n].invert = value ?? false;
                    });
                    writeToMotor(context, serial, n);
                  },
                ),
              ],
            )
          ],
        ),
        TableRow(
          children: [
            const Text("Pos"),
            Slider(
              label: motorValue[n].toStringAsFixed(0),
              value: motorValue[n],
              min: 0.0,
              max: 180.0,
              divisions: 180,
              onChanged: (value) {
                setState(() {
                  motorValue[n] = value;
                });
                writeToMotor(context, serial, n);
              },
            ),
            const Text(""),
          ],
        ),
      ],
    );
    return ret;
  }

  List<Widget> buildControl1(
      BuildContext context, SerialConnectModel serial, int n) {
    var motorEnable = serial.motorEnable;

    List<Widget> ret = [
      ListTile(
        key: Key("servo.enable.$n"),
        title: Text("Servo $n"),
        trailing: Switch(
          value: motorEnable[n],
          onChanged: (value) {
            setState(() {
              motorEnable[n] = value;
            });
            writeToMotor(context, serial, n);
          },
        ),
      ),
    ];
    if (motorEnable[n]) {
      ret.add(ListTile(
        key: Key("servo.tweak.$n"),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: buildTweak(context, serial, n),
        ),
      ));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var serial = context.read<SerialConnectModel>();

    var ret = ListView(
      children: Iterable.generate(18)
          .map((e) => buildControl1(context, serial, e))
          .expand((element) => element)
          .toList(),
    );

    return ret;
  }
}

class CenterSettingSaveBtn extends StatelessWidget {
  const CenterSettingSaveBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        var serial = context.read<SerialConnectModel>();
        serial.save();
      },
      icon: const Icon(Icons.save),
    );
  }
}
