import 'dart:typed_data';

import 'package:borneo_security/interfaces/constant.dart';

import '../interfaces/borneo_packages_interface.dart';
import '../model/app_package.dart';

/// A class for managing installed app packages and retrieving their information.
class BorneoPackages extends BorneoPackagesInterface {
  BorneoPackages._();
  static BorneoPackages? _instance;

  /// Returns the singleton instance of [BorneoPackages].
  ///
  /// This ensures that only one instance of the BorneoPackages is created
  /// throughout the application, following the singleton design pattern.
  ///
  /// Usage:
  /// ```dart
  /// var packages1 = BorneoPackages.instance;
  /// var packages2 = BorneoPackages.instance;
  /// ```
  static BorneoPackages get instance {
    _instance ??= BorneoPackages._();
    return _instance!;
  }

  /// Retrieves a list of installed apps on the device.
  ///
  /// If [fetchIcons] is `true`, app icons will also be fetched.
  @override
  Future<List<AppPackage>> getInstalledApps([bool fetchIcons = false]) async {
    return methodChannel.invokeMethod(String.fromCharCodes(Constant.methodInstalledApps), {"fetch_icons": fetchIcons}).then((value) {
      return List<AppPackage>.from(value.map((e) => Map<String, dynamic>.from(e)).map((e) => AppPackage.fromMap(e)));
    });
  }

  /// Retrieves the icon of the app with the given [packageName].
  ///
  /// Returns the icon as a [Uint8List].
  @override
  Future<Uint8List> getIcon(String packageName) {
    return methodChannel.invokeMethod(String.fromCharCodes(Constant.methodGetIcon), {"package_name": packageName}).then((value) => Uint8List.fromList(value.cast<int>()));
  }

  /// Retrieves detailed information about the app with the given [packageName].
  ///
  /// Returns an [AppPackage] object containing the app's details.
  @override
  Future<AppPackage> getPackageInfo(String packageName) {
    return methodChannel.invokeMethod(String.fromCharCodes(Constant.methodGetPackageInfo), {"package_name": packageName}).then((value) => AppPackage.fromMap(Map<String, dynamic>.from(value)));
  }
}
