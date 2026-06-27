import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/features/places/providers/user_places_provider.dart';
import 'package:favorite_places/features/places/screens/add_favorite_place.dart';
import 'package:favorite_places/features/places/widgets/favorite_place.dart';

class FavoritePlaceScreen extends ConsumerStatefulWidget {
  const FavoritePlaceScreen({super.key});

  @override
  ConsumerState<FavoritePlaceScreen> createState() =>
      _FavoritePlaceScreenState();
}

class _FavoritePlaceScreenState extends ConsumerState<FavoritePlaceScreen> {
  late final Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();

    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 26, 36),

      appBar: AppBar(
        title: const Text('Your Places'),

        backgroundColor: const Color.fromARGB(255, 45, 39, 54),

        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddFavoritePlace()),
              );
            },
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.white24),
        ),
      ),

      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load places.',
                //style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: FavoritePlaceList(places: userPlaces),
          );
        },
      ),
    );
  }
}
