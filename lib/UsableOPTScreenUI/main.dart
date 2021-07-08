import 'package:flutter/material.dart';
import 'login.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

// Import the firebase_core plugin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Auth',
      home: LoginScreen(),
    );
  }
}
