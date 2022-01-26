import 'package:hive/hive.dart';
part 'todo_base.g.dart';
@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String title;
  @HiveField(1)
  String about;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  String todoType;
  @HiveField(4)
  bool completed;
  @HiveField(5)
  String imageUrl;

  Todo({
    required this.title,
    required this.about,
    required this.date,
    required this.todoType,
    required this.completed,
    required this.imageUrl,
  });
}
