part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeNavigateToBoardPageEvent extends HomeEvent {
  final String docID;
  final String boardName;

  HomeNavigateToBoardPageEvent({required this.boardName, required this.docID});
}

class HomeFetchEvent extends HomeEvent {}

class HomeAddNewBoardEvent extends HomeEvent {
  final BoardModel boardModel;
  HomeAddNewBoardEvent({required this.boardModel});
}

class HomeNewBoardSheetEvent extends HomeEvent {}
