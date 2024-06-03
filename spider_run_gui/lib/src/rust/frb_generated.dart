// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.32.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/serial.dart';
import 'api/simple.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.io.dart' if (dart.library.html) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.initApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.0.0-dev.32';

  @override
  int get rustContentHash => -961366495;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_spider_run_gui',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Future<void> serialConnectionConnect(
      {required SerialConnection that,
      required String deviceName,
      required bool mock,
      dynamic hint});

  Future<void> serialConnectionDisconnect(
      {required SerialConnection that, dynamic hint});

  Future<SpiderFootSetting> serialConnectionGetSetting(
      {required SerialConnection that, required int pin, dynamic hint});

  Future<SpiderFootStatus> serialConnectionGetStatus(
      {required SerialConnection that, required int pin, dynamic hint});

  Future<bool> serialConnectionIsConnected(
      {required SerialConnection that, dynamic hint});

  SerialConnection serialConnectionNew({dynamic hint});

  Future<void> serialConnectionReset(
      {required SerialConnection that, dynamic hint});

  Future<void> serialConnectionSave(
      {required SerialConnection that, dynamic hint});

  Future<void> serialConnectionUpdate(
      {required SerialConnection that,
      required int pin,
      required double centerDeg,
      required double multiply,
      dynamic hint});

  Future<void> serialConnectionWrite(
      {required SerialConnection that,
      required int pin,
      required int deg,
      dynamic hint});

  Future<List<String>> listPorts({dynamic hint});

  String greet({required String name, dynamic hint});

  Future<String> hello({required String a, dynamic hint});

  Future<void> initApp({dynamic hint});

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_SerialConnection;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_SerialConnection;

  CrossPlatformFinalizerArg
      get rust_arc_decrement_strong_count_SerialConnectionPtr;
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Future<void> serialConnectionConnect(
      {required SerialConnection that,
      required String deviceName,
      required bool mock,
      dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        sse_encode_String(deviceName, serializer);
        sse_encode_bool(mock, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionConnectConstMeta,
      argValues: [that, deviceName, mock],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionConnectConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_connect",
        argNames: ["that", "deviceName", "mock"],
      );

  @override
  Future<void> serialConnectionDisconnect(
      {required SerialConnection that, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionDisconnectConstMeta,
      argValues: [that],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionDisconnectConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_disconnect",
        argNames: ["that"],
      );

  @override
  Future<SpiderFootSetting> serialConnectionGetSetting(
      {required SerialConnection that, required int pin, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        sse_encode_i_32(pin, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 8, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_spider_foot_setting,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionGetSettingConstMeta,
      argValues: [that, pin],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionGetSettingConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_get_setting",
        argNames: ["that", "pin"],
      );

  @override
  Future<SpiderFootStatus> serialConnectionGetStatus(
      {required SerialConnection that, required int pin, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        sse_encode_i_32(pin, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 9, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_spider_foot_status,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionGetStatusConstMeta,
      argValues: [that, pin],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionGetStatusConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_get_status",
        argNames: ["that", "pin"],
      );

  @override
  Future<bool> serialConnectionIsConnected(
      {required SerialConnection that, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_bool,
        decodeErrorData: null,
      ),
      constMeta: kSerialConnectionIsConnectedConstMeta,
      argValues: [that],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionIsConnectedConstMeta =>
      const TaskConstMeta(
        debugName: "SerialConnection_is_connected",
        argNames: ["that"],
      );

  @override
  SerialConnection serialConnectionNew({dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 2)!;
      },
      codec: SseCodec(
        decodeSuccessData:
            sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection,
        decodeErrorData: null,
      ),
      constMeta: kSerialConnectionNewConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionNewConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_new",
        argNames: [],
      );

  @override
  Future<void> serialConnectionReset(
      {required SerialConnection that, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 11, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionResetConstMeta,
      argValues: [that],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionResetConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_reset",
        argNames: ["that"],
      );

  @override
  Future<void> serialConnectionSave(
      {required SerialConnection that, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 10, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionSaveConstMeta,
      argValues: [that],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionSaveConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_save",
        argNames: ["that"],
      );

  @override
  Future<void> serialConnectionUpdate(
      {required SerialConnection that,
      required int pin,
      required double centerDeg,
      required double multiply,
      dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        sse_encode_i_32(pin, serializer);
        sse_encode_f_64(centerDeg, serializer);
        sse_encode_f_64(multiply, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionUpdateConstMeta,
      argValues: [that, pin, centerDeg, multiply],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionUpdateConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_update",
        argNames: ["that", "pin", "centerDeg", "multiply"],
      );

  @override
  Future<void> serialConnectionWrite(
      {required SerialConnection that,
      required int pin,
      required int deg,
      dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
            that, serializer);
        sse_encode_i_32(pin, serializer);
        sse_encode_i_32(deg, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kSerialConnectionWriteConstMeta,
      argValues: [that, pin, deg],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kSerialConnectionWriteConstMeta => const TaskConstMeta(
        debugName: "SerialConnection_write",
        argNames: ["that", "pin", "deg"],
      );

  @override
  Future<List<String>> listPorts({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 1, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_String,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kListPortsConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kListPortsConstMeta => const TaskConstMeta(
        debugName: "list_ports",
        argNames: [],
      );

  @override
  String greet({required String name, dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(name, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 12)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kGreetConstMeta,
      argValues: [name],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGreetConstMeta => const TaskConstMeta(
        debugName: "greet",
        argNames: ["name"],
      );

  @override
  Future<String> hello({required String a, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(a, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 14, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kHelloConstMeta,
      argValues: [a],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kHelloConstMeta => const TaskConstMeta(
        debugName: "hello",
        argNames: ["a"],
      );

  @override
  Future<void> initApp({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 13, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitAppConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  RustArcIncrementStrongCountFnType
      get rust_arc_increment_strong_count_SerialConnection => wire
          .rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection;

  RustArcDecrementStrongCountFnType
      get rust_arc_decrement_strong_count_SerialConnection => wire
          .rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection;

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  SerialConnection
      dco_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return SerialConnection.dcoDecode(raw as List<dynamic>);
  }

  @protected
  SerialConnection
      dco_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return SerialConnection.dcoDecode(raw as List<dynamic>);
  }

  @protected
  SerialConnection
      dco_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return SerialConnection.dcoDecode(raw as List<dynamic>);
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as bool;
  }

  @protected
  double dco_decode_f_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as double;
  }

  @protected
  int dco_decode_i_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  List<String> dco_decode_list_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_String).toList();
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  SpiderFootSetting dco_decode_spider_foot_setting(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return SpiderFootSetting(
      centerDeg: dco_decode_f_64(arr[0]),
      multiply: dco_decode_f_64(arr[1]),
    );
  }

  @protected
  SpiderFootStatus dco_decode_spider_foot_status(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return SpiderFootStatus(
      enabled: dco_decode_bool(arr[0]),
      deg: dco_decode_i_32(arr[1]),
    );
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  int dco_decode_usize(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeI64OrU64(raw);
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  SerialConnection
      sse_decode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return SerialConnection.sseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  SerialConnection
      sse_decode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return SerialConnection.sseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  SerialConnection
      sse_decode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return SerialConnection.sseDecode(
        sse_decode_usize(deserializer), sse_decode_i_32(deserializer));
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  double sse_decode_f_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getFloat64();
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <String>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_String(deserializer));
    }
    return ans_;
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  SpiderFootSetting sse_decode_spider_foot_setting(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_centerDeg = sse_decode_f_64(deserializer);
    var var_multiply = sse_decode_f_64(deserializer);
    return SpiderFootSetting(centerDeg: var_centerDeg, multiply: var_multiply);
  }

  @protected
  SpiderFootStatus sse_decode_spider_foot_status(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_enabled = sse_decode_bool(deserializer);
    var var_deg = sse_decode_i_32(deserializer);
    return SpiderFootStatus(enabled: var_enabled, deg: var_deg);
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  int sse_decode_usize(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint64();
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ()');
  }

  @protected
  void
      sse_encode_Auto_Owned_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          SerialConnection self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(self.sseEncode(move: true), serializer);
  }

  @protected
  void
      sse_encode_Auto_Ref_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          SerialConnection self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(self.sseEncode(move: false), serializer);
  }

  @protected
  void
      sse_encode_RustOpaque_flutter_rust_bridgefor_generatedrust_asyncRwLockSerialConnection(
          SerialConnection self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_usize(self.sseEncode(move: null), serializer);
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_f_64(double self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putFloat64(self);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_String(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_spider_foot_setting(
      SpiderFootSetting self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_f_64(self.centerDeg, serializer);
    sse_encode_f_64(self.multiply, serializer);
  }

  @protected
  void sse_encode_spider_foot_status(
      SpiderFootStatus self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_bool(self.enabled, serializer);
    sse_encode_i_32(self.deg, serializer);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_usize(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint64(self);
  }
}
