// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trello_clone/features/board/model/board_model.dart';
import 'package:trello_clone/features/home/repo/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeNavigateToBoardPageEvent>(homeNavigateToBoardPageEvent);
    on<HomeNewBoardSheetEvent>(homeNewBoardSheetEvent);
    on<HomeAddNewBoardEvent>(homeAddNewBoardEvent);
    on<HomeFetchEvent>(homeFetchEvent);
  }

  final homeRepo = HomeRepo();

  FutureOr<void> homeFetchEvent(
      HomeFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    final boards = await homeRepo.getAllBoards();
    emit(HomeFetchBoardsState(boards: boards));
  }

  FutureOr<void> homeNavigateToBoardPageEvent(
      HomeNavigateToBoardPageEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToBoardPageActionState());
  }

  FutureOr<void> homeNewBoardSheetEvent(
      HomeNewBoardSheetEvent event, Emitter<HomeState> emit) {
    emit(HomeNewBoardBottomSheetActionState());
  }

  FutureOr<void> homeAddNewBoardEvent(
      HomeAddNewBoardEvent event, Emitter<HomeState> emit) async {
    await homeRepo.addBoard(event.boardModel);
    emit(HomeAddNewBoardActionState());
    final boards = await homeRepo.getAllBoards();
    emit(HomeFetchBoardsState(boards: boards));
  }
}
