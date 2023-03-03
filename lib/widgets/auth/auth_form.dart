import 'dart:io';

import 'package:chat_app/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  final void Function(String email, String name, String password, File? image,bool isLogin,
      BuildContext ctx) passData;
  final bool _isLoading;

  const AuthForm(this.passData, this._isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _userName = '';
  String? _userEmail = '';
  String? _userPassword = '';
  late bool _isLogin;
  File? imagePicked;

  AuthMode authMode = AuthMode.signup;
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final TextEditingController _pass = TextEditingController();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _isLogin = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (imagePicked == null && !(authMode == AuthMode.login)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pick an image first'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (isValid == true) {
      _formKey.currentState?.save();

      widget.passData(_userName!.trim(), _userEmail!.trim(),
          _userPassword!.trim(),imagePicked, _isLogin, context);
    }
  }

  void changeAuthMode() {
    setState(() {
      authMode == AuthMode.signup
          ? {authMode = AuthMode.login, _isLogin = true, _controller.forward()}
          : {
              authMode = AuthMode.signup,
              _isLogin = false,
              _controller.reverse()
            };
    });
  }

  void imagePicker(File image) {
    imagePicked = image;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            height: authMode == AuthMode.signup ? 420 : 240,
            // height: _heightAnimation.value.height,
            constraints: BoxConstraints(
                minHeight: authMode == AuthMode.signup ? 420 : 240),
            width: deviceSize.width * 0.75,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (authMode == AuthMode.signup)
                      UserImagePicker(imagePicker),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter email address';
                        }
                        if (!(val.endsWith('.com')) || !(val.contains('@'))) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(label: Text('Email address')),
                      onSaved: (val) {
                        _userEmail = val;
                      },
                    ),
                    authMode == AuthMode.signup
                        ? Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter username';
                                  }
                                  if (val.length < 6) {
                                    return 'At least 6 characters';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    label: Text('Username')),
                                onSaved: (val) {
                                  _userName = val;
                                },
                              ),
                              TextFormField(
                                controller: _pass,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (val.length < 6) {
                                    return 'Password should be at least 8 characters long';
                                  }
                                  if (!regex.hasMatch(val)) {
                                    return 'Enter a valid password: The password should contain digits, symbols, capital letter, and lower case letter';
                                  }
                                  return null;
                                },
                                obscuringCharacter: '*',
                                obscureText: true,
                                decoration: const InputDecoration(
                                    label: Text('Password')),
                                onSaved: (val) {
                                  _userPassword = val;
                                },
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter password';
                                  }

                                  if (authMode == AuthMode.signup &&
                                      val != _pass.text) {
                                    return 'Passwords did not match';
                                  }
                                  if (val.length < 6) {
                                    return 'Password should be at least 8 characters long';
                                  }
                                  if (!regex.hasMatch(val)) {
                                    return 'Enter a valid password: The password should contain digits, symbols, capital letter, and lower case letter';
                                  }

                                  return null;
                                },
                                obscuringCharacter: '*',
                                obscureText: true,
                                decoration: InputDecoration(
                                  label: Text(authMode == AuthMode.signup
                                      ? 'Confirm Password'
                                      : 'Password'),
                                ),
                                onSaved: (val) {
                                  _userPassword = val;
                                },
                              ),
                            ],
                          )
                        : TextFormField(
                            controller: _pass,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter password';
                              }
                              if (val.length < 6) {
                                return 'Password should be at least 8 characters long';
                              }
                              if (!regex.hasMatch(val)) {
                                return 'Enter a valid password: The password should contain digits, symbols, capital letter, and lower case letter';
                              }
                              return null;
                            },
                            obscuringCharacter: '*',
                            obscureText: true,
                            decoration:
                                const InputDecoration(label: Text('Password')),
                            onSaved: (val) {
                              _userPassword = val;
                            },
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    widget._isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _trySubmit,
                            child: Text(authMode == AuthMode.signup
                                ? 'Sign Up'
                                : 'Log in'),
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      onPressed: changeAuthMode,
                      child: Text(
                          '${authMode == AuthMode.signup ? 'LOG IN' : 'SIGN UP'} INSTEAD'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
