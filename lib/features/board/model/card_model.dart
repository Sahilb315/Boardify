// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CardModel {
  final String cardID;
  final String cardName;
  final String cardDescription;
  String currentList;
  CardModel({
    required this.cardID,
    required this.cardName,
    required this.cardDescription,
    required this.currentList,
  });

  CardModel copyWith({
    String? cardID,
    String? cardName,
    String? cardDescription,
    String? currentList,
  }) {
    return CardModel(
      cardID: cardID ?? this.cardID,
      cardName: cardName ?? this.cardName,
      cardDescription: cardDescription ?? this.cardDescription,
      currentList: currentList ?? this.currentList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cardID': cardID,
      'cardName': cardName,
      'cardDescription': cardDescription,
      'currentList': currentList,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      cardID: map['cardID'] as String,
      cardName: map['cardName'] as String,
      cardDescription: map['cardDescription'] as String,
      currentList: map['currentList'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) => CardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CardModel(cardID: $cardID, cardName: $cardName, cardDescription: $cardDescription, currentList: $currentList)';
  }

  @override
  bool operator ==(covariant CardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cardID == cardID &&
      other.cardName == cardName &&
      other.cardDescription == cardDescription &&
      other.currentList == currentList;
  }

  @override
  int get hashCode {
    return cardID.hashCode ^
      cardName.hashCode ^
      cardDescription.hashCode ^
      currentList.hashCode;
  }
}
