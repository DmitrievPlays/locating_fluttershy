import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:locating_fluttershy/services/weather_service.dart';
import '../main.dart';
import '../services/location_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int speedAvg = 0;

  Map<String, String> result = {};
  Timer? timer;
  Timer? timerUpdater;
  double speed = 0;
  double tripLength = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
        const Duration(seconds: 60 * 15), (Timer t) => weatherUpdate());
    timerUpdater =
        Timer.periodic(const Duration(milliseconds: 1000), (Timer t) async {
          screenUpdate();
        });
    weatherUpdate();
  }

  void screenUpdate() {
    setState(() {
      //speed = double.parse(getValueFromBack("current_speed"));
      //tripLength = double.parse(getValueFromBack("current_trip_length"));
    });
  }

  void weatherUpdate() {
    setState(() {
      // ls?.determinePosition().then((pos) {
      //   Weather.fetchWeather(pos.latitude, pos.longitude);
      // });
    });
  }

  Future<void> addLocationDialog() async {
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          var nameController = TextEditingController();
          return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  clipBehavior: Clip.none,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const Text("ADD LOCATION",
                                style: TextStyle(fontSize: 20)),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                    controller: nameController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none),
                                      filled: true,
                                    ))),
                            Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: const Text('CANCEL'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })),
                                Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: const Text('OK'),
                                        onPressed: () {
                                          helper.newLocation(
                                              nameController.text,
                                              null,null,
                                              //ls?.prevLoc?.latitude,
                                              //ls?.prevLoc?.longitude,
                                              DateTime.now()
                                                  .millisecondsSinceEpoch);
                                          Navigator.pop(context);
                                        })),
                              ],
                            )
                          ]))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(children: [
          Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 4),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: SvgPicture.asset(
                                "assets/double_diagonal_arrow.svg",
                                height: 80),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                children: [
                                  Text("${result["current_trip_length"]}",
                                      style: const TextStyle(
                                          fontSize: 64, height: 1)),
                                ],
                              ),),
                          const Text(
                            'KM',
                            style: TextStyle(fontSize: 18, height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 4),
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: SvgPicture.asset(
                              "assets/speedometer.svg",
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child:
                              Column(
                                children: [
                                  Text("${result["current_speed"]}",
                                               style: const TextStyle(
                                                   fontSize: 64, height: 1)),
                                ],
                              ),),
                          const Text(
                            'KM/H',
                            style: TextStyle(fontSize: 18, height: 1),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Column(children: [
              const SizedBox(height: 14),
              Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          const Text(
                            'Moscow',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${WeatherData.temp ?? "--"}°C',
                            style: const TextStyle(fontSize: 24),
                          )
                        ]),
                      ))),
              const Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final ls = Injector.appInstance.get<LocationService>();
                    print(ls.speed);
                    addLocationDialog();
                  },
                  style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      foregroundColor: Colors.grey,
                      backgroundColor: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(16)),
                ),
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: Theme.of(context).cardColor,
                    padding: const EdgeInsets.only(
                        left: 40, right: 40, top: 16, bottom: 16)),
                onPressed: () {
                  setState(() async {
                    await service.isRunning()
                        ? service.invoke("stopService")
                        : service.startService();
                  });
                },
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      //service ? "STOP" : "START",
                      "BTN",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timerUpdater?.cancel();
  }
}
