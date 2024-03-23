// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CardModel {
  final String cardName;
  final String cardDescription;
  String currentList;
  CardModel({
    required this.cardName,
    required this.cardDescription,
    required this.currentList,
  });

  CardModel copyWith({
    String? cardName,
    String? cardDescription,
    String? currentList,
  }) {
    return CardModel(
      cardName: cardName ?? this.cardName,
      cardDescription: cardDescription ?? this.cardDescription,
      currentList: currentList ?? this.currentList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cardName': cardName,
      'cardDescription': cardDescription,
      'currentList': currentList,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      cardName: map['cardName'] as String,
      cardDescription: map['cardDescription'] as String,
      currentList: map['currentList'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardModel.fromJson(String source) => CardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CardModel(cardName: $cardName, cardDescription: $cardDescription, currentList: $currentList)';

  @override
  bool operator ==(covariant CardModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cardName == cardName &&
      other.cardDescription == cardDescription &&
      other.currentList == currentList;
  }

  @override
  int get hashCode => cardName.hashCode ^ cardDescription.hashCode ^ currentList.hashCode;
}
