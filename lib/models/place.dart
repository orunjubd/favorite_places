import 'dart:io';

//import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// =========================================
// creating a clean DATA Object with a unique ID for each new place
// Generates a random, universally unique ID string for each place
// ========================================
const uuid = Uuid();

// 1. ADDED: Structural sub-model to securely hold GPS coordinate data
class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address, // Optional placeholder for future reverse-geocoding street text
  });

  final double latitude;
  final double longitude;
  final String? address;
}

class Place {
  // 1. Made "image" required so every favorite place must have a picture attached
  Place({
    required this.title,
    required this.image, // 👈 Required field for Milestone 1
    // Provide a default fallback value if location is completely missing
    this.location = const PlaceLocation(latitude: 0.0, longitude: 0.0),
  }) : id = uuid.v4();
  final String id;
  final String title;
  // 2. Removed the "?" so this property is securely Non-Nullable
  final File image;
  final PlaceLocation
  location; // 3. ADDED: Non-nullable location layout mapping
}
