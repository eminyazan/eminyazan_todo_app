import 'package:flutter/material.dart';

SnackBar customSnackbar(String content, Color backgroundColor) {
  return SnackBar(
    content: Text(content,style: TextStyle(color: Colors.white),),
    backgroundColor: backgroundColor,
    duration: Duration(seconds: 3),
    dismissDirection: DismissDirection.horizontal,
  );
}
