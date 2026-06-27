import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String? address;
}

class Place {
  Place({
    required this.title,
    required this.image,
    this.location = const PlaceLocation(latitude: 0, longitude: 0),
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  /// Convert Place -> SQLite Map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image.path,
      'lat': location.latitude,
      'lng': location.longitude,
      'address': location.address,
    };
  }

  /// Convert SQLite Map -> Place
  factory Place.fromMap(Map<String, Object?> map) {
    return Place(
      id: map['id'] as String,
      title: map['title'] as String,
      image: File(map['image'] as String),
      location: PlaceLocation(
        latitude: (map['lat'] as num).toDouble(),
        longitude: (map['lng'] as num).toDouble(),
        address: map['address'] as String?,
      ),
    );
  }
}
