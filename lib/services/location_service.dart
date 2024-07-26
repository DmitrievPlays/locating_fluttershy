import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locating_fluttershy/main.dart';
import 'package:intl/intl.dart';

class LocationService {
  static LocationService? _instance;

  LocationService._();

  factory LocationService() => _instance ??= LocationService._();

  LocationSettings? locationSettings;
  Position? prevLoc;
  double speed = 0;
  double tripLength = 0.0;
  StreamSubscription? distanceUpdater;
  bool isEnabled = false;


  Stream<Position> initializeLocationUpdater() {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 1),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<bool> isServiceEnabled() async {
    return Future.value(isEnabled);
  }

  Future<void> enableListener() async {
    print("listener enabled");
    isEnabled = true;
    distanceUpdater = initializeLocationUpdater().listen((pos) {
      if (prevLoc != null) {
        if (Geolocator.distanceBetween(prevLoc!.latitude, prevLoc!.longitude,
            pos.latitude, pos.longitude) >
            20) {
          tripLength += (Geolocator.distanceBetween(prevLoc!.latitude,
              prevLoc!.longitude, pos.latitude, pos.longitude) /
              1000);
          prevLoc = pos;
        }
      }
      prevLoc ??= pos;
      speed = pos.speed * 3.6;
      return distanceUpdater?.resume();
    });

    Timer.periodic(const Duration(milliseconds: 1000), (Timer t) async {
      if (kDebugMode) {
        print("SPEED $speed");
      }
    });
  }


  Future<void> disableListener() async {
    isEnabled = false;
    helper.newRoute(
        tripLength, DateFormat("yyyy-MM-dd").format(DateTime.now()));

    service.invoke("stopService");
    return distanceUpdater?.cancel();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}