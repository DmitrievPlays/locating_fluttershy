import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String AppVersion = "0.03";

  Future<void> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      AppVersion = packageInfo.version;
      print("object");
    });


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    @override
    void initState() {
      super.initState();

      _initPackageInfo();
            print("init");
    }
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(image: AssetImage('assets/fluttershy.png')),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(10),
                  child: const Text('Locating Fluttershy',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36, color: Colors.grey))),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(10),
                child: Text('Версия $AppVersion',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
