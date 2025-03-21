import 'package:borneo_security/interfaces/borneo_mock_apps_interface.dart';

/// A class for detecting mocked apps and checking mock location settings.
class BorneoMockLocationSecurity extends BorneoMockApps {
  /// Retrieves a list of mocked apps installed on the device.
  @override
  Future<List<String>> getMockedApps() async {
    return methodChannel.invokeMethod("mockAppLocationList").then((value) {
      return List<String>.from(value);
    });
  }

  /// Checks if there are any mocked apps installed on the device.
  ///
  /// Returns `true` if mocked apps are detected, otherwise `false`.
  @override
  Future<bool> hasMockedApps() async {
    return methodChannel.invokeMethod("hasMockAppLocation").then((value) {
      return value;
    });
  }

  /// Checks if mock location is enabled on the device.
  ///
  /// Returns `true` if mock location is enabled, otherwise `false`.
  @override
  Future<bool> isMockEnabled() async {
    return methodChannel
        .invokeMethod("isMockEnabled")
        .then<bool>((value) => value)
        .catchError((e) => false);
  }
}
