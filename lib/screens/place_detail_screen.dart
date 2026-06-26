import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 26, 36),
      appBar: AppBar(
        title: Text(place.title),
        backgroundColor: const Color.fromARGB(255, 45, 39, 54),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white24, height: 1.0),
        ),
      ),
      body: Stack(
        children: [
          // 1. High-resolution background display fitting the upper screen space
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Translucent information overlay alignment anchor card at the bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: .85),
                    Colors.black.withValues(alpha: .70),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .3),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Material(
                  //   color: Colors.transparent,
                  //   shape: const CircleBorder(),
                  //   clipBehavior: Clip.antiAlias,
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (_) => MapScreen(
                  //             isSelecting: false,
                  //             location: place.location,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     child: SizedBox(
                  //       width: 140,
                  //       height: 140,
                  //       child: ClipOval(
                  //         child: FlutterMap(
                  //           // map...
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      //print( 'Map tapped successfully!', ); // 👈 Test log to verify execution
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            isSelecting:
                                false, // 🟢 Opens map in a read-only, non-draggable viewer state
                            location: place.location,
                          ),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: SizedBox(
                        width: 140,
                        height: 140,

                        child: AbsorbPointer(
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                place.location.latitude,
                                place.location.longitude,
                              ),
                              initialZoom: 16,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag
                                    .none, // 🔒 Lock interactive panning on the preview card
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.example.favorite_places',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      place.location.latitude,
                                      place.location.longitude,
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          place.location.address ?? 'No address found',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Text(
                      //   'Location Coordinates',
                      //   style: Theme.of(context).textTheme.titleMedium!
                      //       .copyWith(color: Colors.white, letterSpacing: 1.2),
                      // ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white24,
                    height: 20,
                    thickness: 1,
                  ),

                  // 3. Structured text elements displaying non-truncated precise numbers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'LATITUDE',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place.location.latitude.toStringAsFixed(6),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 30, color: Colors.white12),
                      Column(
                        children: [
                          const Text(
                            'LONGITUDE',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place.location.longitude.toStringAsFixed(6),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
