import 'package:flutter/material.dart';

import '../pages/register/register_page.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool isLoginPage;
   AlreadyHaveAnAccountCheck({
    Key? key,
    required this.isLoginPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLoginPage ? "Don't you have an account? " : "Do you have an account? ",
          style: TextStyle(color: Colors.black87,fontSize: 15),
        ),
        GestureDetector(
          onTap: isLoginPage?()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage())):()=>Navigator.pop(context),
          child: Text(
            isLoginPage ? "  Register" : " Login",
            style: TextStyle(
              color: Colors.deepOrange.shade400,
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),
          ),
        )
      ],
    );
  }
}
