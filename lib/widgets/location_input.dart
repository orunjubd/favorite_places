import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as jj;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  // 1. ADDED: Callback function to pass coordinates up to your main entry form
  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // ✅ FIX 1: Change type from Location to LocationData
  LocationData? _pickedLocation;
  var _isGettingLocation = false;

  // void _selectOnMap() async {
  //   // 1. Open the full-screen map screen and wait for a saved position response
  //   final jj.LatLng? pickedData = await Navigator.of(
  //     context,
  //   ).push<jj.LatLng>(MaterialPageRoute(builder: (ctx) => const MapScreen()));

  //   // 2. If the user backed out without clicking save, do nothing
  //   if (pickedData == null) {
  //     return;
  //   }

  //   // 3. Update the local UI state preview box with the new map tiles
  //   setState(() {
  //     _pickedLocation = LocationData.fromMap({
  //       'latitude': pickedData.latitude,
  //       'longitude': pickedData.longitude,
  //     });
  //   });

  //   // 4. Send the data up to your parent AddPlace Form
  //   widget.onSelectLocation(
  //     PlaceLocation(
  //       latitude: pickedData.latitude,
  //       longitude: pickedData.longitude,
  //     ),
  //   );
  // }

  void _selectOnMap() async {
    // 1. Set up a starting position object
    PlaceLocation startingLocation = const PlaceLocation(
      latitude: 23.7439,
      longitude: 90.4228,
    ); // Default to Dhaka

    // 2. ✅ FIX: If you already clicked "Current Location", use those real coordinates instead of California!
    if (_pickedLocation != null) {
      startingLocation = PlaceLocation(
        latitude: _pickedLocation!.latitude!,
        longitude: _pickedLocation!.longitude!,
      );
    }

    final jj.LatLng? pickedData = await Navigator.of(context).push<jj.LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          location: startingLocation, // 👈 Pass the dynamic location here!
          isSelecting: true,
        ),
      ),
    );

    if (pickedData == null) return;

    setState(() {
      _isGettingLocation = true; // Turn on spinner while fetching text address
    });

    // 🟢 FETCH THE REAL OSM STREET ADDRESS FOR THE CHOSEN PIN TAP
    final readableAddress = await _getReadableAddress(
      pickedData.latitude,
      pickedData.longitude,
    );

    setState(() {
      _isGettingLocation = false;
      _pickedLocation = LocationData.fromMap({
        'latitude': pickedData.latitude,
        'longitude': pickedData.longitude,
      });
    });

    widget.onSelectLocation(
      PlaceLocation(
        latitude: pickedData.latitude,
        longitude: pickedData.longitude,
        address: readableAddress,
      ),
    );
  }

  // Helper method that converts Lat/Long numbers to real text address strings
  Future<String> _getReadableAddress(double lat, double lon) async {
    // OpenStreetMap Nominatim free reverse API endpoint
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&namedetails=1&extratags=1&accept-language=bn',
    );

    try {
      // Nominatim usage guidelines require a custom User-Agent identifying your application
      final response = await http.get(
        url,
        //https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&namedetails=1&extratags=1&accept-language=en
        headers: {
          'User-Agent': 'favorite_places_app_learning_project',
          'Accept-Language': 'bn',
          'Accept': 'Application/json',
          'From': 'orunjubd@gmail.com',
        },
        // params: {
        //   'format': 'json',
        //   'lat': lat.toString(),
        //   'lon': lon.toString(),
        //   'addressdetails': '1',
        //   'namedetails': '1',
        //   'extratags': '1',
        //   'accept-language': 'en',
        //   },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Extracts the full combined display address text block
        return responseData['display_name'] ?? 'Unknown Location';
      }
    } catch (e) {
      print('Geocoding failed: $e');
    }
    return 'Coordinates Set'; // Fallback if internet drops
  }

  void _getCurrentUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      setState(() {
        _isGettingLocation = true; // Turn spinner on
      });

      locationData = await location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      // 🟢 1. FETCH THE REAL OSM STREET ADDRESS TEXT FIRST
      final readableAddress = await _getReadableAddress(
        locationData.latitude!,
        locationData.longitude!,
      );

      setState(() {
        // ✅ 2. MOVED STATE UPDATES HERE: Safely update data and close spinner together
        _isGettingLocation = false;
        _pickedLocation = locationData;
      });

      // ✅ 3. FIXED CALLBACK NAME: Swapped 'onPickLocation' to 'onSelectLocation'
      widget.onSelectLocation(
        PlaceLocation(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          address: readableAddress,
        ),
      );

      //print(locationData.latitude);
      //print(locationData.longitude);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isGettingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not fetch device location coordinates: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default fallback UI state
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      // previewContent = Text(
      //   'Lat: ${_pickedLocation!.latitude}, \nLong: ${_pickedLocation!.longitude}',
      //   textAlign: TextAlign.center,
      //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
      //     color: Theme.of(context).colorScheme.onSurface,
      //   ),
      // );

      previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: jj.LatLng(
            _pickedLocation!.latitude!,
            _pickedLocation!.longitude!,
          ),
          initialZoom: 15.0, // Street-level magnification scale
        ),
        children: [
          TileLayer(
            // ✅ Fixed: Added missing forward slash after .org
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.favorite_places',
          ),
          // 📍 OPTIONAL: Add a clean visual pin marker at the exact coordinate point
          MarkerLayer(
            markers: [
              Marker(
                point: jj.LatLng(
                  _pickedLocation!.latitude!,
                  _pickedLocation!.longitude!,
                ),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Icon(Icons.location_on, color: Colors.grey),
            //Text('No location chosen', style: TextStyle(color: Colors.grey)),
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _selectOnMap,
            ),
          ],
        ),
        // Text('Current Location'),
        // Icon(Icons.location_on),
      ],
    );
  }
}
