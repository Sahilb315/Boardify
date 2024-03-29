// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'board_bloc.dart';

@immutable
sealed class BoardState {}

abstract class BoardActionState extends BoardState {}

final class BoardInitial extends BoardState {}

class BoardLoadingState extends BoardState {}

class BoardLoadedState extends BoardState {
  final List<ListModel> lists;
  bool showListAppBar;

  BoardLoadedState({
    required this.lists,
    required this.showListAppBar,
  });
}

class BoardPopMenuEditListNameActionState extends BoardActionState {
  final BuildContext context;
  final ListModel listModel;

  BoardPopMenuEditListNameActionState({
    required this.context,
    required this.listModel,
  });
}

class BoardAddNewCardSheetActionState extends BoardActionState {
  final ListModel listModel;
  final TextEditingController cardNameController;
  final TextEditingController cardDescriptionController;

  BoardAddNewCardSheetActionState({
    required this.listModel,
    required this.cardNameController,
    required this.cardDescriptionController,
  });
}

class BoardDeleteListActionState extends BoardActionState {
  final String listID;

  BoardDeleteListActionState({required this.listID});
}

class BoardNavigateToCardPageActionState extends BoardActionState {
  final CardModel cardModel;
  final ListModel listModel;
  BoardNavigateToCardPageActionState({
    required this.listModel,
    required this.cardModel,
  });
}
