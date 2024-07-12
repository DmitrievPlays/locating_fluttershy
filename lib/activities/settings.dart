import 'package:flutter/material.dart';
import 'package:locating_fluttershy/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
        child: Consumer<SettingsProvider>(
            builder: (context, notifier, child) => Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Settings"),
                  titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                body: Padding(padding: const EdgeInsets.all(6),
                    child: Column(children: [
                      SwitchListTile(
                        title: const Text("Dark Mode"),
                        onChanged: (value) {
                          setState((){
                            value = value;
                          });
                          notifier.saveSetting("dark", value);
                        },
                        value: notifier.getSetting("dark") ?? false,
                      ),
                      SwitchListTile(
                        title: const Text("Screen always on"),
                        onChanged: (value) {
                          setState((){
                            value = value;
                          });
                          notifier.saveSetting("always_on", value);
                        },
                        value: notifier.getSetting("always_on") ?? false,
                      ),
                    ],)
                ))
        ));
  }
}