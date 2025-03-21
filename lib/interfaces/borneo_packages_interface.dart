import 'package:borneo_security/model/app_package.dart';
import 'package:flutter/services.dart';

/// An abstract interface that defines the contract for interacting with
/// Borneo packages. This interface provides a method to retrieve a list
/// of installed applications.
abstract class BorneoPackagesInterface {
  static final String channel = 'id.laskarmedia.borneo/security';

  /// The method channel used to invoke methods on the native platform.
  final MethodChannel methodChannel = MethodChannel('$channel/packages');

    /// Retrieves a list of installed applications.
    ///
    /// This method returns a [Future] that resolves to a list of [AppPackage]
    /// objects representing the installed applications on the device.
    ///
    /// - Parameter [fetchIcons]: A boolean flag indicating whether to fetch
    ///   the icons of the installed applications. Defaults to `false`.
    /// - Returns: A [Future] that resolves to a list of [AppPackage] objects.
    ///   If the method is not implemented, it throws an [UnimplementedError].
    Future<List<AppPackage>> getInstalledApps([bool fetchIcons = false]) {
      throw UnimplementedError();
    }

  /// Retrieves the icon of the specified package.
  ///
  /// This method takes the [packageName] as a parameter and returns a
  /// [Future] that resolves to a [Uint8List] containing the icon data
  /// of the package. If the method is not implemented, it throws an
  /// [UnimplementedError].
  ///
  /// - Parameter [packageName]: The name of the package whose icon is to be retrieved.
  /// - Returns: A [Future] that resolves to the icon data as a [Uint8List].
  Future<Uint8List> getIcon(String packageName) {
    throw UnimplementedError();
  }

  /// Retrieves detailed information about the specified package.
  ///
  /// This method takes the [packageName] as a parameter and returns a
  /// [Future] that resolves to an [AppPackage] object containing the
  /// package's information. If the method is not implemented, it throws
  /// an [UnimplementedError].
  ///
  /// - Parameter [packageName]: The name of the package whose information is to be retrieved.
  /// - Returns: A [Future] that resolves to an [AppPackage] object with the package details.
  Future<AppPackage> getPackageInfo(String packageName) {
    throw UnimplementedError();
  }
}
