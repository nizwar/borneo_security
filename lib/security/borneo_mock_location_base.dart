import 'package:borneo_security/utils/borneo_mock_apps.dart';

class BorneoMockLocationSecurity extends BorneoMockApps {
  @override
  Future<List<String>> getMockedApps() async {
    return methodChannel.invokeMethod("mockAppLocationList").then((value) {
      return List<String>.from(value);
    });
  }

  @override
  Future<bool> hasMockedApps() async {
    return methodChannel.invokeMethod("hasMockAppLocation").then((value) {
      return value;
    });
  }

  @override
  Future<bool> isMockEnabled() async {
    return methodChannel
        .invokeMethod("isMockEnabled")
        .then<bool>((value) => value)
        .catchError((e) => false);
  }
}
