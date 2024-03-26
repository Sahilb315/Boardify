import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/constants/firebase_names.dart';
import 'package:trello_clone/features/board/model/board_model.dart';

class HomeRepo {
  Future<List<BoardModel>> getAllBoards() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapshot = await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(user!.email)
          .collection(BOARD_COLLECTION)
          .get();
      final docs = snapshot.docs
          .map((board) => BoardModel.fromMap(board.data()))
          .toList();
      return docs;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addBoard(BoardModel model) async {
    try {
      final firestore = FirebaseFirestore.instance.collection(USERS_COLLECTION);
      final user = FirebaseAuth.instance.currentUser!.email;
      await firestore
          .doc(user)
          .collection(BOARD_COLLECTION)
          .add(model.toMap())
          .then((value) async {
        await firestore
            .doc(user)
            .collection(BOARD_COLLECTION)
            .doc(value.id)
            .update({
          'docID': value.id,
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
