import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notez/constants/constants.dart';
import 'package:notez/models/models.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:notez/pages/pages.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthenticationProvider>(
          builder: (context, authProvider, child) {
            return FutureBuilder<QuerySnapshot>(
              future: friendsRef
                  .doc(authProvider.currentUser.uid)
                  .collection("friends")
                  .orderBy("isFriend")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                int friendsCount = 0;
                friendsCount = snapshot.data.docs.length;

                int itemCount = friendsCount + 1;
                return ListView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                NetworkImage(authProvider.currentUser.photoUrl),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            authProvider.currentUser.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "$friendsCount Friends",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Friends",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddFriend()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Add Friend",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 15,
                          )
                        ],
                      );
                    } else {
                      String uid = snapshot.data.docs[index - 1].id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: FutureBuilder(
                          future: userRef.doc(uid).get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return LinearProgressIndicator();
                            }
                            Userr user = Userr.fromDocument(snapshot.data);
                            if (user != null) {
                              return buildUserTile(context,
                                  // user: authProvider.currentUser,
                                  user: user,
                                  currentUser: authProvider.currentUser);
                            }
                          },
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
//
