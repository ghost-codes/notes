import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notez/constants/firestore_constants.dart';
import 'package:notez/models/models.dart';

class AuthenticationProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Userr currentUser;
  bool sharedNoteNotificatoin = true;

  setSharedNoteNotificaiton(String p) {
    if (p == "open") {
      sharedNoteNotificatoin = false;
    } else {
      print("me");
      sharedNoteNotificatoin = true;
      print(sharedNoteNotificatoin);
    }

    notifyListeners();
  }

  signInWithGoogle() async {
    try {
      GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleSignInAuthenticaiton =
          await _googleSignInAccount.authentication;
      AuthCredential _authCredential = GoogleAuthProvider.credential(
          idToken: _googleSignInAuthenticaiton.idToken,
          accessToken: _googleSignInAuthenticaiton.accessToken);

      UserCredential _user = await _auth.signInWithCredential(_authCredential);
      User user = _user.user;
      currentUser = Userr.fromAuthUser(user);
      await userRef.doc(currentUser.uid).set({
        "displayName": currentUser.displayName,
        "uid": currentUser.uid,
        "photoUrl": currentUser.photoUrl,
        "email": currentUser.email,
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  signInAnonymously() async {
    try {
      final UserCredential authResult = await _auth.signInAnonymously();
      print(authResult.user.uid);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  currentUsercheck() {
    if (_auth.currentUser != null) {
      currentUser = Userr.fromAuthUser(_auth.currentUser);
    }
    return _auth.currentUser != null;
  }
}
