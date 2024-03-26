import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/constants/firebase_names.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';

class BoardRepo {
  Future<void> addList(ListModel model, String docID) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(user.email)
          .collection(BOARD_COLLECTION)
          .doc(docID)
          .update({
        "listsInBoard": FieldValue.arrayUnion([model.toMap()])
      });
    } catch (e) {
      log("BoardRepo AddList Error: $e");
    }
  }

  Future<List<ListModel>> getAllList(String docID) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID)
        .get();
    final doc = snapshot.data() as Map<String, dynamic>;
    List list = doc["listsInBoard"];
    List<ListModel> listModels =
        list.map((item) => ListModel.fromMap(item)).toList();
    return listModels;
  }

  Future<void> addCardInList({
    required String docID,
    required ListModel model,
    required CardModel cardModel,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);

    final snapshot = await firestore.get();
    Map<String, dynamic> boardData = snapshot.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    Map<String, dynamic>? listToUpdate;

    /// Getting the Card Model where i want to add the card
    for (dynamic listData in listsInBoard) {
      if (listData['id'] == model.id) {
        listToUpdate = listData;
        break;
      }
    }

    if (listToUpdate != null) {
      /// Update the cards array of the specified list
      listToUpdate['cards'].add(cardModel.toMap());
      await firestore.update({
        'listsInBoard': listsInBoard,
      });
    }
  }

  Future<void> addMovedCardFromList({
    required String docID,
    required ListModel listModel,
    required CardModel cardModel,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);

    final snapshot = await firestore.get();
    Map<String, dynamic> boardData = snapshot.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    Map<String, dynamic>? listToUpdate;

    /// Getting the Card Model where i want to add the card
    for (dynamic listData in listsInBoard) {
      if (listData['id'] == listModel.id) {
        listToUpdate = listData;
        break;
      }
    }

    if (listToUpdate != null) {
      /// It checks if the same card already exists in the list and if true just return
      for (var item in listToUpdate['cards']) {
        if (item['cardName'] == cardModel.cardName) {
          return;
        }
      }

      listToUpdate['cards'].add(
        CardModel(
          cardName: cardModel.cardName,
          cardDescription: cardModel.cardDescription,
          currentList: listModel.listName,
        ).toMap(),
      );
      await firestore.update({
        'listsInBoard': listsInBoard,
      });
    }
  }

  Future<void> removeCardFromList({
    required String docID,
    required ListModel listModel,
    required CardModel cardModel,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);

    final snapshot = await firestore.get();
    Map<String, dynamic> boardData = snapshot.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    Map<String, dynamic>? listToUpdate; // It will store a single list

    /// Getting the Card Model where i want to add the card
    for (dynamic listData in listsInBoard) {
      if (listData['listName'] == cardModel.currentList) {
        listToUpdate = listData;
        break;
      }
    }
    if (listToUpdate != null) {
      List cards = listToUpdate['cards'];
      for (var item in List.from(cards)) {
        if (item['cardName'] == cardModel.cardName) {
          listToUpdate['cards'].remove(item);
        }
      }
    }

    for (dynamic listData in listsInBoard) {
      if (listData['listName'] == cardModel.currentList) {
        listData = listToUpdate;
        break;
      }
    }
    await firestore.update({
      'listsInBoard': listsInBoard,
    });
  }

  Future<void> updateListName({
    required String docID,
    required ListModel listModel,
    required String listName,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);

    final snapshot = await firestore.get();
    Map<String, dynamic> boardData = snapshot.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    Map<String, dynamic>? listToUpdate;

    /// Getting the Card Model where i want to add the card
    for (dynamic listData in listsInBoard) {
      if (listData['id'] == listModel.id) {
        listToUpdate = listData;
        break;
      }
    }

    if (listToUpdate != null) {
      /// Update the cards array of the specified list
      listToUpdate['listName'] = listName;
      firestore.update({
        'listsInBoard': listsInBoard,
      });
    }
  }
}
