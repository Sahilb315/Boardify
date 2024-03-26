import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trello_clone/features/board/model/board_model.dart';
import 'package:trello_clone/features/board/model/list_model.dart';
import 'package:trello_clone/features/board/presentation/page/board_page.dart';
import 'package:trello_clone/features/home/bloc/home_bloc.dart';
import 'package:trello_clone/features/home/presentation/widgets/drawer.dart';
import 'package:trello_clone/utils/text_field_decoration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final TextEditingController _newBoardNameController = TextEditingController();

  User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    homeBloc.add(HomeFetchEvent());
    super.initState();
  }

  final homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      key: _scaffoldState,
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldState.currentState!.openDrawer(),
        ),
        title: const Text(
          "Your Boards",
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
      drawer: CustomDrawer(
        accountName: user!.displayName.toString(),
        accountEmail: user!.email.toString(),
        profilePicUrl: user!.photoURL.toString(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.green.shade400.withOpacity(0.8),
          shape: const CircleBorder(),
          onPressed: () {
            homeBloc.add(HomeNewBoardSheetEvent());
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {
          if (state is HomeNavigateToBoardPageActionState) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    BoardPage(
                  docID: state.docID,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1, 0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: tween.animate(animation),
                    child: child,
                  );
                },
              ),
            );
          } else if (state is HomeNewBoardBottomSheetActionState) {
            newBoardAddSheet(
              context: context,
              boardNameController: _newBoardNameController,
              homeBloc: homeBloc,
            );
          } else if (state is HomeAddNewBoardActionState) {
            Navigator.pop(context);
            _newBoardNameController.clear();
          }
        },
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
              ),
            );
          } else if (state is HomeFetchBoardsState) {
            final boards = state.boards;
            if (boards.isEmpty) {
              return const Center(
                child: Text(
                  "No Boards Found\n Create a new Board to get started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontSize: 16,
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Your Workspace",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 6,
                      mainAxisExtent: 140,
                      crossAxisSpacing: 0,
                    ),
                    itemCount: boards.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 10.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            homeBloc.add(
                              HomeNavigateToBoardPageEvent(
                                docID: boards[index].docID,
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                boards[index].boardName,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Error Occured"),
            );
          }
        },
      ),
    );
  }

  Future<void> newBoardAddSheet({
    required BuildContext context,
    required TextEditingController boardNameController,
    required HomeBloc homeBloc,
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
              padding: const EdgeInsets.only(
                right: 12.0,
                left: 12.0,
                bottom: 32,
                top: 18,
              ),
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
                            if (boardNameController.text.isEmpty) {
                              return;
                            }
                            homeBloc.add(
                              HomeAddNewBoardEvent(
                                boardModel: BoardModel(
                                  docID: "",
                                  boardName: boardNameController.text,
                                  listsInBoard: [
                                    ListModel(
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .remainder(100000)
                                          .toString(),
                                      listName: "TODO",
                                      cards: [],
                                      isEditing: false,
                                    ),
                                  ],
                                ),
                              ),
                            );
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
                      boardNameController.text = value;
                    },
                    decoration: customTextFieldDecoration("Board Name"),
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
