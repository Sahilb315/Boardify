import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trello_clone/constants/firebase_names.dart';
import 'package:trello_clone/features/auth/bloc/auth_bloc.dart';

class AuthRepo {
  Future<AuthActionState> signInUserWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      createUserDocument(userCredential);
      return GoogleAuthSuccessfulActionState(userCredential: userCredential);
    } catch (e) {
      log("Google Sign in error: $e");
      return GoogleAuthFailureActionState(message: e.toString());
    }
  }

  Future<void> createUserDocument(UserCredential userCredential) async {
    await FirebaseFirestore.instance.collection(USERS_COLLECTION).add(
      {
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'profilePic': userCredential.user!.photoURL,
      },
    );
  }
}
