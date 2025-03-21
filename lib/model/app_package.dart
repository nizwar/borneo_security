import 'dart:typed_data';

/// A class that represents an application package.
///
/// This class can be used to define and manage the properties
/// and behaviors associated with an application package.
class AppPackage {
  /// The unique identifier for the application package.
  int uid;

  /// The name of the application.
  String name;

  /// The package name of the application.
  String packageName;

  /// The icon of the application as a byte array.
  Uint8List? icon;

  /// The source directory of the application.
  String? sourceDir;

  /// The data directory of the application.
  String? dataDir;

  /// The public source directory of the application.
  String? publicSourceDir;

  /// The process name associated with the application.
  String? processName;

  /// The installer of the application.
  String? installer;

  /// The version code of the application.
  int? versionCode;

  /// The version name of the application.
  String? versionName;

  /// The date and time when the application was first installed.
  DateTime? firstInstallTime;

  /// The date and time when the application was last updated.
  DateTime? lastUpdateTime;

  /// The list of signing certificates associated with the application.
  List<Signature> signingCertificates;

  /// The list of permissions required by the application.
  List<String> permissions;

  AppPackage({
    required this.uid,
    required this.name,
    required this.packageName,
    this.icon,
    this.sourceDir,
    this.dataDir,
    this.publicSourceDir,
    this.processName,
    this.installer,
    this.versionCode,
    this.versionName,
    this.firstInstallTime,
    this.lastUpdateTime,
    this.signingCertificates = const [],
    this.permissions = const [],
  });

  factory AppPackage.fromMap(Map<String, dynamic> map) {
    return AppPackage(
      uid: map['uid'],
      icon: map['icon'],
      name: map['name']?.toString() ?? '',
      sourceDir: map['sourceDir'],
      dataDir: map['dataDir'],
      publicSourceDir: map['publicSourceDir'],
      processName: map['processName'],
      packageName: map['packageName'],
      installer: map['installer'],
      versionCode: map['versionCode'],
      versionName: map['versionName'],
      firstInstallTime: map['firstInstallTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['firstInstallTime'])
          : null,
      lastUpdateTime: map['lastUpdateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastUpdateTime'])
          : null,
      signingCertificates: List<Signature>.from(
          (map['signing_certificates'] ?? [])
              .map((e) => Signature.fromMap(Map<String, dynamic>.from(e)))),
      permissions: List<String>.from(map['permissions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'sourceDir': sourceDir,
      'dataDir': dataDir,
      'publicSourceDir': publicSourceDir,
      'processName': processName,
      'packageName': packageName,
      'installer': installer,
      'versionCode': versionCode,
      'versionName': versionName,
      'firstInstallTime': firstInstallTime?.millisecondsSinceEpoch,
      'lastUpdateTime': lastUpdateTime?.millisecondsSinceEpoch,
      'icon': icon,
      'signing_certificates': signingCertificates,
      'permissions': permissions,
    };
  }
}

/// A class representing a digital signature.
///
/// This class can be used to handle and manage digital signatures
/// for secure communication or data validation purposes.
class Signature {
  /// The hash of the signature.
  String hash;

  /// The signature value.
  String signature;

  /// The subject distinguished name of the certificate.
  String? subjectDN;

  /// The issuer distinguished name of the certificate.
  String? issuerDN;

  /// The serial number of the certificate.
  String? serialNumber;

  /// The start date of the certificate's validity period.
  DateTime? notBefore;

  /// The end date of the certificate's validity period.
  DateTime? notAfter;

  /// The algorithm used for the public key.
  String? publicKeyAlgorithm;

  /// The format of the public key.
  String? publicKeyFormat;

  /// The encoded public key as a byte array.
  Uint8List? publicKeyEncoded;

  /// The public key value.
  String? publicKey;

  /// The hash of the public key.
  String? publicKeyHash;

  Signature({
    required this.hash,
    required this.signature,
    this.subjectDN,
    this.issuerDN,
    this.serialNumber,
    this.notBefore,
    this.notAfter,
    this.publicKeyAlgorithm,
    this.publicKeyFormat,
    this.publicKeyEncoded,
    this.publicKey,
    this.publicKeyHash,
  });

  factory Signature.fromMap(Map<String, dynamic> map) {
    return Signature(
      hash: map['hash'],
      signature: map['signature'],
      subjectDN: map['subjectDN'],
      issuerDN: map['issuerDN'],
      serialNumber: map['serialNumber']?.toString(),
      notBefore: map['notBefore'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['notBefore'])
          : null,
      notAfter: map['notAfter'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['notAfter'])
          : null,
      publicKeyAlgorithm: map['publicKeyAlgorithm'],
      publicKeyFormat: map['publicKeyFormat'],
      publicKeyEncoded: map['publicKeyEncoded'] != null
          ? Uint8List.fromList(List<int>.from(map['publicKeyEncoded']))
          : null,
      publicKey: map['publicKey'],
      publicKeyHash: map['publicKeyHash'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'signature': signature,
      'subjectDN': subjectDN,
      'issuerDN': issuerDN,
      'serialNumber': serialNumber,
      'notBefore': notBefore?.toIso8601String(),
      'notAfter': notAfter?.toIso8601String(),
      'publicKeyAlgorithm': publicKeyAlgorithm,
      'publicKeyFormat': publicKeyFormat,
      'publicKeyEncoded': publicKeyEncoded,
      'publicKey': publicKey,
      'publicKeyHash': publicKeyHash,
    };
  }

  @override
  String toString() {
    return 'Signature{hash: $hash, signature: $signature, subjectDN: $subjectDN, issuerDN: $issuerDN, serialNumber: $serialNumber, notBefore: $notBefore, notAfter: $notAfter, publicKeyAlgorithm: $publicKeyAlgorithm, publicKeyFormat: $publicKeyFormat, publicKeyEncoded: $publicKeyEncoded, publicKey: $publicKey, publicKeyHash: $publicKeyHash}';
  }
}
