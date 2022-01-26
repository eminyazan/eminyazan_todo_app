import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../bases/todo_base.dart';
import '../common/custom_alert_dialog.dart';
import '../common/human_readable_date.dart';
import '../consts/consts.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;
  final int index;
  final Box<Todo> todoBox;
  const TodoWidget({Key? key, required this.todo,required this.index,required this.todoBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        color: Color(0xFFF9E4C5),
        shadowColor: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("TODO Type: ${todo.todoType}",style: todo
                      .completed
                      ? completedTextStyleBody()
                      : boldTextStyleBody(),),
                  Text("TODO Date: ${humanReadableDate(todo.date)}",style: todo
                      .completed
                      ? completedTextStyleBody()
                      : boldTextStyleBody(),),
                ],
              ),
            ),
            Row(
              children: [
                //Image
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor:
                    todo
                        .completed
                        ?Colors.black26:Colors.orangeAccent,
                    radius: size.width * 0.13,
                    child: CircleAvatar(
                      radius: size.width * 0.12,
                      backgroundImage: FileImage(
                        File(
                          todo
                              .imageUrl,
                        ),
                      ),
                    ),
                  ),
                ),
                //Title
                Padding(
                  padding:
                  const EdgeInsets.only(left: 10.0),
                  child: Text(
                    todo
                        .title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: todo
                        .completed
                        ? completedTextStyleTitle()
                        : TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  14.0, 10, 14, 0),
              child: Text(
                todo.about,
                style: todo
                    .completed
                    ? completedTextStyleTitle()
                    : boldTextStyleTitle(),
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0),
                    child: IconButton(
                      onPressed: () async {
                        await todoBox.putAt(
                          index,
                          Todo(
                            title: todo
                                .title,
                            about: todo
                                .about,
                            date: todo
                                .date,
                            todoType: todo
                                .todoType,
                            completed: todo
                                .completed
                                ? false
                                : true,
                            imageUrl: todo
                                .imageUrl,
                          ),
                        );
                      },
                      icon: Icon(
                        todo
                            .completed
                            ?Icons.settings_backup_restore_rounded:Icons.done_rounded,
                        size: 33,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.black26,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        await todoBox.deleteAt(index);
                        await customAlertDialog(
                          context,
                          "A tip!",
                          "Did you know you can delete your TODOs with swiping left or right\nIt was just an advice it can be more helpful 😎 ",
                          AlertType.info,
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 33,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
