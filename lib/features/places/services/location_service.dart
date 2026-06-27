import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class LocationService {
  /// Converts Latitude and Longitude numbers into real Bengali street address strings using OSM Nominatim.
  Future<String> getReadableAddress(double lat, double lon) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1&namedetails=1&extratags=1&accept-language=bn',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'FavoritePlaces/1.0 (orunjubd@gmail.com)',
          'Accept-Language': 'bn',
          'Accept': 'application/json',
          'From': 'orunjubd@gmail.com',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['display_name'] ?? 'Unknown Location';
      }

      throw Exception('Server returned ${response.statusCode}');
    } catch (e) {
      debugPrint('OSM Reverse Geocoding failed: $e');
    }
    return 'Coordinates Set'; // Fallback text string if requests timeout
  }
}
