import 'package:flutter/material.dart';
import 'package:spider_run_gui/src/rust/api/serial.dart';

class ConnectDevicePage extends StatelessWidget {
  final String deviceName;

  const ConnectDevicePage(this.deviceName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName),
      ),
      body: ConnectDeviceBody(deviceName),
    );
  }
}

class ConnectDeviceBody extends StatefulWidget {
  final String deviceName;

  const ConnectDeviceBody(this.deviceName, {super.key});

  @override
  State<ConnectDeviceBody> createState() => _ConnectDeviceBodyState();
}

class _ConnectDeviceBodyState extends State<ConnectDeviceBody> {
  List<bool> motorEnable = List.filled(32, false);
  List<double> motorValue = List.filled(32, 90.0);

  Future<Null>? serialFut;
  SerialConnection? serial;

  @override
  void initState() {
    super.initState();
    var serialFut =
        Future(() => SerialConnection.create(deviceName: widget.deviceName));
    var thenFut = serialFut.then(
      (value) {
        serial = value;
        debugPrint("Serial is ready");
      },
      onError: (error, stack) {
        debugPrint("Error on open, $error");
        debugPrint(stack);
        setState(() {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error on open ${widget.deviceName}'),
            ),
          );
        });
      },
    );
    this.serialFut = thenFut;
  }

  @override
  void dispose() {
    super.dispose();
    serialFut = null;
    serial = null;
  }

  void writeCmd(int pin) async {
    if (motorEnable[pin]) {
      var deg = motorValue[pin];
      debugPrint("sendWriteCmd $pin ${deg.toInt()}");
      await serial?.sendWriteCmd(pin: pin, deg: deg.toInt());
    } else {
      debugPrint("sendWriteCmd $pin -1");
      await serial?.sendWriteCmd(pin: pin, deg: -1);
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

class MockConnectDevicePage extends StatelessWidget {
  final String deviceName;

  const MockConnectDevicePage(this.deviceName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName),
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: MockConnectDeviceBody(deviceName),
    );
  }
}

class MockConnectDeviceBody extends StatefulWidget {
  final String deviceName;

  const MockConnectDeviceBody(this.deviceName, {super.key});

  @override
  State<MockConnectDeviceBody> createState() => _MockConnectDeviceBodyState();
}

class _MockConnectDeviceBodyState extends State<MockConnectDeviceBody> {
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
    if (motorEnable[pin]) {
      var deg = motorValue[pin];
      debugPrint("sendWriteCmd $pin ${deg.toInt()}");
    } else {
      debugPrint("sendWriteCmd $pin -1");
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
