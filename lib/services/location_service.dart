import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:locating_fluttershy/main.dart';
import 'package:locating_fluttershy/services/database_service.dart';
import 'package:intl/intl.dart';


class LocationService {
  LocationSettings? locationSettings;
  Position? prevLoc;
  double tripLength = 0.0;
  StreamSubscription? sub;
  bool isEnabled = false;

  Stream<Position> initializeLocationUpdater() {
    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 5),
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }


  Future<bool>isServiceEnabled() async {
    return Future.value(isEnabled);
  }

  Future<void> enableListener() async{
    isEnabled = true;
    sub = initializeLocationUpdater().listen((pos) {
      if (prevLoc != null) {
        ls.tripLength += (Geolocator.distanceBetween(prevLoc!.latitude,
            prevLoc!.longitude, pos.latitude, pos.longitude) / 1000);
      }
      prevLoc = pos;
    });
    return sub?.resume();
  }

  Future<void> disableListener() async{
    isEnabled = false;
    service.invoke("stopService");
    DatabaseHelper.newRoute(ls.tripLength, DateFormat("yyyy-MM-dd").format(DateTime.now()));
    return sub?.cancel();
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


