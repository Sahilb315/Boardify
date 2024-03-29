import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trello_clone/features/board/bloc/board_bloc.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/board/presentation/widgets/custom_scaffold.dart';
import 'package:trello_clone/features/card/presentation/page/card_page.dart';
import 'package:trello_clone/features/home/presentation/widgets/text_field.dart';
import 'package:trello_clone/utils/text_field_decoration.dart';
import '../widgets/cards_builder.dart';

class BoardPage extends StatefulWidget {
  final String docID;
  final String boardName;
  const BoardPage({super.key, required this.docID, required this.boardName});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    boardBloc.add(BoardFetchListEvent(docID: widget.docID));
    addNewCardDescriptionController = TextEditingController();
    addNewCardNameController = TextEditingController();
    addNewListNameController = TextEditingController();
    super.initState();
  }

  final boardBloc = BoardBloc();

  late TextEditingController addNewListNameController;
  late TextEditingController addNewCardNameController;
  late TextEditingController addNewCardDescriptionController;

  final focusNode = FocusNode();

  @override
  void dispose() {
    addNewListNameController.dispose();
    addNewCardNameController.dispose();
    addNewCardDescriptionController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardBloc, BoardState>(
      bloc: boardBloc,
      listenWhen: (previous, current) => current is BoardActionState,
      buildWhen: (previous, current) => current is! BoardActionState,
      listener: (context, state) {
        if (state is BoardPopMenuEditListNameActionState) {
          popUpMenuItemEditListName(state.context, state.listModel);
        } else if (state is BoardAddNewCardSheetActionState) {
          newCardAddSheet(
            context: context,
            listModel: state.listModel,
            cardNameController: state.cardNameController,
            cardDescriptionController: state.cardDescriptionController,
          );
        } else if (state is BoardDeleteListActionState) {
          deleteListDialogBox(context, state);
        } else if (state is BoardNavigateToCardPageActionState) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => CardPage(
                cardModel: state.cardModel,
                docID: widget.docID,
                listModel: state.listModel,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(0, 1);
                var end = Offset.zero;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: Curves.ease),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
      },
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
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    actions: [
                      IconButton(
                        onPressed: () {
                          if (state.showListAppBar) {
                            if (addNewListNameController.text.isEmpty) {
                              return;
                            }
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
                            focusNode.unfocus();
                            addNewListNameController.clear();
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
                        addNewListNameController.clear();
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
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    title: Text(
                      widget.boardName,
                      style: const TextStyle(
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
                                                        boardBloc.add(
                                                          BoardPopupMenuItemEditListNameEvent(
                                                            context: context,
                                                            listModel: item,
                                                          ),
                                                        );
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
                                                        boardBloc.add(
                                                          BoardAddNewCardSheetEvent(
                                                            listModel: item,
                                                            cardNameController:
                                                                addNewCardNameController,
                                                            cardDescriptionController:
                                                                addNewCardDescriptionController,
                                                          ),
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
                                                    PopupMenuItem(
                                                      onTap: () {
                                                        boardBloc.add(
                                                            BoardPopMenuDeleteListEvent(
                                                          listID: item.id,
                                                          docID: widget.docID,
                                                        ));
                                                      },
                                                      height: 30,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 9,
                                                        horizontal: 18,
                                                      ),
                                                      value: "Delete",
                                                      child: const Text(
                                                        "Delete List",
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
                                          CardsBuilder(
                                            listModel: item,
                                            boardBloc: boardBloc,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        boardBloc.add(
                                          BoardAddNewCardSheetEvent(
                                            listModel: item,
                                            cardNameController:
                                                addNewCardNameController,
                                            cardDescriptionController:
                                                addNewCardDescriptionController,
                                          ),
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
                                  addNewfocusNode: focusNode,
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

  Future<void> deleteListDialogBox(
      BuildContext context, BoardDeleteListActionState state) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF020D19),
          title: const Text(
            "Delete list",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to delete this list?",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.blueGrey.shade900,
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      boardBloc.add(BoardDeleteListEvent(
                        listID: state.listID,
                        docID: widget.docID,
                      ));
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    child: const Text(
                      "Delete",
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

  Future<void> popUpMenuItemEditListName(
    BuildContext context,
    ListModel item,
  ) {
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
                            if (cardName.isEmpty) {
                              return;
                            } else {
                              boardBloc.add(
                                BoardAddCardInListEvent(
                                  cardModel: CardModel(
                                    cardID: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .remainder(1000)
                                        .toString(),
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
