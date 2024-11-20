import 'package:database_sqflite_2/database/function/database_function.dart';
import 'package:database_sqflite_2/database/model/person_model.dart';
import 'package:flutter/material.dart';

class ListPersonWidget extends StatelessWidget {
  final void Function(Person p, int index) updateCallback;
  final void Function(int index) deleteCallback;
  const ListPersonWidget({
    super.key,
    required this.updateCallback,
    required this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: personListNotifier,
        builder: (context, List<Person> personlist, child) {
          return Expanded(
              child: ListView.separated(
            itemBuilder: (context, index) {
              final person = personlist[index];
              return Card(
                child: ListTile(
                  title: Text("Name:- ${person.name}"),
                  subtitle: Text("Age:- ${person.age}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // take data to update
                          updateCallback(person, index);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          // delete data
                          deleteCallback(person.id!);
                        },
                        color: Colors.red,
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: personlist.length,
          ));
        });
  }
}
