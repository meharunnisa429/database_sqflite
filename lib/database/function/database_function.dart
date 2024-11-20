import 'dart:developer';

import 'package:database_sqflite_2/database/model/person_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Declare database variable as private, static, and late
late Database _db;
/// Init database
ValueNotifier<List<Person>> personListNotifier = ValueNotifier([]);
Future<void> initDatabase() async {
  // Get path of the database
  final String path = join(await getDatabasesPath(), "person_database.db");
  // Assign value to _db
  _db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      // create person table
      await db.execute(
        '''
          CREATE TABLE person(
            id INTEGER  PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER
          )''',
      );
    },
  );
  getAllPersons();
}

Future<void> insertPerson(Person person) async {
  _db.insert("person", person.toJson());
  log(person.toJson().toString(), name: "Person to add");
  personListNotifier.value.add(person);
  getAllPersons();
}

Future<void> getAllPersons() async {
  personListNotifier.value.clear();

  final List<Map<String, dynamic>> list = await _db.query("person");
  list.map((element) => Person.fromMap(element)).toList();
  list.forEach((map) {
    final person = Person.fromMap(map);
    personListNotifier.value.add(person);
  });
  log(personListNotifier.value.toString(), name: "personListNotifier");
  personListNotifier.notifyListeners();
}

Future updatePerson(Person person, int? index) async {
  await _db.update("person", (person.toJson()),
      where: "id=?", whereArgs: [person.id]);
  personListNotifier.value[index!] = person;
  getAllPersons();
}

Future deletePerson(int id) async {
  await _db.delete("person", where: "id=?", whereArgs: [id]);
  personListNotifier.value.remove(id);
getAllPersons();
}

/// To close database
void closeDatabase() {
  _db.close();
}
