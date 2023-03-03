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

  void imagePick() async{
    final picker=ImagePicker();
    final pickedImage= await picker.pickImage(source: ImageSource.camera);
    final pickedImageFile=File(pickedImage!.path);
    setState(() {
      _pickedImage=pickedImageFile;
    });
    widget.imagePickerFn(_pickedImage!);

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage==null? null : FileImage(_pickedImage!),
          radius: 40,
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt_sharp,
              color: Colors.white,
              size: 30,
            ),
            onPressed: imagePick,
          ),
        ),
        TextButton(
          onPressed: imagePick,
          child: const Text('Pick a picture'),
        ),
      ],
    );
  }
}
