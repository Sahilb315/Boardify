import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trello_clone/features/board/bloc/board_bloc.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/board/presentation/ui/custom_scaffold.dart';
import 'package:trello_clone/features/home/presentation/ui/text_field.dart';
import 'package:trello_clone/utils/text_field_decoration.dart';
import '../ui/cards_builder.dart';

class BoardPage extends StatefulWidget {
  final String docID;
  const BoardPage({super.key, required this.docID});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    boardBloc.add(BoardFetchListEvent(docID: widget.docID));
    super.initState();
  }

  final boardBloc = BoardBloc();

  final TextEditingController listNameController = TextEditingController();
  final TextEditingController addNewListNameController =
      TextEditingController();
  final TextEditingController addNewCardNameController =
      TextEditingController();
  final TextEditingController addNewCardDescriptionController =
      TextEditingController();

  final focusNode = FocusNode();
  final addNewfocusNode = FocusNode();

  @override
  void dispose() {
    listNameController.dispose();
    addNewListNameController.dispose();
    addNewCardNameController.dispose();
    addNewCardDescriptionController.dispose();
    focusNode.dispose();
    addNewfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardBloc, BoardState>(
      bloc: boardBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is BoardLoadingState) {
          return CustomBoardPage(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade200,
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
              ),
            ),
          );
        } else if (state is BoardLoadedState) {
          final boardItems = state.lists;
          return Scaffold(
            backgroundColor: Colors.blue,
            appBar: state.showListAppBar
                ? AppBar(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    actions: [
                      IconButton(
                        onPressed: () {
                          if (state.showListAppBar) {
                            boardBloc.add(
                              BoardAddListEvent(
                                docID: widget.docID,
                                listModel: ListModel(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .remainder(100000)
                                      .toString(),
                                  listName: addNewListNameController.text,
                                  cards: [],
                                  isEditing: false,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ],
                    leading: IconButton(
                      onPressed: () {
                        boardBloc.add(BoardOnTapAddListEvent(
                          docID: widget.docID,
                          isChanging: false,
                        ));
                        focusNode.unfocus();
                        addNewfocusNode.unfocus();
                        addNewListNameController.clear();
                        listNameController.clear();
                      },
                      icon: const Icon(
                        Icons.cancel_sharp,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      "Add list",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DragTarget<CardModel>(
                                      onAcceptWithDetails: (details) {
                                        final cardModel = details.data;
                                        boardBloc.add(BoardDragDataAcceptEvent(
                                          docID: widget.docID,
                                          listModel: item,
                                          cardModel: cardModel,
                                        ));
                                      },
                                      builder: (context, candidateData,
                                              rejectedData) =>
                                          Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    item.listName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuButton(
                                                color: const Color(0xFF0B1215),
                                                icon: const Icon(
                                                  Icons.more_vert_rounded,
                                                ),
                                                iconColor: Colors.white,
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        popUpMenuItemEditListName(
                                                            context, item);
                                                      },
                                                      height: 30,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 9,
                                                        horizontal: 18,
                                                      ),
                                                      value: "Edit",
                                                      child: const Text(
                                                        "Edit List Name",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        newCardAddSheet(
                                                          context: context,
                                                          listModel: item,
                                                          cardNameController:
                                                              addNewCardNameController,
                                                          cardDescriptionController:
                                                              addNewCardDescriptionController,
                                                        );
                                                      },
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 9,
                                                        horizontal: 18,
                                                      ),
                                                      height: 30,
                                                      value: "Add Card",
                                                      child: const Text(
                                                        "Add Card",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ];
                                                },
                                              ),
                                            ],
                                          ),

                                          ///* This is the list of cards name
                                          CardsBuilder(item: item),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        newCardAddSheet(
                                          context: context,
                                          listModel: item,
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
                        boardBloc.add(BoardOnTapAddListEvent(
                          docID: widget.docID,
                          isChanging: true,
                        ));
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
                          child: state.showListAppBar
                              ? CustomTextField(
                                  addNewfocusNode: addNewfocusNode,
                                  addNewListNameController:
                                      addNewListNameController,
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
        } else {
          return const CustomBoardPage(
            body: Center(
              child: Text("Error Occured"),
            ),
          );
        }
      },
    );
  }

  Future<void> popUpMenuItemEditListName(BuildContext context, ListModel item) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF011222),
          title: const Text(
            "Edit List Name",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.blue,
                controller: addNewListNameController,
                decoration: customTextFieldDecoration(
                  "List Name",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        const Color(0xFF011222).withOpacity(0.1),
                      ),
                    ),
                    onPressed: () {
                      boardBloc.add(
                        BoardUpdateListNameEvent(
                          docID: widget.docID,
                          updatedName: addNewListNameController.text,
                          listModel: item,
                        ),
                      );
                      Navigator.pop(context);
                      addNewListNameController.clear();
                    },
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> newCardAddSheet({
    required BuildContext context,
    required ListModel listModel,
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
                              boardBloc.add(
                                BoardAddCardInListEvent(
                                  cardModel: CardModel(
                                    cardName: addNewCardNameController.text,
                                    cardDescription:
                                        addNewCardDescriptionController.text,
                                    currentList: listModel.listName,
                                  ),
                                  listModel: listModel,
                                  docID: widget.docID,
                                ),
                              );
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
                            text: listModel.listName,
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
                            "Add card description...\n\n",
                          ),
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
