import 'dart:convert';

import '../utils/borneo_play_integrity.dart';

class BorneoPlayIntegrity extends BorneoPlayIntegrityInterface {
  bool _initialized = false;

  @override
  bool get isInitialized => _initialized;

  @override
  Future initialize(double productId, [String nonce = "borneo_security_default_nonce"]) async {
    return methodChannel.invokeMethod("initialize", {"project_id": productId, "nonce": base64Encode(nonce.codeUnits)}).then((value) {
      _initialized = value ?? false;
    });
  }

  @override
  Future getIntegrityToken() async {
    return methodChannel.invokeMethod("getPlayIntegrityToken");
  }
}
