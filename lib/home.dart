
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final int _counter = 0;
  int _travelled = 0;
  final int _speed_avg = 0;
 
  void _incrementCounter() {
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
      body:
       Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        color: Colors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(16))),
                    child: Column(
                      children: [
                        const Text('Пройдено',
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                        Text('$_travelled',
                            style: const TextStyle(fontSize: 48, color: Colors.white))
                      ],
                    )),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        color: Colors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(16))),
                    child: Column(
                      children: [
                        const Text('V Средняя',
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                        Text('$_speed_avg',
                            style: const TextStyle(fontSize: 48, color: Colors.white))
                      ],
                    )),
              ),
            ],
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [const TextButton(
              onPressed: null,
              child: const Text("Start"),
            )],
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          child: FloatingActionButton.extended(
            elevation: 0,
            onPressed: _incrementCounter,
            tooltip: 'Start',
            label: const Text("Start"),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
