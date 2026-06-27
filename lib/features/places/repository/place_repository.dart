import 'package:favorite_places/features/places/models/place.dart';
import 'package:favorite_places/features/places/helpers/db_helper.dart';
import 'package:favorite_places/features/places/services/location_service.dart'; // 👈 Import service here

class PlaceRepository {
  // Instantiate your location tracking service module inside the data boundary
  final LocationService _locationService = LocationService();

  /// Fetches all stored places directly as a list of Place objects from SQLite.
  Future<List<Place>> fetchPlaces() async {
    try {
      return await DBHelper.getPlaces();
    } catch (error) {
      throw Exception('Repository failed to fetch places data: $error');
    }
  }

  /// Master Workflow: Converts coordinates to an address via Web API,
  /// updates your data object, and saves it into your SQLite table.
  Future<Place> createAndSavePlace({
    required String title,
    required dynamic imageFile, // Expects File image element
    required double latitude,
    required double longitude,
  }) async {
    try {
      // 🟢 ✅ STEP A: Repository handles calling the remote service instead of the Provider!
      final readableAddress = await _locationService.getReadableAddress(
        latitude,
        longitude,
      );

      // STEP B: Build the clean model instance containing your fresh Bengali string address
      final newPlace = Place(
        title: title,
        image: imageFile,
        location: PlaceLocation(
          latitude: latitude,
          longitude: longitude,
          address: readableAddress, // 👈 Attached here cleanly
        ),
      );

      // STEP C: Persist your newly mapped object down to your SQLite engine table rows
      await DBHelper.insertPlace(newPlace);

      // Return the completed entity back up to your active state notifier loops
      return newPlace;
    } catch (error) {
      throw Exception(
        'Repository failed to process and persist your place entry: $error',
      );
    }
  }
}
