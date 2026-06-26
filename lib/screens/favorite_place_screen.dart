import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/widgets/favorite_place.dart';
import 'package:favorite_places/screens/add_favorite_place.dart';
import 'package:favorite_places/providers/user_places_provider.dart';

class FavoritePlaceScreen extends ConsumerWidget {
  const FavoritePlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Live listen to changes in the data array. Rebuilds UI automatically
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      // 1. Customize your main scaffold content background body color here
      backgroundColor: const Color.fromARGB(255, 30, 26, 36),

      appBar: AppBar(
        // 2. Customize your Top App Bar background color here
        backgroundColor: const Color.fromARGB(255, 45, 39, 54),
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            // 2. Navigates seamlessly over to your input form screen
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddFavoritePlace()),
              );
            },
          ),
        ],
        // 3. Add a separate custom bottom underline divider using the PreferredSize property
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            1.0,
          ), // The thickness height of your bar line
          child: Container(
            color: Colors
                .white24, // The color styling of your custom separating line
            height: 1.0,
          ),
        ),
      ),
      // 3. Passes the live data array down to the ListView builder widget
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FavoritePlaceList(places: userPlaces),
      ),
    );
  }
}
