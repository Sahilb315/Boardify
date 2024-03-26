// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'board_bloc.dart';

@immutable
sealed class BoardState {}

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
