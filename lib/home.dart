import 'dart:async';

import 'package:flutter/material.dart';
import 'package:locating_fluttershy/data.dart';
import 'package:locating_fluttershy/database.dart';
import 'package:locating_fluttershy/weatherService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _travelled = 0;
  final int _speed_avg = 0;
  var weather;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10*60), (Timer t) => weatherUpdate());
  }

  void _tripAction() {
    setState(() {
      _travelled++;
    });
  }

  void weatherUpdate(){
    setState(() {

      print('Weather update');
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
                                    fillColor:
                                    const Color.fromARGB(255, 220, 220, 220),
                                    labelStyle: const TextStyle(
                                        backgroundColor: Colors.amber)))),
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
                                          Data.loc!.latitude,
                                          Data.loc!.longitude,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            style:
                            TextStyle(fontSize: 30, color: Colors.white)),
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
                            style:
                            TextStyle(fontSize: 30, color: Colors.white)),
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
                children: [
                  const SizedBox(height: 14),
                  FutureBuilder(future: Weather.fetchWeather(), builder: (context, snapshot){
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(padding: const EdgeInsets.all(12), decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), color: const Color(0xFF78909C)),
                        child: Column(children: [
                          const Text('Moscow', style: TextStyle(fontSize: 14, color: Colors.white),),
                          Text('${snapshot.data?.temp}°C', style: const TextStyle(fontSize: 24, color: Colors.white),)])));
                  }),
                  const Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Expanded(
                        child: IconButton.filled(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            DatabaseHelper.newRoute();
                            addLocationDialog();
                          },
                          style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blueGrey[400],
                              padding: const EdgeInsets.all(16)),
                        )),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey[400],
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 16, bottom: 16)),
                      onPressed: () {

                      },
                      label: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'START',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
          ),
        ]),
      ),
    );
  }
}