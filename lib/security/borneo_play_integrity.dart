import '../interfaces/borneo_play_integrity_interface.dart';

/// A class that implements the Play Integrity API for verifying device integrity.
class BorneoPlayIntegrity extends BorneoPlayIntegrityInterface {
  bool _initialized = false;

  /// Indicates whether the Play Integrity API has been initialized.
  @override
  bool get isInitialized => _initialized;

  /// Initializes the Play Integrity API with the given [cloudProjectNumber] and optional [nonce].
  ///
  /// Returns `true` if initialization is successful, otherwise `false`.
  @override
  Future<bool> initialize(double cloudProjectNumber, [String nonce = "borneo_security_default_nonce"]) async {
    return methodChannel.invokeMethod("initialize", {"cloud_project_number": cloudProjectNumber}).then((value) {
      _initialized = value ?? false;
      return _initialized;
    });
  }

  /// Retrieves the integrity token from the Play Integrity API.
  ///
  /// Returns the integrity token as a [String].
  @override
  Future<String> getIntegrityToken() async {
    return methodChannel.invokeMethod("getPlayIntegrityToken", {"hash": "SHA-256"}).then((value) => value.toString());
  }
}
