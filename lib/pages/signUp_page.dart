import 'package:flutter/material.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25.0),
        alignment: Alignment.center,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) {
              return Column(
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 100),
                  signUpContainers(
                    "Sign Up with Google",
                    Colors.white,
                    authProvider.signInWithGoogle,
                  ),
                  signUpContainers("Sign Up with Facebook", Colors.blue, null),
                  signUpContainers("Sign Up with Email", Colors.green, null),
                  Divider(),
                  signUpContainers(
                    "Go Anonymous",
                    Colors.green[900],
                    authProvider.signInAnonymously,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget signUpContainers(String title, Color color, dynamic function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color == Colors.white ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
