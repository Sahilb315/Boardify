part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeActionState {}

class HomeFetchBoardsState extends HomeState {
  final List<BoardModel> boards;

  HomeFetchBoardsState({required this.boards});
}

class HomeNavigateToBoardPageActionState extends HomeActionState {}

class HomeNewBoardBottomSheetActionState extends HomeActionState {}

class HomeAddNewBoardActionState extends HomeActionState {}
