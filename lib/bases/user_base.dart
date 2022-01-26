import 'package:hive/hive.dart';
part 'user_base.g.dart';
@HiveType(typeId: 2)
class MyUser {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String email;

  MyUser({required this.email, required this.uid});



  MyUser.fromMap(Map<String, dynamic>? map)
      : email = map!["email"],
        uid = map["uid"];

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "uid": uid,
    };
  }
}
