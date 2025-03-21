import 'package:flutter/services.dart';

/// An abstract class that provides methods to interact with the Play Integrity API
/// for security purposes.
abstract class BorneoPlayIntegrityInterface {
  /// The channel name used for communication with the native platform.
  static final String channel = 'id.laskarmedia.borneo/security';

  /// The method channel used to invoke methods on the native platform.
  final MethodChannel methodChannel = MethodChannel('$channel/playIntegrity');

  /// Indicates whether the Play Integrity API has been initialized.
  bool get isInitialized => false;

  /// Initializes the Play Integrity API with the given `productId` and `nonce`.
  ///
  /// Only able to be called once.
  Future<bool> initialize(double productId, [String nonce = ""]) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Retrieves the integrity token from the Play Integrity API.
  Future<String> getIntegrityToken() async {
    throw UnimplementedError('getIntegrityToken() has not been implemented.');
  }
}
