import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickerFn;
  const UserImagePicker(this.imagePickerFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void bottomSheet() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Wrap(children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0))),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        imagePick('gallery');
                      },
                      child: const Text(
                        'Gallery',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {Navigator.of(context).pop(); imagePick('camera');},
                      child: const Text(
                        'Camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            )
          ]);
        });
  }

  void imagePick(String a) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: a == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 150,
        maxHeight: 150);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickerFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
          radius: 40,
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt_sharp,
              color: Colors.white,
              size: 30,
            ),
            onPressed: bottomSheet,
          ),
        ),
        TextButton(
          onPressed: bottomSheet,
          child: const Text('Pick a picture'),
        ),
      ],
    );
  }
}
