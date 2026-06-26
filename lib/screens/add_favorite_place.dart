import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';

class AddFavoritePlace extends ConsumerStatefulWidget {
  const AddFavoritePlace({super.key});

  @override
  ConsumerState<AddFavoritePlace> createState() => _AddFavoritePlaceState();
}

class _AddFavoritePlaceState extends ConsumerState<AddFavoritePlace> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation?
  _selectedLocation; // 1. ADDED: Local state pointer for GPS coordinates

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _savePlace() {
    final title = _titleController.text;
    // 2. UPDATED: Strict validation blocking submissions missing ANY of the fields
    if (title.isEmpty || _selectedImage == null || _selectedLocation == null) {
      return;
    }
    // 3.  Sends title, file image, and GPS object payload together securely
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(title, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Customize your Top App Bar background color here
      backgroundColor: const Color.fromARGB(255, 45, 39, 54),
      appBar: AppBar(
        title: const Text(
          'Add new Place',
        ), // 3. Add a separate custom bottom underline divider using the PreferredSize property
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onSubmitted: (_) => _savePlace(),
              ),
              const SizedBox(height: 16),
              // 3. Render your local ImageInput controller
              ImageInput(
                onPickImage: (image) {
                  setState(() {
                    _selectedImage = image;
                  });
                },
              ),
              const SizedBox(height: 16),
              // 4. RE-ACTIVATED: Listens live to your coordinates callback receiver
              LocationInput(
                onSelectLocation: (location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
                onPressed: _savePlace,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Makes it a clean rounded rectangle
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
