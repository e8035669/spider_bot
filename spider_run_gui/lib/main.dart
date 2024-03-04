import 'package:flutter/material.dart';
import 'package:spider_run_gui/src/rust/api/serial.dart';
import 'package:spider_run_gui/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<List<String>> portsStream;

  Stream<List<String>> getPortsStream() async* {
    while (true) {
      yield await listPorts();
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void initState() {
    super.initState();
    portsStream = getPortsStream();
  }

  List<Widget> buildDevices(BuildContext context, List<String> devices) {
    var ret = [
      for (var d in devices)
        Card(
          child: ListTile(
            leading: const Icon(Icons.device_unknown),
            title: Text(d),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConnectDevicePage(d),
                ),
              );
            },
          ),
        ),
    ];
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    Widget devicesWidget = StreamBuilder(
      stream: portsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(
            child: Text("Has error"),
          );
        } else if (snapshot.hasData) {
          var ports = snapshot.data!;
          if (ports.isNotEmpty) {
            return ListView(
              children: buildDevices(context, ports),
            );
          }
        }
        return const Center(
          child: Text("No devices"),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Spider GUI')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Select device"),
            ),
            Expanded(
              child: devicesWidget,
            ),
          ],
        ),
      ),
    );
  }
}

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
        print("Serial is ready");
      },
      onError: (error, stack) {
        print("Error on open, $error");
        print(stack);
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
      print("sendWriteCmd $pin ${deg.toInt()}");
      await serial?.sendWriteCmd(pin: pin, deg: deg.toInt());
    } else {
      print("sendWriteCmd $pin -1");
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
