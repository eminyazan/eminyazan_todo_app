import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

customAlertDialog(BuildContext context,String title,desc,AlertType alertType) async {
  return  await Alert(
    context: context,
    type: alertType,
    title: title,
    desc: desc,
    style: AlertStyle(animationType: AnimationType.grow,),
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}