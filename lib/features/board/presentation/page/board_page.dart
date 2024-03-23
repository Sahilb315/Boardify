
import 'package:flutter/material.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/home/presentation/ui/text_field.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  late bool addListField;

  /// Its use is only of showing appBar when we try to change the name of the card
  late bool changeCardName;

  @override
  void initState() {
    changeCardName = false;
    addListField = false;
    super.initState();
  }

  final TextEditingController listNameController = TextEditingController();
  final TextEditingController addNewListNameController =
      TextEditingController();

  final TextEditingController addNewCardNameController =
      TextEditingController();
  final TextEditingController addNewCardDescriptionController =
      TextEditingController();

  final focusNode = FocusNode();
  final addNewfocusNode = FocusNode();

  List<ListModel> boardItems = [
    ListModel(
      id: "1",
      isEditing: false,
      listName: "Example",
      cards: [
        CardModel(
          cardName: "CGC Landran",
          cardDescription: "It is a Clg",
          currentList: "Example",
        ),
        CardModel(
          cardName: "CU",
          cardDescription: "na",
          currentList: "Example",
        ),
      ],
    ),
    ListModel(
      id: "2",
      isEditing: false,
      listName: "Another",
      cards: [
        CardModel(
          cardName: "Amity",
          cardDescription: "cardDescription",
          currentList: "Another",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: addListField || changeCardName
          ? AppBar(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    if (addListField) {
                      boardItems.add(
                        ListModel(
                          id: '3',
                          listName: addNewListNameController.text,
                          cards: [],
                          isEditing: false,
                        ),
                      );
                      addListField = false;
                      setState(() {});
                    }
                    if (listNameController.text.isNotEmpty) {
                      for (var item in boardItems) {
                        if (item.isEditing) {
                          setState(() {
                            item.listName = listNameController.text;
                            item.isEditing = false;
                            changeCardName = false;
                          });
                        }
                      }
                    }
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  focusNode.unfocus();
                  addNewfocusNode.unfocus();
                  addNewListNameController.clear();
                  listNameController.clear();

                  setState(() {
                    for (var element in boardItems) {
                      element.isEditing = false;
                    }
                    addListField = false;
                    changeCardName = false;
                  });
                },
                icon: const Icon(
                  Icons.cancel_sharp,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: addListField
                  ? const Text(
                      "Add list",
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    )
                  : const Text(
                      "Update name",
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
            )
          : AppBar(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              title: const Text(
                "Your Boards",
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.62,

                //* List Builder
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemExtent: MediaQuery.sizeOf(context).width * 0.75,
                  itemCount: boardItems.length,
                  itemBuilder: (context, index) {
                    final item = boardItems[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DragTarget<CardModel>(
                                onAcceptWithDetails: (details) {
                                  setState(() {
                                    if (item.cards.contains(details.data)) {
                                      return;
                                    }
                                    String previousListName =
                                        details.data.currentList;
                                    /// Add the card in the list in which it is dragged
                                    item.cards.add(details.data);
                                    for (var element in boardItems) {
                                      if (element.listName ==
                                          previousListName) {
                                        element.cards.remove(details.data);
                                      }
                                      details.data.currentList = item.listName;
                                    }
                                  });
                                },
                                builder:
                                    (context, candidateData, rejectedData) =>
                                        Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              changeCardName = true;
                                              item.isEditing = true;
                                            });
                                          },
                                          child: Container(
                                            child: item.isEditing
                                                ? SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                          context,
                                                        ).width *
                                                        0.55,
                                                    child: CustomTextField(
                                                      addNewfocusNode:
                                                          focusNode,
                                                      addNewListNameController:
                                                          listNameController,
                                                      name: item.listName,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Text(
                                                      item.listName,
                                                      style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),

                                    ///* This is the list of cards name
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.48,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.75,
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  left: 6,
                                                ),
                                                child: Text(
                                                  item.cards[cardIndex]
                                                      .cardName,
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            feedback: Container(
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  left: 6,
                                                ),
                                                child: Text(
                                                  item.cards[cardIndex]
                                                      .cardName,
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade900,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    left: 6,
                                                  ),
                                                  child: Text(
                                                    item.cards[cardIndex]
                                                        .cardName,
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
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  newCardAddSheet(
                                    context: context,
                                    card: item,
                                    cardNameController:
                                        addNewCardNameController,
                                    cardDescriptionController:
                                        addNewCardDescriptionController,
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Add Card",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            ///* Add New List Options
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    addListField = !addListField;
                  });
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 8,
                    ),
                    child: addListField
                        ? CustomTextField(
                            addNewfocusNode: addNewfocusNode,
                            addNewListNameController: addNewListNameController,
                            name: "List Name",
                          )
                        : const Text(
                            "Add list",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> newCardAddSheet({
    required BuildContext context,
    required ListModel card,
    required TextEditingController cardNameController,
    required TextEditingController cardDescriptionController,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel_sharp,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            String cardName = cardNameController.text;
                            String cardDescription =
                                cardDescriptionController.text;
                            if (cardName.isEmpty || cardDescription.isEmpty) {
                              return;
                            } else {
                              setState(() {
                                card.cards.add(
                                  CardModel(
                                    cardName: addNewCardNameController.text,
                                    cardDescription:
                                        addNewCardDescriptionController.text,
                                    currentList: card.listName,
                                  ),
                                );
                              });
                              Navigator.pop(context);
                              addNewCardDescriptionController.clear();
                              addNewCardNameController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    cursorColor: Colors.blue,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      cardNameController.text = value;
                    },
                    decoration: customTextFieldDecoration("Card Name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: RichText(
                      text: TextSpan(
                        text: "In list ",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: card.listName,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.blue,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (value) {
                            cardDescriptionController.text = value;
                          },
                          decoration: customTextFieldDecoration(
                              "Add card description...\n\n"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

InputDecoration customTextFieldDecoration(String name) {
  return InputDecoration(
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    border: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    hintText: name,
    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontFamily: "Poppins",
    ),
  );
}
