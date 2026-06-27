import 'dart:io';

//import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:favorite_places/helpers/db_helper.dart';
import 'package:favorite_places/models/place.dart';

final userPlacesProvider = NotifierProvider<UserPlacesNotifier, List<Place>>(
  UserPlacesNotifier.new,
);

class UserPlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  Future<void> loadPlaces() async {
    state = await DBHelper.getPlaces();
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    final filename = path.basename(image.path);

    final savedImage = await image.copy(path.join(appDir.path, filename));

    final newPlace = Place(title: title, image: savedImage, location: location);

    await DBHelper.insertPlace(newPlace);

    state = [...state, newPlace];
  }
}
