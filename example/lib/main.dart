import 'package:borneo_security/borneo_security.dart';
import 'package:borneo_security/model/app_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: const App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  BorneoPlayIntegrity integrityChecker = BorneoPlayIntegrity.instance;
  BorneoMockLocationSecurity mockChecker = BorneoMockLocationSecurity.instance;
  BorneoPackages packages = BorneoPackages.instance;

  List<AppPackage> apps = [];

  @override
  void initState() {
    integrityChecker
        .initialize(801850423675)
        .catchError((e) => false)
        .then((value) {});
    packages.getInstalledApps(true).then((value) {
      setState(() {
        apps = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Borneo Security')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
                future: BorneoPlayIntegrity.instance.getDeviceId(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: const Text("Device ID"),
                      subtitle: Text(snapshot.data.toString()),
                    );
                  } else {
                    return Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator());
                  }
                }),
            ElevatedButton(
              onPressed: () async {
                final mockedApps = apps
                    .where((item) => item.permissions
                        .map((item) => item.toLowerCase())
                        .contains("android.permission.access_mock_location"))
                    .map((item) => item.packageName)
                    .toList();

                final hasMockedApps = mockedApps.isNotEmpty;
                final isMockSettingsEnabled =
                    await mockChecker.isMockEnabled().catchError((e) => false);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Mocked Apps'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Has Mocked Apps: $hasMockedApps'),
                        Text('Mocked Apps:\n${mockedApps.join('\n')}'),
                        Text('Is Mock Settings Enabled: $isMockSettingsEnabled')
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'))
                    ],
                  ),
                );
              },
              child: const Text('Check Mocked Apps'),
            ),
            ElevatedButton(
              onPressed: () async {
                final integrityToken = await integrityChecker
                    .getIntegrityToken()
                    .showCustomProgressDialog(context);
                AlertDialog(
                  title: Text("Play Integrity Token"),
                  content: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: integrityToken!));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Copied to clipboard")));
                      Navigator.pop(context);
                    },
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                            child: Text(integrityToken ?? "No token"))),
                  ),
                ).show(context);
              },
              child: const Text('Check Integrity'),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (apps.isNotEmpty) {
                    return ListView(
                        children: apps
                            .map(
                              (item) => ListTile(
                                title: Text(item.name),
                                subtitle: Text(item.packageName),
                                onTap: () {
                                  AlertDialog(
                                    title: Text("${item.name} Information"),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: item.toMap().entries.map((e) {
                                          if (e.value is Uint8List) {
                                            return ListTile(
                                              title: Text(e.key),
                                              subtitle: Image.memory(
                                                  e.value as Uint8List,
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.fitHeight),
                                            );
                                          }
                                          if (e.value
                                              is List<Map<String, dynamic>>) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                    title: Text("Certficates")),
                                                ...List.generate(
                                                  (e.value as List<
                                                          Map<String, dynamic>>)
                                                      .length,
                                                  (index) {
                                                    final cert = e.value[index];
                                                    return ExpansionTile(
                                                        title: Text(
                                                            "Certificate ${index + 1}"),
                                                        children: [
                                                          ListTile(
                                                              title:
                                                                  Text("Hash"),
                                                              subtitle: Text(
                                                                  cert['hash'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Signature"),
                                                              subtitle: Text(
                                                                  cert['signature'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Subject DN"),
                                                              subtitle: Text(
                                                                  cert['subjectDN'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Issuer DN"),
                                                              subtitle: Text(
                                                                  cert['issuerDN'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Serial Number"),
                                                              subtitle: Text(
                                                                  cert['serialNumber'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Not Before"),
                                                              subtitle: Text(
                                                                  cert['notBefore'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Not After"),
                                                              subtitle: Text(
                                                                  cert['notAfter'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Public Key Algorithm"),
                                                              subtitle: Text(
                                                                  cert['publicKeyAlgorithm'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Public Key Format"),
                                                              subtitle: Text(
                                                                  cert['publicKeyFormat'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Public Key"),
                                                              subtitle: Text(
                                                                  cert['publicKey'] ??
                                                                      '')),
                                                          ListTile(
                                                              title: Text(
                                                                  "Public Key Hash"),
                                                              subtitle: Text(
                                                                  cert['publicKeyHash'] ??
                                                                      '')),
                                                        ]);
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                          return ListTile(
                                              title: Text(e.key),
                                              subtitle:
                                                  Text(e.value.toString()));
                                        }).toList(),
                                      ),
                                    ),
                                  ).show(context);
                                },
                              ),
                            )
                            .toList());
                  } else {
                    return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
