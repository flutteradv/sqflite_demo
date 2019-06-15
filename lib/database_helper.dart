import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openDogDb() async {
  return openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
    },
    version: 1,
  );
}
