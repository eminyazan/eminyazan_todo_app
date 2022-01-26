import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../common/custom_snackbar.dart';
import '../../consts/consts.dart';
import '../forgot_password_page.dart';
import '../home_page.dart';
import '../../bases/user_base.dart';
import '../../common/already_have_an_account_acheck.dart';
import '../../common/custom_alert_dialog.dart';
import '../../common/custom_button.dart';
import '../../error_manager/errors.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  AuthService _authService = AuthService();
  MyUser? _user;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 38.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  SvgPicture.asset(
                    "assets/images/login.svg",
                    height: size.height * 0.3,
                  ),
                  SizedBox(height: size.height * 0.08),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.shade100,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your email address";
                        } else if (value.length < 4) {
                          return "Email address is too short";
                        }
                        return null;
                      },
                      onSaved: (inputMail) {
                        _email = inputMail!;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        errorStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        icon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        hintText: "E-mail Address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 7),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.shade100,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your password";
                        } else {
                          if (value.length < 4) {
                            return "Your password is too short";
                          } else {
                            return null;
                          }
                        }
                      },
                      onSaved: (inputPass) {
                        _password = inputPass!;
                      },
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.5),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                    child: CustomButton(
                      submited: _isLoading,
                      onPressed: () => _formSubmit(),
                      buttonText: "Login",
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    isLoginPage: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage())),
                        child: Text(
                          "Forgot Password ?",
                          style: defaultTextStyle(),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        _user = await _authService.loginWithEmail(_email, _password);
        if (_user != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar(
              "Welcome back to the TODO App :)\nWe glad to see you again",
              Colors.deepOrange,
            ),
          );
        } else {
          print("farmer null");
        }
      } on FirebaseException catch (e) {
        setState(() {
          _isLoading = false;
        });
        customAlertDialog(
            context, "Error!", ErrorManager.show(e.code), AlertType.error);
        print("login exception ${e.code}");
      }
    }
  }
}
