import 'package:flutter/material.dart';
import 'package:flutter_great_places/providers/great_places.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Go to 'Add Place' page.
              Navigator.of(context).pushNamed('/add-place');
            },
          ),
        ],
      ),
      body: Consumer<GreatPlaces>(
        child: Center(child: const Text('No places yet! Add some!')),
        builder: (context, value, child) => value.items.isEmpty
            ? child!
            : ListView.builder(
                itemCount: value.items.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(value.items[index].image),
                  ),
                  title: Text(value.items[index].title),
                  onTap: () {
                    // Go to 'Place Detail' page.
                    Navigator.of(context).pushNamed('/place-detail',
                        arguments: value.items[index].id);
                  },
                ),
              ),
      ),
    );
  }
}
