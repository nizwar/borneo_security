import 'package:flutter/services.dart';

/// An abstract class that provides methods to interact with mocked apps
/// for security purposes.
abstract class BorneoMockApps {
  /// The channel name used for communication with the native platform.
  static final String channel = 'id.laskarmedia.borneo/security';

  /// The method channel used to invoke methods on the native platform.
  final MethodChannel methodChannel = MethodChannel('$channel/mockAppLocation');

  /// Retrieves a list of mocked apps installed on the device.
  Future<List<String>> getMockedApps() {
    throw UnimplementedError('getMockedApps() has not been implemented.');
  }

  /// Checks if there are any mocked apps installed on the device.
  ///
  /// Returns `true` if there are mocked apps, otherwise `false`.
  Future<bool> hasMockedApps() {
    throw UnimplementedError('hasMockedApps() has not been implemented.');
  }

  /// Checks if mock detection is enabled.
  ///
  /// Returns `true` if mock detection is enabled, otherwise `false`.
  Future<bool> isMockEnabled() {
    throw UnimplementedError('isMockEnabled() has not been implemented.');
  }
}
