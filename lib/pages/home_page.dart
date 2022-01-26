import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

import '../common/custom_snackbar.dart';
import '../components/todo_widget.dart';
import '../common/loading_page.dart';
import '../bases/todo_base.dart';
import '../consts/consts.dart';
import '../pages/todo/create_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  final _todoBox = Hive.box<Todo>(TODO_BOX);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Todos"),
        backgroundColor: Colors.orangeAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTodoPage(),
          ),
        ),
        child: Icon(
          Icons.add,
          size: 33,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? LoadingPage()
          : SafeArea(
              child: StreamBuilder(
                stream: _todoBox.watch(),
                builder:
                    (BuildContext context, AsyncSnapshot<BoxEvent> snapshot) {
                  return _todoBox.values.isEmpty
                      ? EmptyWidget(size: size)
                      : ListView.builder(
                          itemCount: _todoBox.values.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                await _todoBox.deleteAt(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackbar(
                                    'TODO deleted successfully',
                                    Colors.greenAccent,
                                  ),
                                );
                              },
                              child: TodoWidget(
                                todo: _todoBox.values.toList()[index],
                                index: index,
                                todoBox: _todoBox,
                              ),
                            );
                          },
                        );
                },
              ),
            ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                "assets/images/empty.svg",
                height: size.height * 0.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 10),
              child: Text(
                "You don't have any TODO 😥\n\nCreate a TODO fast and safely\nDon't waste your time anymore 🙃",
                style: defaultTextStyle(),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 45, 30),
            child: Card(
              elevation: 20,
              child: Text(
                "You create your first TODO from here ➡️",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
