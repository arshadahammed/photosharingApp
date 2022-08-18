import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pineterest_clone/accountCheck/accountCheck.dart';
import 'package:flutter_pineterest_clone/forget_password/forgetPassword.dart';
import 'package:flutter_pineterest_clone/home/homeScreen.dart';
import 'package:flutter_pineterest_clone/signup/signupScreen.dart';
import 'package:flutter_pineterest_clone/widgets/buttonSquare.dart';
import 'package:flutter_pineterest_clone/widgets/inputFields.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Credentials extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextController =
      TextEditingController(text: '');

  Credentials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: const AssetImage("images/logo1.png"),
                backgroundColor: Colors.orange.shade800,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            InputFields(
                hintText: "Enter Email",
                icon: Icons.email_rounded,
                obscureText: false,
                textEditingController: _emailTextController),
            const SizedBox(
              height: 15.0,
            ),
            InputFields(
                hintText: "Enter Password",
                icon: Icons.lock,
                obscureText: true,
                textEditingController: _passwordTextController),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => ForgetPassword()));
                  },
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            ButtonSquare(
                text: "login",
                press: () async {
                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: _emailTextController.text.trim().toLowerCase(),
                        password: _passwordTextController.text.trim());
                    //homescreen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  } catch (error) {
                    Fluttertoast.showToast(msg: error.toString());
                  }
                },
                colors1: Colors.redAccent,
                colors2: Colors.red),
            AccountCheck(
                login: true,
                press: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => SignupScreen()));
                })
          ],
        ));
  }
}
