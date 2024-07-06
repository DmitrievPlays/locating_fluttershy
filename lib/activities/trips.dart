import 'package:flutter/material.dart';

import 'package:locating_fluttershy/services/database_service.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key, required this.title});

  final String title;

  @override
  State<TripsPage> createState() => _TripsPageState();
}

List<Map<String, Object?>>? items;


class _TripsPageState extends State<TripsPage> {
  List<Route> routes = [];

  @override
  void initState() {
    super.initState();

    getAndShowRoutes();
  }

  void getAndShowRoutes() async {
    items = await DatabaseHelper.getRoutes();
    items?.forEach((action) {
      routes.add(Route(action["distance"].toString(), action["date"].toString()));
    });
    setState((){});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
          itemCount: routes.length,
          itemBuilder: (context, index) {
            return Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                title: Text('${routes[index].date}, ${routes[index].distance}'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.all(10),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(color: Colors.transparent, height: 14,);
            },),
    );
  }
}

class Route{
  final String distance;
  final String date;

  Route(this.distance, this.date);
}