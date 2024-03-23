// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:trello_clone/features/board/model/card_model.dart';

class ListModel {
  final String id;
   String listName;
  final List<CardModel> cards;
  bool isEditing;
  ListModel({
    required this.id,
    required this.listName,
    required this.cards,
    required this.isEditing,
  });

  ListModel copyWith({
    String? id,
    String? listName,
    List<CardModel>? cards,
    bool? isEditing,
  }) {
    return ListModel(
      id: id ?? this.id,
      listName: listName ?? this.listName,
      cards: cards ?? this.cards,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'listName': listName,
      'cards': cards.map((x) => x.toMap()).toList(),
      'isEditing': isEditing,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'] as String,
      listName: map['listName'] as String,
      cards: List<CardModel>.from((map['cards'] as List).map<CardModel>((x) => CardModel.fromMap(x as Map<String,dynamic>),),),
      isEditing: map['isEditing'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ListModel.fromJson(String source) => ListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListModel(id: $id, listName: $listName, cards: $cards, isEditing: $isEditing)';
  }

  @override
  bool operator ==(covariant ListModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.listName == listName &&
      listEquals(other.cards, cards) &&
      other.isEditing == isEditing;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      listName.hashCode ^
      cards.hashCode ^
      isEditing.hashCode;
  }
}
