import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spider_run_gui/common_page.dart';
import 'package:spider_run_gui/raw_control.dart';
import 'package:spider_run_gui/src/rust/api/serial.dart';

class FunctionMenuBody extends StatefulWidget {
  final String deviceName;

  const FunctionMenuBody(this.deviceName, {super.key});

  @override
  State<FunctionMenuBody> createState() => _FunctionMenuBodyState();
}

class _FunctionMenuBodyState extends State<FunctionMenuBody> {
  Future<String>? connectState;

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

  Widget buildContent(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: const Text("Raw Control"),
            onTap: () {
              var model = context.read<SerialConnectModel>();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Provider.value(
                    value: model,
                    child: CommonPage(Text(widget.deviceName),
                        RawControlBody(widget.deviceName)),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: connectState,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error on open ${widget.deviceName}'),
            ),
          );
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

class SerialConnectModel {
  SerialConnection conn = SerialConnection();

  Future<Null> connect(String deviceName) async {
    await conn.connect(deviceName: deviceName, mock: true);
  }

  void disconnect() async {
    await conn.disconnect();
  }

  Future<bool> isConnected() async {
    return await conn.isConnected();
  }

  Future<Null> sendWriteCmd(int pin, int deg) async {
    await conn.sendWriteCmd(pin: pin, deg: deg);
  }
}
