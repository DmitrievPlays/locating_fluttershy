import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locating_fluttershy/about.dart';
import 'package:locating_fluttershy/data.dart';
import 'package:locating_fluttershy/database.dart';
import 'package:locating_fluttershy/home.dart';
import 'package:locating_fluttershy/trips.dart';
import 'package:locating_fluttershy/location_service.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(0, 0, 129, 112)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Locating Fluttershy"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    DatabaseHelper.initDB();

    //_database = initDB();

    determinePosition().then((pos) {
      Data.loc = pos;
      print(pos);
    });

    initializeLocationUpdater().listen((pos) {
      print('${pos.latitude}; ${pos.longitude}');
    });

    Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
    Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  }

  int index = 0;
  //int _travelled = 0;
  //final int _speed_avg = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: index,
        children: const [
          HomePage(title: "Home"),
          TripsPage(title: "Trips"),
          AboutPage(title: "About")
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline_sharp),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: index,
        selectedItemColor: Colors.teal[300],
        onTap: (int newindex) {
          setState(() {
            index = newindex;
          });
        },
      ),
    );
  }
}
