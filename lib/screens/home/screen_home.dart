import 'dart:developer';

import 'package:database_sqflite_2/database/model/person_model.dart';
import 'package:database_sqflite_2/database/function/database_function.dart';
import 'package:database_sqflite_2/screens/home/widgets/add_person_widget.dart';
import 'package:database_sqflite_2/screens/home/widgets/list_person_widget.dart';
import 'package:flutter/material.dart';

SaveButtonMode saveButtonMode = SaveButtonMode.save;
int? indexToUpdate;

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key, required this.title});
  final String title;
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  Person? _personToUpdate;
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _ageFocusNode;
  @override
  void initState() {
    // TODO: implement initState
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _nameFocusNode = FocusNode();
    _ageFocusNode = FocusNode();
    super.initState();
  }

  void _bringPersonToUpdata(Person person, int index) {
    _personToUpdate = person;
    indexToUpdate = index;
    log(_personToUpdate!.toJson().toString(), name: "person to update");
    _nameController.text = person.name;
    _ageController.text = person.age.toString();
    saveButtonMode = SaveButtonMode.edit;
  }

  void _deletePerson(int id) async {
    await deletePerson(id);

    _ageController.clear();
    _nameController.clear();
    saveButtonMode = SaveButtonMode.save;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    // Close database to free up resources
    closeDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Sqflite"),
      ),
      // body
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AddPersonWidget(
                nameController: _nameController,
                ageController: _ageController,
                nameFocusNode: _nameFocusNode,
                ageFocusNode: _ageFocusNode,
              ),
              ListPersonWidget(
                updateCallback: (Person person, int index) {
                  _bringPersonToUpdata(person, index);
                },
                deleteCallback: (int id) {
                  _deletePerson(id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum SaveButtonMode { save, edit }
