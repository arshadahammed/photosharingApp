import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pineterest_clone/login/loginScreen.dart';
import 'package:flutter_pineterest_clone/ownerDetails/ownerDetails.dart';
import 'package:flutter_pineterest_clone/profileScreen/profileScreen.dart';
import 'package:flutter_pineterest_clone/searchPost/searchPost.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime pre_backpress = DateTime.now();
  String changeTitle = "Grid View";
  bool checkView = false;

  File? imageFile;
  String? imageUrl;
  String? myImage;
  String? myName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  //functions
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

  void _upload_image() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "Please Select an Image");
      return;
    }
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImages")
          .child(DateTime.now().toString() + '.jpg');
      await ref.putFile(imageFile!);
      imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('wallPaper')
          .doc(DateTime.now().toString())
          .set({
        'id': _auth.currentUser!.uid,
        'userImage': myImage,
        'name': myName,
        'email': _auth.currentUser!.email,
        'image': imageUrl,
        'downloads': 0,
        'createdAt': DateTime.now(),
      });
      Fluttertoast.showToast(msg: "Image Uploaded Successfully");
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );

      imageFile == null;
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  void read_userInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then<dynamic>((DocumentSnapshot snapshot) async {
      myImage = snapshot.get('userImage');
      myName = snapshot.get('name');
    });
  }

  @override
  void initState() {
    super.initState();
    read_userInfo();
  }

  Widget listviewWiget(String docId, String img, String userImage, String name,
      DateTime date, String userId, int downloads) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 16,
        shadowColor: Colors.white10,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink, Colors.deepOrange.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, 0.9]),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  //create owner details
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OwnerDetails(
                                img: img,
                                userImg: userImage,
                                name: name,
                                date: date,
                                docId: docId,
                                userId: userId,
                                downloads: downloads,
                              )));
                },
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        userImage,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          DateFormat("dd MMMM, yyyy - hh:mm a")
                              .format(date)
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget gridViewWiget(String docId, String img, String userImage, String name,
      DateTime date, String userId, int downloads) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(6.0),
      crossAxisSpacing: 1,
      crossAxisCount: 1,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink, Colors.deepOrange.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9]),
          ),
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              //create oWner Details
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OwnerDetails(
                            img: img,
                            userImg: userImage,
                            name: name,
                            date: date,
                            docId: docId,
                            userId: userId,
                            downloads: downloads,
                          )));
            },
            child: Center(
              child: Image.network(img, fit: BoxFit.fill),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        print('$timegap');
        final canExit = timegap >= Duration(seconds: 2);

        pre_backpress = DateTime.now();
        if (canExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink, Colors.deepOrange.shade300],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9]),
        ),
        child: Scaffold(
          floatingActionButton: Wrap(
            direction: Axis.horizontal,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  heroTag: "1",
                  backgroundColor: Colors.deepOrange.shade400,
                  onPressed: () {
                    //show ImageDialouge
                    _showImageDialog();
                  },
                  child: const Icon(Icons.camera_enhance),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  heroTag: "2",
                  backgroundColor: Colors.pink.shade400,
                  onPressed: () {
                    //upload image
                    _upload_image();
                  },
                  child: const Icon(Icons.cloud_upload),
                ),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade300, Colors.pink],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.2, 0.9]),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                setState(() {
                  changeTitle = "List View";
                  checkView = true;
                });
              },
              onDoubleTap: () {
                setState(() {
                  changeTitle = "Grid View";
                  checkView = false;
                });
              },
              child: Text(changeTitle),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Icon(Icons.logout_outlined),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SearchPost()));
                },
                icon: const Icon(Icons.person_search),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProfileScreen()));
                  },
                  icon: const Icon(Icons.person)),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("wallPaper")
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  if (checkView == true) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return listviewWiget(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]["image"],
                          snapshot.data!.docs[index]["userImage"],
                          snapshot.data!.docs[index]["name"],
                          snapshot.data!.docs[index]["createdAt"].toDate(),
                          snapshot.data!.docs[index]["id"],
                          snapshot.data!.docs[index]["downloads"],
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  } else {
                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return gridViewWiget(
                          snapshot.data!.docs[index].id,
                          snapshot.data!.docs[index]["image"],
                          snapshot.data!.docs[index]["userImage"],
                          snapshot.data!.docs[index]["name"],
                          snapshot.data!.docs[index]["createdAt"].toDate(),
                          snapshot.data!.docs[index]["id"],
                          snapshot.data!.docs[index]["downloads"],
                        );
                      },
                    );
                  }
                } else {
                  return const Center(
                    child: Text(
                      "There is no tasks",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }
              }
              return const Center(
                child: Text(
                  "Something Went Wrong",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
