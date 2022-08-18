import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pineterest_clone/accountCheck/accountCheck.dart';
import 'package:flutter_pineterest_clone/login/loginScreen.dart';
import 'package:flutter_pineterest_clone/signup/signupScreen.dart';
import 'package:flutter_pineterest_clone/widgets/buttonSquare.dart';
import 'package:flutter_pineterest_clone/widgets/inputFields.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Credentials3 extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController =
      TextEditingController(text: "");

  // const Credentials3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Center(
              child: Image.asset(
                "images/forget.png",
                width: 300.0,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          InputFields(
              hintText: "Enter Email",
              icon: Icons.email_rounded,
              obscureText: false,
              textEditingController: _emailController),
          const SizedBox(height: 15.0),
          ButtonSquare(
              text: "Send Link",
              press: () async {
                try {
                  await _auth.sendPasswordResetEmail(
                      email: _emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.amber,
                    content: Text(
                      "Password Reset Email has been sent!",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ));
                } on FirebaseAuthException catch (error) {
                  Fluttertoast.showToast(msg: error.toString());
                }
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              colors1: Colors.red,
              colors2: Colors.redAccent),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => SignupScreen()));
              },
              child: const Center(child: Text("Create Account"))),
          AccountCheck(
              login: false,
              press: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              })
        ],
      ),
    );
  }
}
