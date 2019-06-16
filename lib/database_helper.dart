import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database() async {
  return openDatabase(
    join(await getDatabasesPath(), "doggie_database.db"),
    onCreate: (db, version) {
      db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
    },
    version: 1,
  );
}

Future<void> insertDog(Dog dog) async {
  final db = await database();
  await db.insert('dogs', dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Dog>> getDogs() async {
  final db = await database();
  final List<Map<String, dynamic>> dogs = await db.query("dogs");
  return List.generate(dogs.length, (i) {
    return Dog(id: dogs[i]['id'], name: dogs[i]['name'], age: dogs[i]['age']);
  });
}

class Dog {
  final int id;
  final String name;
  final int age;
  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  @override
  String toString() {
    return "Dog{id: $id,name: $name,age: $age}";
  }
}
