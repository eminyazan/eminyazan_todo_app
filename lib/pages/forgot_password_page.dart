import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../common/custom_alert_dialog.dart';
import '../common/custom_button.dart';
import '../consts/consts.dart';
import '../error_manager/errors.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _authController = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? _email;
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/images/forgot.svg",
                height: size.height * 0.25,
              ),
              SizedBox(height: size.height * 0.03),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your email address";
                          } else {
                            if (value.length < 4) {
                              return "Your email address is too short";
                            } else {
                              if (value.contains('@') && value.contains('.')) {
                                return null;
                              } else {
                                return "Invalid email address please check it";
                              }
                            }
                          }
                        },
                        onSaved: (inputEmail) {
                          _email = inputEmail;
                        },
                        decoration: InputDecoration(
                          hintText: "E-mail Address",
                          labelStyle: defaultTextStyle(),
                          labelText: "E-mail Address",
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            color: Colors.orangeAccent,
                          ),
                          focusColor: Colors.deepOrange,
                          hoverColor: Colors.deepOrange,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomButton(
                        buttonIcon: Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                        ),
                        buttonText: "Send link to email address",
                        height: 45,
                        onPressed: () => _sendLink(_emailController.text),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendLink(String email) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _authController.sendPasswordReset(email);
        _emailController.clear();
        await customAlertDialog(context, "Success!", "We sent an email for reset your password check your mail inbox", AlertType.success);
      } on FirebaseAuthException catch (e) {
        await customAlertDialog(context, "ERROR!", ErrorManager.show(e.code), AlertType.error);
      }
    }
  }
}