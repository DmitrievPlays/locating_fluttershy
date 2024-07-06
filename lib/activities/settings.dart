import 'package:flutter/material.dart';
import 'package:locating_fluttershy/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Theme Switcher"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
          Consumer<ThemeNotifier>(
          builder:(context, notifier, child) =>
            SwitchListTile(
                  title: const Text("Dark Mode"),
                  onChanged:(value){
                    notifier.toggleTheme();
                  } ,
                  value:notifier.darkTheme,
                ),),
              ]
          ),
        )
    );
  }
}