// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'board_bloc.dart';

@immutable
sealed class BoardEvent {}

class BoardFetchListEvent extends BoardEvent {
  final String docID;

  BoardFetchListEvent({required this.docID});
}

class BoardAddListEvent extends BoardEvent {
  final String docID;
  final ListModel listModel;

  BoardAddListEvent({required this.docID, required this.listModel});
}

class BoardOnTapAddListEvent extends BoardEvent {
  final String docID;
  bool isChanging;
  BoardOnTapAddListEvent({
    required this.docID,
    required this.isChanging,
  });
}

class BoardDragDataAcceptEvent extends BoardEvent {
  final String docID;
  final ListModel listModel;
  final CardModel cardModel;

  BoardDragDataAcceptEvent({
    required this.docID,
    required this.listModel,
    required this.cardModel,
  });
}

class BoardAddCardInListEvent extends BoardEvent {
  final CardModel cardModel;
  final ListModel listModel;
  final String docID;

  BoardAddCardInListEvent({
    required this.cardModel,
    required this.listModel,
    required this.docID,
  });
}

class BoardUpdateListNameEvent extends BoardEvent {
  final String docID;
  final String updatedName;
  final ListModel listModel;

  BoardUpdateListNameEvent({
    required this.docID,
    required this.updatedName,
    required this.listModel,
  });
}
