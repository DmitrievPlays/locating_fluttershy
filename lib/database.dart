import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? database;

  static newRoute() async {
    final db = database;
    var res = await db!.rawInsert("INSERT Into Routes (distance,date)"
        " VALUES ('2', '3');");
    return res;
  }

    static newLocation(name, lat, lon, date) async {
    final db = database;
    var res = await db!.rawInsert("INSERT Into Locations (name,lat,lon,date)"
        " VALUES ('$name', $lat, $lon, $date);");
    return res;
  }

  static Future<Database> initDB() async {
    String documentsDirectory = "/storage/emulated/0/Documents";
    String path = '$documentsDirectory/TestDB.db';

    return await openDatabase(path, version: 1, onOpen: (db) {
      database = db;
    }, onCreate: (Database db, int version) {
      database = db;
      db.execute("CREATE TABLE Locations ("
          "name TEXT,"
          "lat REAL,"
          "lon REAL,"
          "date INTEGER"
          ")");

      db.execute("CREATE TABLE Routes ("
          "distance REAL,"
          "date INTEGER"
          ")");
    });
  }
}
