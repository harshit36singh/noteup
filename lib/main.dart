import 'package:flutter/material.dart';
import 'package:noteup/login_page.dart';
import 'package:noteup/register_page.dart';
import 'package:noteup/to_do_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:intl/intl.dart';
void main()async{
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
     routes: {
       '/register': (context) => const RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => TodoHomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


