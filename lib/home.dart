import 'package:flutter/material.dart';
import 'package:locating_fluttershy/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _travelled = 0;
  final int _speed_avg = 0;

  void _tripAction() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _travelled++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(6),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF78909C),
                      ),
                      color: const Color(0xFF78909C),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: Column(
                    children: [
                      const Text('Пройдено',
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                      Text('$_travelled',
                          style: const TextStyle(
                              fontSize: 48, color: Colors.white))
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(left: 3),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF78909C),
                      ),
                      color: const Color(0xFF78909C),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16))),
                  child: Column(
                    children: [
                      const Text('V Средняя',
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                      Text('$_speed_avg',
                          style: const TextStyle(
                              fontSize: 48, color: Colors.white))
                    ],
                  )),
            ),
          ],
        ),
        Expanded(
            child: Column(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(bottom: 30),
                child: Expanded(
                    child: IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    DatabaseHelper.newRoute();
                  },
                  style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey[400],
                      padding: const EdgeInsets.all(16)),
                )),
              ),
              Row(children: [
                Expanded(
                    child: TextButton.icon(
                  style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey[400],
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, top: 16, bottom: 16)),
                  onPressed: () {
                    DatabaseHelper.newRoute();
                  },
                  label: const Text(
                    'START',
                    style: TextStyle(fontSize: 16),
                  ),
                ))
              ]),
              const SizedBox(height: 16)
            ]))
      ]),
    ));
  }
}
