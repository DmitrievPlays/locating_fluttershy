import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:locating_fluttershy/activities/about.dart';
import 'package:locating_fluttershy/providers/permission_provider.dart';
import 'package:locating_fluttershy/providers/settings_provider.dart';
import 'package:locating_fluttershy/services/database_service.dart';
import 'package:locating_fluttershy/activities/home.dart';
import 'package:locating_fluttershy/providers/theme_provider.dart';
import 'package:locating_fluttershy/activities/trips.dart';
import 'package:locating_fluttershy/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
        child: Consumer<SettingsProvider>(
          builder: (context, SettingsProvider notifier, child) {
            return MaterialApp(
              title: 'LOCATING FLUTTERSHY',
              theme: notifier.darkTheme ? dark : light,
              themeMode: notifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
              home: const MyHomePage(title: "LOCATING FLUTTERSHY"),
              debugShowCheckedModeBanner: false,
            );
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

DatabaseHelper helper = DatabaseHelper();

@pragma('vm:entry-point')
void startService(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final ls = LocationService();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) async {
    await service.stopSelf();
  });
  service.invoke("setAsBackground");

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    flutterLocalNotificationsPlugin.show(
      0,
      'Fluttershy is sending you a new message',
      'Awesome ${DateTime.now()}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
            "notificationChannelId", 'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
            onlyAlertOnce: true,
            priority: Priority.max),
      ),
    );

    service.invoke(
      'update',
      {
        "tripLength": LocationService().tripLength,
        "speed": LocationService().speed,
      },
    );
  });
  await ls.enableListener();
}

final service = FlutterBackgroundService();

Future<void> initializeService() async {
  await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: startService,
        isForegroundMode: true,
        autoStart: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: startService,
        onBackground: null,
      ));
  service.invoke("setAsBackground");
  //service.startService();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    PermissionProvider.requestPermission(Permission.notification);
    PermissionProvider.requestPermission(Permission.locationAlways);
    PermissionProvider.requestPermission(Permission.storage);
    PermissionProvider.requestPermission(Permission.manageExternalStorage);
    helper.initDB();
    isWakelock();
    //getData();
  }

  // void getData() async {
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     final ls = Injector.appInstance.get<LocationService>();
  //     print("data speed ${ls.speed}");
  //   });
  // }

  void isWakelock() async {
    SettingsProvider provider = SettingsProvider();
    await provider.getPrefs();

    if (provider.getSetting("always_on") == true) {
      WakelockPlus.enable();
    }
  }

  int index = 0;
  final List _pages = [
    const HomePage(title: "Home"),
    const TripsPage(title: "Trips"),
    const AboutPage(title: "About"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
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

  @override
  void dispose() {
    super.dispose();
  }
}
