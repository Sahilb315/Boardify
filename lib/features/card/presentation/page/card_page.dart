import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trello_clone/features/board/model/card_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/card/bloc/card_bloc.dart';
import 'package:trello_clone/features/card/repo/card_repo.dart';

import '../../../board/presentation/widgets/custom_scaffold.dart';

class CardPage extends StatefulWidget {
  final CardModel cardModel;
  final String docID;
  final ListModel listModel;

  const CardPage({
    super.key,
    required this.cardModel,
    required this.docID,
    required this.listModel,
  });

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late TextEditingController descriptionController;
  late TextEditingController nameController;
  final focusNode = FocusNode();
  late CardBloc cardBloc;
  @override
  void initState() {
    cardBloc = CardBloc();
    cardBloc.add(CardFetchEvent(
      listModel: widget.listModel,
      cardModel: widget.cardModel,
      docID: widget.docID,
    ));
    //! Have to work on not taking these values from previous page as they are not updated when we go back & come back
    nameController = TextEditingController(text: widget.cardModel.cardName);
    descriptionController =
        TextEditingController(text: widget.cardModel.cardDescription);
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool showChangedNameAppBar = false;
  bool showChangedDescAppBar = false;

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showChangedDescAppBar = true;
        });
      }
    });
    return BlocConsumer<CardBloc, CardState>(
      bloc: cardBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CardLoadingState) {
          return CustomBoardPage(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade200,
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
              ),
            ),
          );
        } else if (state is CardLoadedState) {
          final cardModel = state.cardModel;
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: showChangedNameAppBar || showChangedDescAppBar
                ? AppBar(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          if (showChangedDescAppBar) {
                            showChangedDescAppBar = false;
                            focusNode.unfocus();
                          }
                          showChangedNameAppBar = false;
                        });
                      },
                      icon: const Icon(
                        Icons.cancel_sharp,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          if (showChangedDescAppBar) {
                            setState(() {
                              CardRepo.updateCardDescription(
                                listModel: widget.listModel,
                                cardModel: cardModel,
                                docID: widget.docID,
                                cardDescription: descriptionController.text,
                              );
                              showChangedDescAppBar = false;
                              focusNode.unfocus();
                            });
                          } else if (showChangedNameAppBar) {
                            setState(() {
                              CardRepo.updateCardName(
                                listModel: widget.listModel,
                                cardModel: cardModel,
                                docID: widget.docID,
                                newCardName: nameController.text,
                              );
                              showChangedNameAppBar = false;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  )
                : AppBar(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel_sharp,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* Name Container
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: double.maxFinite,
                    color: const Color(0xFF101720).withOpacity(1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showChangedNameAppBar = !showChangedNameAppBar;
                              });
                            },
                            child: Container(
                              child: showChangedNameAppBar
                                  ? TextField(
                                      autofocus: true,
                                      controller: nameController,
                                      cursorColor: Colors.blue,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400,
                                      ),
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      cardModel.cardName,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          RichText(
                            text: TextSpan(
                              text: "In list ",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.grey.shade300,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: cardModel.currentList,
                                  style: TextStyle(
                                    decorationThickness: 2,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade300,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //* Description Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.maxFinite,
                    color: const Color(0xFF101720),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: focusNode,
                            controller: descriptionController,
                            cursorColor: Colors.blue,
                            style: TextStyle(color: Colors.grey.shade400),
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              hintText: 'Add card description...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //* Date Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.maxFinite,
                    color: const Color(0xFF101720),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 12),
                              child: Text(
                                "Start Date",
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ),
                            Container(
                              height: 0.8,
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              color: Colors.grey.shade400,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, bottom: 8),
                              child: Text(
                                "Due Date",
                                style: TextStyle(color: Colors.grey.shade400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    width: double.maxFinite,
                    color: const Color(0xFF101720),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.tags,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Labels..",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8),
                    child: Text(
                      "Activity",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontFamily: "Poppins",
                        fontSize: 18,
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
}
