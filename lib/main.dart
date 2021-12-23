import 'package:flutter/material.dart';
import 'package:moth/book_details.dart';
import 'package:moth/books_page.dart';
import 'package:moth/screens/addbooks.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Moth',
      home:
          //BooksPage()
          LoginScreen(),
    );
  }
}
