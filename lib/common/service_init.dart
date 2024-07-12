import 'package:injector/injector.dart';

import '../services/location_service.dart';

class ServiceInit {
  static void initialize(){
    final injector = Injector.appInstance;
    
    injector.registerSingleton<LocationService>(() => LocationService());
    print("service registered");
  }
}