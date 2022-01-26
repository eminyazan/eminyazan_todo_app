import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

customAlertDialog(BuildContext context,String title,desc,AlertType alertType,{GlobalKey<ScaffoldState>? scaffoldKey}) async {
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
        onPressed: () => scaffoldKey==null?Navigator.pop(context):Navigator.pop(scaffoldKey!.currentContext!),
        width: 120,
      )
    ],
  ).show();
}