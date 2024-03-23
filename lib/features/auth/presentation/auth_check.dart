
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/features/auth/presentation/auth_page.dart';
import 'package:trello_clone/features/home/presentation/pages/home_page.dart';

class UserLoggedInOrNot extends StatelessWidget {
  const UserLoggedInOrNot({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
