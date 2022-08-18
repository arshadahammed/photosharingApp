import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pineterest_clone/login/loginScreen.dart';
import 'package:flutter_pineterest_clone/ownerDetails/ownerDetails.dart';
import 'package:flutter_pineterest_clone/profileScreen/profileScreen.dart';
import 'package:flutter_pineterest_clone/searchPost/searchPost.dart';

import 'package:intl/intl.dart';

class UserSpecificPost extends StatefulWidget {
  String? userId;
  String? userName;
  UserSpecificPost({
    this.userId,
    this.userName,
  });

  @override
  State<UserSpecificPost> createState() => _UserSpecificPostState();
}

class _UserSpecificPostState extends State<UserSpecificPost> {
  String? myImage;
  String? myName;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void read_userInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
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
                  Navigator.pushReplacement(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.pink, Colors.deepOrange.shade300],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2, 0.9]),
      ),
      child: Scaffold(
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
          title: Text(widget.userName!),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => SearchPost()));
              },
              icon: const Icon(Icons.person_search),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => ProfileScreen()));
                },
                icon: const Icon(Icons.person)),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("wallPaper")
              .where("id", isEqualTo: widget.userId)
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
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
    );
  }
}
