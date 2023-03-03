import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool _isLoading;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  void _passData(String name, String email, String password, File? image,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${authResult.user?.uid}.jpg');
        await ref.putFile(image!).whenComplete(() => null);
        final url= await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': name, 'email': email, 'image_url': url});
        print(url);
      }
    } on PlatformException catch (error) {
      String? message = 'Something went wrong, check your credentials';
      if (error.message != null) {
        message = error.message;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      debugPrint(err.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AuthForm(_passData, _isLoading),
    );
  }
}
