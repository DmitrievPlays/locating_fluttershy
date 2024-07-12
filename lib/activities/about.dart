import 'package:flutter/material.dart';
import 'package:locating_fluttershy/activities/settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.title});

  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  String appVersion = "";

  Future<void> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                  },
                  icon: const Icon(Icons.settings)),
              const Image(image: AssetImage('assets/fluttershy.png')),
              const SizedBox(
                  width: double.infinity,
                  child: Text('Locating Fluttershy',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36))),
              SizedBox(
                width: double.infinity,
                child: Text('Версия $appVersion',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
