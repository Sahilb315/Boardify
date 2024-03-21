import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trello_clone/features/auth/bloc/auth_bloc.dart';
import 'package:trello_clone/features/auth/presentation/auth_check.dart';
import 'package:trello_clone/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(
        builder: (context) {
          return const MaterialApp(
            home: UserLoggedInOrNot(),
            debugShowCheckedModeBanner: false,
          );
        }
      ),
    );
  }
}
