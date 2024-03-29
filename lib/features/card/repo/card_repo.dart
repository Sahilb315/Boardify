// ignore_for_file: unused_import

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/constants/firebase_names.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';

class CardRepo {
  static Future<CardModel?> fetchCard({
    required ListModel listModel,
    required CardModel cardModel,
    required String docID,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);
    final snap = await firestore.get();
    final boardData = snap.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    List cardsInList = [];
    CardModel? model;
    for (dynamic listData in listsInBoard) {
      if (listData['id'] == listModel.id) {
        cardsInList = listData['cards'];
        break;
      }
    }
    for (var item in cardsInList) {
      if (item['cardID'] == cardModel.cardID) {
        model = CardModel.fromMap(item);
      }
    }
    return model;
  }

  static Future<void> updateCardName({
    required ListModel listModel,
    required CardModel cardModel,
    required String docID,
    required String newCardName,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);
    final snap = await firestore.get();
    final boardData = snap.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    List cardsInList = [];
    Map<String, dynamic>? cardToUpdate;

    for (dynamic listData in listsInBoard) {
      if (listData['id'] == listModel.id) {
        cardsInList = listData['cards'];
        break;
      }
    }
    for (var item in cardsInList) {
      if (item['cardID'] == cardModel.cardID) {
        cardToUpdate = item;
        break;
      }
    }
    if (cardToUpdate != null) {
      cardToUpdate['cardName'] = newCardName;
    }

    await firestore.update({'listsInBoard': listsInBoard});
  }

  static Future<void> updateCardDescription({
    required ListModel listModel,
    required CardModel cardModel,
    required String docID,
    required String cardDescription,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user.email)
        .collection(BOARD_COLLECTION)
        .doc(docID);
    final snap = await firestore.get();
    final boardData = snap.data() as Map<String, dynamic>;
    List<dynamic> listsInBoard = boardData['listsInBoard'];
    List cardsInList = [];
    Map<String, dynamic>? cardToUpdate;

    for (dynamic listData in listsInBoard) {
      if (listData['id'] == listModel.id) {
        cardsInList = listData['cards'];
        break;
      }
    }
    for (var item in cardsInList) {
      if (item['cardID'] == cardModel.cardID) {
        cardToUpdate = item;
        break;
      }
    }
    if (cardToUpdate != null) {
      cardToUpdate['cardDescription'] = cardDescription;
    }

    await firestore.update({'listsInBoard': listsInBoard});
  }
}
