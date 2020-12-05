import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notez/pages/pages.dart';
import 'package:notez/providers/LabelsProvider.dart';
import 'package:notez/providers/notesProvider.dart';
import 'package:notez/providers/authenticationProvider.dart';
import 'package:notez/widgets/bottom_navigator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider>(
          create: (_) => NotesProvider(),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<LabelsProvider>(
          create: (_) => LabelsProvider(),
        ),
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: authProvider.currentUsercheck() ? BaseScreen() : SignUp(),
          );
        },
      ),
    );
  }
}
