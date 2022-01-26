import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../error_manager/errors.dart';
import '../../bases/user_base.dart';
import '../../common/already_have_an_account_acheck.dart';
import '../../common/custom_alert_dialog.dart';
import '../../common/custom_button.dart';
import '../../services/auth_service.dart';
import '../home_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  MyUser? _myUser;
  AuthService _authService = AuthService();
  bool _isLoading = false;
  File? image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  late String _email, _password, _passwordConfirm;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: size.height * 0.025),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SvgPicture.asset(
                      "assets/images/register.svg",
                      height: size.height * 0.3,
                    ),
                    SizedBox(height: size.height * 0.04),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return "Enter your email address";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (inputMail) {
                          _email = inputMail!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: "E-mail Address",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return "Enter your password";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (inputPass) {
                          _password = inputPass!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintText: "Password",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.shade100,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordConfirmController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your password";
                          } else {
                            if (value.length >= 4) {
                              if (value == _passwordController.text) {
                                return null;
                              } else {
                                return "Your password doesn't match check it";
                              }
                            } else {
                              return "Password is too short";
                            }
                          }
                        },
                        onSaved: (inputPass) {
                          _passwordConfirm = inputPass!;
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          errorStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          hintText: "Password Again",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                      child: CustomButton(
                        submited: _isLoading,
                        onPressed: () => _formSubmit(),
                        buttonText: "Register",
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    AlreadyHaveAnAccountCheck(
                      isLoginPage: false,
                    ),
                  ],
                ),
              )),
            ),
          );
  }

  _formSubmit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        try{
          _myUser = await _authService.registerWithEmail(_email, _password,);
          if (_myUser != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
          } else {
            setState(() {
              _isLoading = false;
            });
            await customAlertDialog(
              context,
              "Error!",
              "An error occurred please try again later",
              AlertType.error,
            );
          }
        }on FirebaseException catch(e){
          setState(() {
            _isLoading = false;
          });
          await customAlertDialog(
            context,
            "Error!",
            ErrorManager.show(e.code),
            AlertType.error,
          );
        }

      }
  }
}
