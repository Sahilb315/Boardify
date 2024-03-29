import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/card/repo/card_repo.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardInitial()) {
    on<CardFetchEvent>(cardFetchEvent);
  }
  final cardRepo = CardRepo();
  FutureOr<void> cardFetchEvent(
      CardFetchEvent event, Emitter<CardState> emit) async {
    emit(CardLoadingState());
    final card = await CardRepo.fetchCard(
      listModel: event.listModel,
      cardModel: event.cardModel,
      docID: event.docID,
    );
    emit(CardLoadedState(cardModel: card!));
  }
}
