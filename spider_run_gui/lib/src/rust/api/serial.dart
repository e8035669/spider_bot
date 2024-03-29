// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.27.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `SerialComponents` is not used by any `pub` functions, thus it is ignored.

Future<List<String>> listPorts({dynamic hint}) =>
    RustLib.instance.api.listPorts(hint: hint);

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::rust_async::RwLock<SerialConnection>>
@sealed
class SerialConnection extends RustOpaque {
  SerialConnection.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  SerialConnection.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_SerialConnection,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_SerialConnection,
    rustArcDecrementStrongCountPtr: RustLib
        .instance.api.rust_arc_decrement_strong_count_SerialConnectionPtr,
  );

  static Future<SerialConnection> create(
          {required String deviceName, dynamic hint}) =>
      RustLib.instance.api
          .serialConnectionCreate(deviceName: deviceName, hint: hint);

  Future<void> sendWriteCmd(
          {required int pin, required int deg, dynamic hint}) =>
      RustLib.instance.api.serialConnectionSendWriteCmd(
        that: this,
        pin: pin,
        deg: deg,
      );
}
