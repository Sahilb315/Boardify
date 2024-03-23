
import 'package:flutter/material.dart';

InputDecoration customTextFieldDecoration(String name) {
  return InputDecoration(
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    hintText: name,
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontFamily: "Poppins",
    ),
  );
}