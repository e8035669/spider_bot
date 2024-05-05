import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_run_gui/function_menu.dart';

class RawControlBody extends StatefulWidget {
  final String deviceName;

  const RawControlBody(this.deviceName, {super.key});

  @override
  State<RawControlBody> createState() => _RawControlBodyState();
}

class _RawControlBodyState extends State<RawControlBody> {
  List<bool> motorEnable = List.filled(32, false);
  List<double> motorValue = List.filled(32, 90.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void writeCmd(int pin) async {
    var serial = context.read<SerialConnectModel>();

    if (motorEnable[pin]) {
      var deg = motorValue[pin];
      debugPrint("sendWriteCmd $pin ${deg.toInt()}");
      await serial.sendWriteCmd(pin, deg.toInt());
    } else {
      debugPrint("sendWriteCmd $pin -1");
      await serial.sendWriteCmd(pin, -1);
    }
  }

  List<Widget> buildController(BuildContext context) {
    List<Widget> ret = [];
    for (int i = 0; i < motorEnable.length; ++i) {
      void Function(double)? func;
      if (motorEnable[i]) {
        func = (value) {
          setState(() {
            motorValue[i] = value;
          });
          writeCmd(i);
        };
      }

      ret.add(ListTile(
        key: Key("servo.$i.enable"),
        title: Text("Servo $i"),
        subtitle: Slider.adaptive(
          value: motorValue[i],
          onChanged: func,
          onChangeEnd: (value) {
            if (motorEnable[i]) {
              // writeCmd(i);
            }
          },
          min: 0.0,
          max: 180.0,
          divisions: 180,
          label: "${motorValue[i].toInt()}",
          allowedInteraction: SliderInteraction.slideThumb,
        ),
        trailing: Switch.adaptive(
          value: motorEnable[i],
          onChanged: (value) {
            setState(() {
              motorEnable[i] = value;
            });
            writeCmd(i);
          },
        ),
      ));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildController(context),
    );
  }
}
