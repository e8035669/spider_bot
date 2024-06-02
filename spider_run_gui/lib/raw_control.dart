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
  Future<String>? loadState;

  @override
  void initState() {
    super.initState();

    var serial = context.read<SerialConnectModel>();
    loadState = serial.getAllFootStatus().then((value) => "OK");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        value: null,
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return const RawControlContent();
  }

  Widget buildError(BuildContext context) {
    return const Center(
      child: Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadState,
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

class RawControlContent extends StatefulWidget {
  const RawControlContent({super.key});

  @override
  State<RawControlContent> createState() => _RawControlContentState();
}

class _RawControlContentState extends State<RawControlContent> {
  void writeCmd(BuildContext context, int pin) async {
    var serial = context.read<SerialConnectModel>();

    var motorEnable = serial.motorEnable;
    var motorValue = serial.motorValue;

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
    var serial = context.read<SerialConnectModel>();

    var motorEnable = serial.motorEnable;
    var motorValue = serial.motorValue;
    List<Widget> ret = [];
    for (int i = 0; i < motorEnable.length; ++i) {
      void Function(double)? func;
      if (motorEnable[i]) {
        func = (value) {
          setState(() {
            motorValue[i] = value;
          });
          writeCmd(context, i);
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
            writeCmd(context, i);
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
