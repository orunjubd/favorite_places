import 'package:flutter/material.dart';
import 'package:favorite_places/features/places/models/place.dart';
import 'package:favorite_places/features/places/screens/place_detail_screen.dart';

class FavoritePlaceList extends StatelessWidget {
  const FavoritePlaceList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    // 1. If no items exist in our array, show a placeholder message
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }
    // 2. Build the scrolling vertical list when items are available
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        // 3. Clean, direct FileImage assignment with zero null-safety errors!
        leading: CircleAvatar(
          radius: 26,
          // -- If the image exists, use it. If it is null, fallback to null
          backgroundImage: FileImage(places[index].image),
          // -- Optional: Show a default icon placeholder if there is no image
          // child: places[index].image == null ? const Icon(Icons.place) : null,
        ),
        title: Text(
          places[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          places[index].location.address ??
              'Lat: ${places[index].location.latitude.toStringAsFixed(4)}, Long: ${places[index].location.longitude.toStringAsFixed(4)}',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        // 4. Navigates cleanly into details layout view when item is tapped
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => PlaceDetailScreen(place: places[index]),
          ),
        ),
      ),
    );
  }
}
