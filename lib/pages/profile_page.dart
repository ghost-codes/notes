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
    return Center(
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        NetworkImage(authProvider.currentUser.photoUrl),
                    radius: 70,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    authProvider.currentUser.displayName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "100 Friends",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Friends",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddFriend())),
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              "Add Friend",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      child: FutureBuilder<QuerySnapshot>(
                        future: friendsRef
                            .doc(authProvider.currentUser.uid)
                            .collection("friends")
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<Widget> friends = [];
                          snapshot.data.docs.forEach((doc) async {
                            Userr user = Userr.fromDocument(
                                await userRef.doc(doc.id).get());
                            if (doc["isFriend"] == "true") {
                              friends.add(buildUserTile(
                                  user: user, isFriend: doc["isFirend"]));
                            }
                          });
                          return Column(
                            children: friends,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
