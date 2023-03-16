import 'package:flutter/material.dart';
import 'package:flutter_great_places/models/place.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  PlaceLocation? _pickedLocation;
  final mapController = MapController(
    initMapWithUserPosition: true,
    // initPosition:
  );

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrenUserLocation() async {
    final oldLocation = _pickedLocation;
    final locData = await Location().getLocation();
    var geopoints = await mapController.geopoints;
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: locData.latitude!,
        longitude: locData.longitude!,
      );
      if (geopoints.contains(GeoPoint(
        latitude: oldLocation!.latitude,
        longitude: oldLocation.longitude,
      ))) {
        mapController.changeLocationMarker(
          oldLocation: GeoPoint(
            latitude: oldLocation.latitude,
            longitude: oldLocation.longitude,
          ),
          newLocation: GeoPoint(
            latitude: _pickedLocation!.latitude,
            longitude: _pickedLocation!.longitude,
          ),
        );
      } else {
        mapController.addMarker(GeoPoint(
          latitude: _pickedLocation!.latitude,
          longitude: _pickedLocation!.longitude,
        ));
      }
    });
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
            child: _pickedLocation == null
                ? const Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : OSMFlutter(
                    controller: mapController,
                    // mapIsLoading: Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                    showContributorBadgeForOSM: true,
                    initZoom: 12,
                    maxZoomLevel: 13,
                    minZoomLevel: 11,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              onPressed: () {
                _getCurrenUserLocation();
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
