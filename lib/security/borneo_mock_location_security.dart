import 'package:borneo_security/interfaces/borneo_mock_apps_interface.dart';

import '../interfaces/constant.dart';

/// A class for detecting mocked apps and checking mock location settings.
class BorneoMockLocationSecurity extends BorneoMockApps {
  /// Retrieves a list of mocked apps installed on the device.
  @override
  @Deprecated("Use BorneoPackages instead.")
  Future<List<String>> getMockedApps() async {
    return methodChannel.invokeMethod(String.fromCharCodes(Constant.methodMockAppLocationList)).then((value) {
      return List<String>.from(value);
    });
  }

  /// Checks if there are any mocked apps installed on the device.
  ///
  /// Returns `true` if mocked apps are detected, otherwise `false`.
  @override
  @Deprecated("Use BorneoPackages instead.")
  Future<bool> hasMockedApps() async {
    return methodChannel.invokeMethod(String.fromCharCodes(Constant.methodHasMockLocation)).then((value) {
      return value;
    });
  }

  /// Checks if mock location is enabled on the device.
  ///
  /// Returns `true` if mock location is enabled, otherwise `false`.
  @override
  Future<bool> isMockEnabled() async {
    return methodChannel.invokeMethod(String.fromCharCodes(Constant.methodIsMockEnabled)).then<bool>((value) => value);
  }
}
