import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          const Center(
            child: Text(
              "PhotoSharing",
              style: TextStyle(
                fontSize: 70,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Signatra",
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          const Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: "Bebas",
              ),
            ),
          )
        ],
      ),
    );
  }
}
