import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pineterest_clone/accountCheck/accountCheck.dart';
import 'package:flutter_pineterest_clone/home/homeScreen.dart';
import 'package:flutter_pineterest_clone/login/loginScreen.dart';
import 'package:flutter_pineterest_clone/widgets/buttonSquare.dart';
import 'package:flutter_pineterest_clone/widgets/inputFields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Credentials2 extends StatefulWidget {
  const Credentials2({Key? key}) : super(key: key);

  @override
  State<Credentials2> createState() => _Credentials2State();
}

class _Credentials2State extends State<Credentials2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _fullNameController =
      TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passController = TextEditingController(text: "");
  final TextEditingController _phoneNumController =
      TextEditingController(text: "");
  File? imageFile;
  String? imageUrl;

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Please Choose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    //get From Camara
                    _getFromCamera();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    //get from gallery
                    _getFromGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  //get from camera
  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  //get from Gallery
  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              //show image dialouge
              _showImageDialog();
            },
            child: CircleAvatar(
              radius: 90,
              backgroundImage: imageFile == null
                  ? const AssetImage("images/avatar.png")
                  : Image.file(imageFile!).image,
            ),
          ),
          const SizedBox(height: 10.0),
          InputFields(
              hintText: "Enter Username",
              icon: Icons.person,
              obscureText: false,
              textEditingController: _fullNameController),
          const SizedBox(height: 10.0),

          InputFields(
              hintText: "Enter Email",
              icon: Icons.email,
              obscureText: false,
              textEditingController: _emailController),
          const SizedBox(height: 10.0),
          InputFields(
              hintText: "Enter Password",
              icon: Icons.lock,
              obscureText: true,
              textEditingController: _passController),
          const SizedBox(height: 10.0),
          InputFields(
              hintText: "Enter Phone Number",
              icon: Icons.phone,
              obscureText: false,
              textEditingController: _phoneNumController),
          const SizedBox(height: 15.0),
          ButtonSquare(
              text: "Create Account",
              press: () async {
                if (imageFile == null) {
                  Fluttertoast.showToast(msg: "Please Select an Image");
                  return;
                }
                try {
                  final ref = FirebaseStorage.instance
                      .ref()
                      .child('userImages')
                      .child(DateTime.now().toString() + '.jpg');
                  await ref.putFile(imageFile!);
                  imageUrl = await ref.getDownloadURL();
                  await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text.trim().toLowerCase(),
                    password: _passController.text.trim(),
                  );
                  final User? user = _auth.currentUser;
                  final _uid = user!.uid;
                  FirebaseFirestore.instance.collection('users').doc(_uid).set({
                    'id': _uid,
                    'userImage': imageUrl,
                    'name': _fullNameController.text,
                    'email': _emailController.text,
                    'phoneNumber': _phoneNumController.text,
                    'createAt': Timestamp.now(),
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  
                } catch (error) {
                  print(error);
                  Fluttertoast.showToast(msg: error.toString());
                }
                //create HomePage
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              colors1: Colors.red,
              colors2: Colors.redAccent),
          //false anel login lot povan ulla widget call cheyyunn
          AccountCheck(
              login: false,
              press: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }),
        ],
      ),
    );
  }
}
