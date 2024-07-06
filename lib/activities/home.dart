import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:locating_fluttershy/services/database_service.dart';
import 'package:locating_fluttershy/services/weather_service.dart';

import '../main.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int speedAvg = 0;

  Timer? timer;
  Timer? timerUpdater;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 60*15), (Timer t) => weatherUpdate());
    timerUpdater = Timer.periodic(const Duration(seconds: 2), (Timer t) async {
      ls.isEnabled = await service.isRunning();
      _screenUpdate();
    });
    weatherUpdate();
  }


  void _screenUpdate() {
    setState(() {

    });
  }

  void weatherUpdate(){
    setState(() {
      ls.determinePosition().then((pos) {
        Weather.fetchWeather(pos.latitude, pos.longitude);
      });
    });
  }


  Future<void> addLocationDialog() async {
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          var nameController = TextEditingController();
          return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(clipBehavior: Clip.none,
                  child: Padding(padding: const EdgeInsets.all(10), child:
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        const Text("ADD LOCATION", style: TextStyle(fontSize: 20)),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                                controller: nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                      DatabaseHelper.newLocation(
                                          nameController.text,
                                          ls.prevLoc?.latitude,
                                          ls.prevLoc?.longitude,
                                          DateTime.now().millisecondsSinceEpoch);
                                      Navigator.pop(context);
                                    })),
                          ],
                        )
                      ]
                  )
                  )));});}


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
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    SizedBox(height: 100, width: 200,
                      child: Stack(clipBehavior: Clip.none, children: [
                        Positioned(top: 0, left: 0, bottom: 0,child:
                        SvgPicture.asset("assets/double_diagonal_arrow.svg", height: 80),
                        ),
                      ],),
                    ),
                    Expanded(
                      child: Column(children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            child:
                            StreamBuilder<Map<String, dynamic>?>(
                                stream: FlutterBackgroundService().on('update'),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final data = snapshot.data!;
                                  double trip = double.parse(data["current_trip_length"].toString());
                                  return Column(
                                    children: [
                                      Text(trip.toStringAsFixed(2),
                                          style: const TextStyle(
                                              fontSize: 64, height: 1)),
                                    ],
                                  );
                                })),
                        const Text('KM',
                          style:
                          TextStyle(fontSize: 18, height: 1), textAlign: TextAlign.center,),
                      ],),
                    )
                  ],
                  ),
                )),
            Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 4),
                clipBehavior: Clip.hardEdge,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 100, width: 200,
                        child: Stack(clipBehavior: Clip.none, children: [
                          Positioned(top: 0, left: 0, bottom: 0, child:
                          SvgPicture.asset("assets/speedometer.svg", height: 100,),
                          ),
                        ],),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('$speedAvg',
                                style: const TextStyle(
                                    fontSize: 64, height: 1)),
                            const Text('KM/H',
                              style:
                              TextStyle(fontSize: 18, height: 1), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                child: Column(
                    children: [
                    const SizedBox(height: 14),
                Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                        const Text('Moscow', style: TextStyle(fontSize: 14),),
                      Text('${WeatherData.temp ?? "--"}°C', style: const TextStyle(fontSize: 24),)]),
                ))),
        const Spacer(),
        Align(
          alignment: Alignment.topRight,
          child: IconButton.filled(
            icon: const Icon(Icons.add),
            onPressed: () {
              addLocationDialog();
            },
            style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(10))),
                foregroundColor: Colors.grey,
                backgroundColor: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(16)),
          ),
        ),
        const SizedBox(height: 24),
        TextButton.icon(
          style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
              backgroundColor: Theme.of(context).cardColor,
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 16, bottom: 16)),
          onPressed: () {
            setState(() {
              ls.isEnabled ? ls.disableListener() : initializeService();
            });
          },
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                ls.isEnabled ? "STOP" : "START",
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