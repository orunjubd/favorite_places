import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';

// 1.Specify both the Notifier type AND the State Type inside the angle brackets
// -- Global access pointer linking your widgets to this specific state pipeline
final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  () {
    return UserPlacesNotifier();
  },
);

// 2. Add <List<Place>> right here so Dart knows exactly what data this class manages
// State container managing your array memory list of favorite places
class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return const []; // App starts with a clean, empty places array layout
  }

  // 3. Receives both title text string AND image file directly from input forms
  // UPDATED: Now receives the custom PlaceLocation object from the form screen
  void addPlace(String title, File image, PlaceLocation location) {
    final newPlace = Place(title: title, image: image, location: location);

    // 4. "state" variable is now recognized automatically by the framework
    // -- Immutably update state by spreading the current list and adding the new item
    state = [...state, newPlace];
    //state = state..addAll(newPlace);
    //
  }
}
