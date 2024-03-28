// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/board/repo/board_repo.dart';

part 'board_event.dart';
part 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardInitial()) {
    on<BoardFetchListEvent>(boardFetchListEvent);
    on<BoardAddListEvent>(boardAddListEvent);
    on<BoardOnTapAddListEvent>(boardOnTapAddListEvent);
    on<BoardDragDataAcceptEvent>(boardDragDataAcceptEvent);
    on<BoardUpdateListNameEvent>(boardUpdateListNameEvent);
    on<BoardAddCardInListEvent>(boardAddCardInListEvent);
    on<BoardPopupMenuItemEditListNameEvent>(
        boardPopupMenuItemEditListNameEvent);
    on<BoardAddNewCardSheetEvent>(boardAddNewCardSheetEvent);
    on<BoardDeleteListEvent>(boardDeleteListEvent);
    on<BoardPopMenuDeleteListEvent>(boardPopMenuDeleteListEvent);
  }

  final boardRepo = BoardRepo();

  FutureOr<void> boardFetchListEvent(
      BoardFetchListEvent event, Emitter<BoardState> emit) async {
    emit(BoardLoadingState());
    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: false));
  }

  FutureOr<void> boardAddListEvent(
      BoardAddListEvent event, Emitter<BoardState> emit) async {
    await boardRepo.addList(
      event.listModel,
      event.docID,
    );
    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: false));
  }

  FutureOr<void> boardOnTapAddListEvent(
    BoardOnTapAddListEvent event,
    Emitter<BoardState> emit,
  ) async {
    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: event.isChanging));
  }

  FutureOr<void> boardDragDataAcceptEvent(
      BoardDragDataAcceptEvent event, Emitter<BoardState> emit) async {
    await boardRepo.removeCardFromList(
      docID: event.docID,
      listModel: event.listModel,
      cardModel: event.cardModel,
    );

    await boardRepo.addMovedCardFromList(
      docID: event.docID,
      listModel: event.listModel,
      cardModel: event.cardModel,
    );
    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: false));
  }

  FutureOr<void> boardUpdateListNameEvent(
      BoardUpdateListNameEvent event, Emitter<BoardState> emit) async {
    await boardRepo.updateListName(
      docID: event.docID,
      listModel: event.listModel,
      listName: event.updatedName,
    );

    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: false));
  }

  FutureOr<void> boardAddCardInListEvent(
      BoardAddCardInListEvent event, Emitter<BoardState> emit) async {
    await boardRepo.addCardInList(
      docID: event.docID,
      model: event.listModel,
      cardModel: event.cardModel,
    );
    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: false));
  }

  FutureOr<void> boardPopupMenuItemEditListNameEvent(
      BoardPopupMenuItemEditListNameEvent event, Emitter<BoardState> emit) {
    emit(
      BoardPopMenuEditListNameActionState(
        context: event.context,
        listModel: event.listModel,
      ),
    );
  }

  FutureOr<void> boardAddNewCardSheetEvent(
      BoardAddNewCardSheetEvent event, Emitter<BoardState> emit) {
    emit(
      BoardAddNewCardSheetActionState(
        listModel: event.listModel,
        cardNameController: event.cardNameController,
        cardDescriptionController: event.cardDescriptionController,
      ),
    );
  }

  FutureOr<void> boardDeleteListEvent(
      BoardDeleteListEvent event, Emitter<BoardState> emit) async {
    await boardRepo.deleteList(docID: event.docID, listID: event.listID);
    final list = await boardRepo.getAllList(event.docID);
    emit(BoardLoadedState(lists: list, showListAppBar: false));
  }

  FutureOr<void> boardPopMenuDeleteListEvent(
      BoardPopMenuDeleteListEvent event, Emitter<BoardState> emit) {
    emit(BoardDeleteListActionState(listID: event.listID));
  }
}
