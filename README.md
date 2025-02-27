# Borneo Security

Borneo Security is a library designed to help secure your Flutter app from mocker apps and ensure the device's integrity using the Play Integrity API. This library provides methods to detect mocked apps and verify the device's authenticity.

**Note: This package only supports Android.**

## Features

- Detect mocked apps installed on the device.
- Check if mock detection is enabled.
- Integrate with the Play Integrity API to verify device integrity.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  borneo_security: latest
```

## Usage

### Detecting Mocked Apps

To detect mocked apps, use the `BorneoMockLocationSecurity` class:

```dart
import 'package:borneo_security/borneo_security.dart';

final mockAppDetector = BorneoMockLocationSecurity();

Future<void> checkMockedApps() async {
  List<String> mockedApps = await mockAppDetector.getMockedApps();
  bool hasMockedApps = await mockAppDetector.hasMockedApps();
  bool isMockEnabled = await mockAppDetector.isMockEnabled();

  print('Mocked apps: $mockedApps');
  print('Has mocked apps: $hasMockedApps');
  print('Is mock enabled: $isMockEnabled');
}
```

### Using Play Integrity API

To use the Play Integrity API, use the `BorneoPlayIntegrity` class:

```dart
import 'package:borneo_security/borneo_security.dart';

final playIntegrity = BorneoPlayIntegrity();

Future<void> checkPlayIntegrity() async {
  await playIntegrity.initialize(12345);
  var integrityToken = await playIntegrity.getIntegrityToken();

  print('Integrity token: $integrityToken');
}
```

## Example

Here is an example of how to use the `BorneoMockLocationSecurity` and `BorneoPlayIntegrity` classes:

```dart
void main() async {
  final mockAppDetector = BorneoMockLocationSecurity();
  final playIntegrity = BorneoPlayIntegrity();

  // Initialize Play Integrity
  await playIntegrity.initialize(12345);

  // Check for mocked apps
  bool hasMockedApps = await mockAppDetector.hasMockedApps();
  print('Has mocked apps: $hasMockedApps');

  // Get integrity token
  var integrityToken = await playIntegrity.getIntegrityToken();
  print('Integrity token: $integrityToken');
}
```

## License

This project is licensed under the MIT License.
