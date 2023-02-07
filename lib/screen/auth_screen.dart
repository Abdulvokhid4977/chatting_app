import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            height: height * 0.35,
            width: width * 0.65,
            child: Column(
              children: [
                Container(
                  height: height * 0.35 * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  width: double.infinity,
                  child: const Text(
                    'Welcome to Chat App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
