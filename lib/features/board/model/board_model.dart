// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:trello_clone/features/board/model/list_model.dart';

class BoardModel {
  final String boardName;
  final List<ListModel> listsInBoard;
  BoardModel({
    required this.boardName,
    required this.listsInBoard,
  });

  BoardModel copyWith({
    String? boardName,
    List<ListModel>? listsInBoard,
  }) {
    return BoardModel(
      boardName: boardName ?? this.boardName,
      listsInBoard: listsInBoard ?? this.listsInBoard,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'boardName': boardName,
      'listsInBoard': listsInBoard.map((x) => x.toMap()).toList(),
    };
  }

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(
      boardName: map['boardName'] as String,
      listsInBoard: List<ListModel>.from((map['listsInBoard'] as List).map<ListModel>((x) => ListModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory BoardModel.fromJson(String source) => BoardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BoardModel(boardName: $boardName, listsInBoard: $listsInBoard)';

  @override
  bool operator ==(covariant BoardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.boardName == boardName &&
      listEquals(other.listsInBoard, listsInBoard);
  }

  @override
  int get hashCode => boardName.hashCode ^ listsInBoard.hashCode;
}
