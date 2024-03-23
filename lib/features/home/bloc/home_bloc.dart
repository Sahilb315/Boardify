// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeNavigateToBoardPageEvent>(homeNavigateToBoardPageEvent);
  }

  FutureOr<void> homeNavigateToBoardPageEvent(
      HomeNavigateToBoardPageEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigateToBoardPageActionState());
  }
}
