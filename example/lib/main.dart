import 'package:borneo_security/borneo_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Borneo Security')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                var mockChecker = BorneoMockLocationSecurity();
                final hasMockedApps = await mockChecker.hasMockedApps();
                final mockedApps = await mockChecker.getMockedApps();
                final isMockSettingsEnabled = await mockChecker.isMockEnabled();

                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Mocked Apps'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Text('Has Mocked Apps: $hasMockedApps'), Text('Mocked Apps:\n${mockedApps.join('\n')}'), Text('Is Mock Settings Enabled: $isMockSettingsEnabled')],
                        ),
                        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
                      ),
                );
              },
              child: const Text('Check Mocked Apps'),
            ),
            ElevatedButton(
              onPressed: () async {
                var integrityChecker = BorneoPlayIntegrity();
                //Write your own product id and nonce here
                await integrityChecker.initialize(0).catchError((_) {});
                final hasMockedApps = await integrityChecker.getIntegrityToken().showCustomProgressDialog(context);
                AlertDialog(
                  title: Text("Play Integrity Token"),
                  content: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: hasMockedApps));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to clipboard")));
                      Navigator.pop(context);
                    },
                    child: Padding(padding: EdgeInsets.all(10), child: SingleChildScrollView(child: Text(hasMockedApps))),
                  ),
                ).show(context);
              },
              child: const Text('Check Integrity'),
            ),
          ],
        ),
      ),
    );
  }
}
