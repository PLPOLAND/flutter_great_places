import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_great_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../widgets/image_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();

  File? _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          title: Text('An error occurred!'),
          content: Text('Please provide a title and an image.'),
        ),
      );
      return;
    } else {
      Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _titleController.text,
        _pickedImage!,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add Place'),
              onPressed: () {
                _savePlace();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Theme.of(context).colorScheme.secondary,
              )),
        ],
      ),
    );
  }
}
