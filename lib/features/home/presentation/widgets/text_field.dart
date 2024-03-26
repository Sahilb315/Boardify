import 'package:flutter/material.dart';
import 'package:trello_clone/utils/text_field_decoration.dart';


class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.addNewfocusNode,
    required this.addNewListNameController,
    required this.name,
  });

  final FocusNode addNewfocusNode;
  final TextEditingController addNewListNameController;
  final String name;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      focusNode: addNewfocusNode,
      controller: addNewListNameController,
      cursorColor: Colors.blue,
      style: const TextStyle(color: Colors.white),
      decoration: customTextFieldDecoration(name),
    );
  }
}


