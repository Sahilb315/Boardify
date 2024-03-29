part of 'card_bloc.dart';

@immutable
sealed class CardEvent {}

class CardFetchEvent extends CardEvent {
  final ListModel listModel;
  final CardModel cardModel;
  final String docID;

  CardFetchEvent({required this.listModel, required this.cardModel, required this.docID});
}
