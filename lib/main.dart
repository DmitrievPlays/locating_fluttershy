import 'dart:async';
import 'dart:io';
import 'dart:ui';
//import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locating_fluttershy/activities/about.dart';
import 'package:locating_fluttershy/services/database_service.dart';
import 'package:locating_fluttershy/activities/home.dart';
import 'package:locating_fluttershy/providers/theme_provider.dart';
import 'package:locating_fluttershy/activities/trips.dart';
import 'package:locating_fluttershy/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
            return MaterialApp(
              title: 'LOCATING FLUTTERSHY',
              theme: notifier.darkTheme ? dark : light,
              themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
              home: const MyHomePage(title: "LOCATING FLUTTERSHY"),
              debugShowCheckedModeBanner: false,
            );
          },
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

LocationService ls = LocationService();


@pragma('vm:entry-point')
void startService(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // final socket = io.io("your-server-url", <String, dynamic>{
  //   'transports': ['websocket'],
  //   'autoConnect': true,
  // });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    flutterLocalNotificationsPlugin.show(
      0, 'Fluttershy is sending you a new message', 'Awesome ${DateTime.now()}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
            "notificationChannelId",
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
            onlyAlertOnce: true,
            priority: Priority.high
        ),
      ),
    );});
  ls.enableListener();

  Timer.periodic(const Duration(seconds: 2), (Timer t) {
    service.invoke(
      'update',
      {
        "current_trip_length": ls.tripLength,
      },
    );
  });
}

FlutterBackgroundService service = FlutterBackgroundService();

Future<void> initializeService() async {
  service = FlutterBackgroundService();

  await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: startService,
        isForegroundMode: true,
        autoStart: false,
        foregroundServiceNotificationId: 888,
      ), iosConfiguration: IosConfiguration(
    autoStart: true,
    onForeground: startService,
    onBackground: null,
  )
  );
  service.startService();
}



@pragma(
    'vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return Future.value(true);
  });
}


Future<void> requestPermission(Permission permission) async {
  if(!await permission.isGranted) {
    await permission.request();
  }
  else if(await permission.isPermanentlyDenied || await permission.isDenied){
    openAppSettings();
  }
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    requestPermission(Permission.manageExternalStorage);
    requestPermission(Permission.storage);
    Permission.manageExternalStorage.request();
    DatabaseHelper.initDB();

    Workmanager().initialize(
        callbackDispatcher);
    Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  }


  int index = 0;
  final List _pages =
    [const HomePage(title: "Home"),
    const TripsPage(title: "Trips"),
    const AboutPage(title: "About"),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title), titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: _pages[index],
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
        onTap: (int newindex) {
          setState(() {
            index = newindex;
          });
        },
      ),
    );
  }
}
