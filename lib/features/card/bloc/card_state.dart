part of 'card_bloc.dart';

@immutable
sealed class CardState {}

final class CardInitial extends CardState {}

class CardLoadingState extends CardState {}
class CardLoadedState extends CardState {
  final CardModel cardModel;

  CardLoadedState({required this.cardModel});
}