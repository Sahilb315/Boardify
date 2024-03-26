import 'package:flutter/material.dart';

import '../../model/list_model.dart';

class CardsBuilder extends StatelessWidget {
  const CardsBuilder({
    super.key,
    required this.item,
  });

  final ListModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.48,
      width: MediaQuery.sizeOf(context).width * 0.75,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: item.cards.length,
        itemBuilder: (context, cardIndex) {
          return Draggable(
            data: item.cards[cardIndex],
            childWhenDragging: Container(
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
                  item.cards[cardIndex].cardName,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
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
                    text: item.cards[cardIndex].cardName,
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
                    item.cards[cardIndex].cardName,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 15,
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
