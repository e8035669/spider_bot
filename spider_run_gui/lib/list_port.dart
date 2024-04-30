import 'package:flutter/material.dart';
import 'package:spider_run_gui/src/rust/api/serial.dart';
import 'package:spider_run_gui/connect_device.dart';

class ListPortPage extends StatefulWidget {
  const ListPortPage({
    super.key,
  });

  @override
  State<ListPortPage> createState() => _ListPortPageState();
}

class _ListPortPageState extends State<ListPortPage> {
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
          debugPrint('${snapshot.error}');
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

    return Padding(
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
    );
  }
}

class MockListPortPage extends StatefulWidget {
  const MockListPortPage({
    super.key,
  });

  @override
  State<MockListPortPage> createState() => _MockListPortPageState();
}

class _MockListPortPageState extends State<MockListPortPage> {
  late Stream<List<String>> portsStream;

  Stream<List<String>> getPortsStream() async* {
    while (true) {
      // yield await listPorts();
      yield List.of(['/dev/mock1', '/dev/mock2', '/dev/mock3']);
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
                  builder: (context) => MockConnectDevicePage(d),
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
          debugPrint('${snapshot.error}');
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

    return Padding(
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
    );
  }
}
