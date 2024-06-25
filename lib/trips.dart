import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> items = List<String>.generate(100, (i) => 'Item $i');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        child: ListView.separated(
            itemCount: items.length,
            /*prototypeItem: ListTile(
              title: Text(items.first),
            ),*/
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Route $index'),
                tileColor: Colors.amber,
                contentPadding: const EdgeInsets.all(6),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
      },),
      ),
    );
  }
}
