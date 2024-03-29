import 'package:flutter/material.dart';
import 'package:trello_clone/features/board/bloc/board_bloc.dart';
import '../../model/list_model.dart';

class CardsBuilder extends StatelessWidget {
  const CardsBuilder({
    super.key,
    required this.listModel,
    required this.boardBloc,
  });

  final BoardBloc boardBloc;
  final ListModel listModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.48,
      width: MediaQuery.sizeOf(context).width * 0.75,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listModel.cards.length,
        itemBuilder: (context, cardIndex) {
          return GestureDetector(
            onTap: () {
              boardBloc.add(BoardNavigateToCardPageEvent(
                cardModel: listModel.cards[cardIndex],
                listModel: listModel,
              ));
            },
            child: LongPressDraggable(
              data: listModel.cards[cardIndex],
              childWhenDragging: Container(
                color: Colors.transparent,
              ),
              feedback: Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 6,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: listModel.cards[cardIndex].cardName,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 6,
                    ),
                    child: Text(
                      listModel.cards[cardIndex].cardName,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
