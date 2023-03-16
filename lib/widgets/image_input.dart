import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function(File pickedImage) selectImage;
  ImageInput(this.selectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  _takePicture() async {
    var imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFile!.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);

    _storedImage!.copy('${appDir.path}/$fileName');
    widget.selectImage(_storedImage!);
  }

  _selectPicture() async {
    var imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = File(imageFile!.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile!.path);

    _storedImage!.copy('${appDir.path}/$fileName');
    widget.selectImage(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            alignment: Alignment.center,
            child: _storedImage != null
                ? Image.file(
                    _storedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Text(
                    'No Image Taken',
                    textAlign: TextAlign.center,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              label: Text('Take Picture'),
              onPressed: () {
                _takePicture();
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              label: Text('Select from Gallery'),
              onPressed: () {
                _selectPicture();
              },
            ),
          ],
        ),
      ],
    );
  }
}
