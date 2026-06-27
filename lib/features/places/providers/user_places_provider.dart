import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:favorite_places/features/places/models/place.dart';
import 'package:favorite_places/features/places/repository/place_repository.dart';

final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  UserPlacesNotifier.new,
);

class UserPlacesNotifier extends Notifier<List<Place>> {
  // Initialize your clean backend repository buffer
  final PlaceRepository _repository = PlaceRepository();

  @override
  List<Place> build() {
    return [];
  }

  Future<void> loadPlaces() async {
    try {
      final places = await _repository.fetchPlaces();
      state = places;
    } catch (error) {
      debugPrint('Failed to load places state mapping inside provider: $error');
      rethrow;
    }
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    try {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final filename = path.basename(image.path);
      final savedImage = await image.copy(path.join(appDir.path, filename));

      // 🟢 ✅ STEP 2: Simply forward parameters directly down to your master Repository
      final completedPlace = await _repository.createAndSavePlace(
        title: title,
        imageFile: savedImage,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      // Immutably refresh your active UI array list state view frame matching your storage disks
      state = [...state, completedPlace];
    } catch (error) {
      debugPrint(
        'Failed to process addPlace state loop pipeline inside provider: $error',
      );
      rethrow;
    }
  }
}
