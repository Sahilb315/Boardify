part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeFetchBoardsState extends HomeState {
  final List<BoardModel> boards;

  HomeFetchBoardsState({required this.boards});
}

class HomeNavigateToBoardPageActionState extends HomeActionState {
  final String docID;

  HomeNavigateToBoardPageActionState({required this.docID});
}

class HomeNewBoardBottomSheetActionState extends HomeActionState {}

class HomeAddNewBoardActionState extends HomeActionState {}
