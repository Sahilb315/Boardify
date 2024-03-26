import 'package:flutter/material.dart';


class CustomBoardPage extends StatelessWidget {
  final Widget body;
  const CustomBoardPage({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        title: const Text(
          "Your Boards",
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
      body: body,
    );
  }
}
