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

### Server-side Integration
Add this package 

```sh composer require google/apiclient:^2.12.1```

Here is fast way to do it [Click here for reference](https://stackoverflow.com/a/71528749/17657666)
```php
use Google\Client;
use Google\Service\PlayIntegrity;
use Google\Service\PlayIntegrity\DecodeIntegrityTokenRequest;

public function performCheck(Request $request) {
    $client = new Client();
    $client->setAuthConfig(path/to/your/credentials/json/file.json);
    $client->addScope(PlayIntegrity::PLAYINTEGRITY);
    $service = new PlayIntegrity($client);
    $tokenRequest = new DecodeIntegrityTokenRequest();
    $tokenRequest->setIntegrityToken("TOKEN_HERE");
    $result = $service->v1->decodeIntegrityToken('PACKGE_NAME_HERE', $tokenRequest);
    
    if ($oldNonce !== $resultNonce) {
       echo "bad nonce";
       exit(1);
    }

    $deviceVerdict = $result->deviceIntegrity->deviceRecognitionVerdict;
    $appVerdict = $result->appIntegrity->appRecognitionVerdict;
    $accountVerdict = $result->accountDetails->appLicensingVerdict;

    //Possible values of $deviceVerdict[0] : MEETS_BASIC_INTEGRITY, MEETS_DEVICE_INTEGRITY, MEETS_STRONG_INTEGRITY
    if (!isset($deviceVerdict) || $deviceVerdict[0] !== 'MEETS_DEVICE_INTEGRITY') {
        echo "device doesn't meet requirement";
        exit(1);
    }
   //Possible values of $appVerdict: PLAY_RECOGNIZED, UNRECOGNIZED_VERSION, UNEVALUATED
    if ($appVerdict !== 'PLAY_RECOGNIZED') {
        echo "App not recognized";
        exit(1);
    }
    
   //Possible values of $accountVerdict: LICENSED, UNLICENSED, UNEVALUATED
   if ($accountVerdict !== 'LICENSED') {
       echo "User is not licensed to use app";
       exit(1);
   }
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
