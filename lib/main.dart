import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../bases/todo_base.dart';
import '../bases/user_base.dart';
import '../pages/home_page.dart';
import '../pages/onboard_page.dart';
import 'consts/consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(MyUserAdapter());
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<MyUser>(LOCALDB);
  await Hive.openBox<Todo>(TODO_BOX,);
  Box<bool> _onBoardBox = await Hive.openBox("onBoardBox");
  runApp(
    MyApp(
      onBoardBox: _onBoardBox,
    ),
  );
}

class MyApp extends StatefulWidget {
  final Box onBoardBox;

  const MyApp({Key? key, required this.onBoardBox}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orangeAccent.shade200,
        splashColor: Colors.orange,
        shadowColor: Colors.deepOrange,
        backgroundColor: Colors.orangeAccent.shade100,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.orangeAccent.shade700,
            fontWeight: FontWeight.w800,
            fontSize: 27,
          ),
          headline2: TextStyle(
            color: Colors.orangeAccent.shade400,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
          headline3: TextStyle(
            color: Colors.orange.shade200,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
          headline4: TextStyle(
            color: Colors.orangeAccent.shade100,
            fontWeight: FontWeight.w400,
            fontSize: 21,
          ),
          bodyText1: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.normal,
            fontSize: 17,
          ),
          bodyText2: TextStyle(
            color: Colors.orangeAccent.shade400,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          button: TextStyle(
            color: Colors.orangeAccent,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      title: "M.Emin Yazan TODO App",
      home: widget.onBoardBox.values.isEmpty
          ? OnBoardingPage(
              onBoardBox: widget.onBoardBox,
            )
          : HomePage(),
    );
  }
}
