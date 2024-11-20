import 'package:database_sqflite_2/database/function/database_function.dart';
import 'package:database_sqflite_2/database/model/person_model.dart';
import 'package:database_sqflite_2/screens/home/screen_home.dart';
import 'package:flutter/material.dart';


class AddPersonWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final FocusNode nameFocusNode;
  final FocusNode ageFocusNode;
  const AddPersonWidget({
    Key? key,
    required this.nameController,
    required this.ageController,
    required this.nameFocusNode,
    required this.ageFocusNode,
  }) : super(key: key);

  @override
  State<AddPersonWidget> createState() => _AddPersonWidgetState();
}

class _AddPersonWidgetState extends State<AddPersonWidget> {
  
  void _unFocusAllFocusNode() {
    widget.nameFocusNode.unfocus();
    widget.ageFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.nameController,
          focusNode: widget.nameFocusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Name"),
            hintText: "Enter name",
            hintStyle: TextStyle(color: Colors.black38),
          ),
        ),

        const SizedBox(
          height: 8,
        ),
        // age textfield
        TextField(
          controller: widget.ageController,
          focusNode: widget.ageFocusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text("Age"),
            hintText: "Enter age",
            hintStyle: TextStyle(color: Colors.black38),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(
          height: 8,
        ),

        // save or update button
        ElevatedButton(
          onPressed: () {
            if (saveButtonMode == SaveButtonMode.save) {
              // To save
              final person = Person(
                  name: widget.nameController.text.trim(),age: int.tryParse(widget.ageController.text.trim()) ?? 0,);
              insertPerson(person);
              widget.nameController.clear();
              widget.ageController.clear();
              _unFocusAllFocusNode();
            } else {
              // To update
              final person = Person(name:widget.nameController.text.trim(),
                 age: int.tryParse(widget.ageController.text.trim()) ?? 0);
          
              updatePerson(person, indexToUpdate!);
              widget.nameController.clear();
              widget.ageController.clear();
              saveButtonMode = SaveButtonMode.save;
              indexToUpdate = null;
              _unFocusAllFocusNode();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: saveButtonMode == SaveButtonMode.save
                ? Colors.green
                : Colors.blue,
            foregroundColor: Colors.white,
          ),
          child:
              Text(saveButtonMode == SaveButtonMode.save ? "Save" : "Update"),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}


