import 'package:flutter/material.dart';

String LOCALDB = "localDB";
String TODO_BOX = "todoBox";

TextStyle defaultTextStyle() {
  return TextStyle(
    color: Colors.orangeAccent,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
}

TextStyle boldTextStyleTitle() {
  return TextStyle(
    color: Colors.orangeAccent.shade700,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );
}

TextStyle boldTextStyleBody() {
  return TextStyle(
    color: Colors.orangeAccent.shade700,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

TextStyle completedTextStyleTitle() {
  return TextStyle(
    color: Colors.black38,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.lineThrough,
  );
}

TextStyle completedTextStyleBody() {
  return TextStyle(
    color: Colors.black38,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.lineThrough,
  );
}

const Color skeletonPrimaryColor = Color(0xFF2967FF);
const Color skeletonGrayColor = Color(0xFF8D8D8E);
const double defaultPadding = 16.0;
