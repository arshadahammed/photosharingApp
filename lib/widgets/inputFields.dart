import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pineterest_clone/widgets/textFieldContainer.dart';

class InputFields extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController textEditingController;

  const InputFields(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.obscureText,
      required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
      cursorColor: Colors.white,
      obscureText: obscureText,
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          helperStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          prefixIcon: Icon(icon, color: Colors.white, size: 20),
          border: InputBorder.none),
    ));
  }
}
