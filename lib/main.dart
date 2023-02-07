import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './screen/chat_screen.dart';
import './screen/auth_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Colors.blue, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurpleAccent),
      ),
      home: const ChatScreen(),
    );
  }
}