import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:favorite_places/features/places/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 23.7439,
      longitude: 90.4228,
    ), // Defaults to Dhaka if no position exists
    this.isSelecting =
        true, // True means we are picking a location, false means view-only
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your Place' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Return the chosen location coordinates back to the form screen
                Navigator.of(context).pop(_pickedPosition);
              },
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            if (!widget.isSelecting) return;
            setState(() {
              _pickedPosition = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.favorite_places',
          ),
          MarkerLayer(
            markers: [
              // Show a marker either where they tapped, or at the initial coordinate point
              //if (_pickedPosition != null || !widget.isSelecting)
              Marker(
                point:
                    _pickedPosition ??
                    LatLng(widget.location.latitude, widget.location.longitude),
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
