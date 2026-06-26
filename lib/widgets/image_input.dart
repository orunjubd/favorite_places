import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  // Callback function to pass the captured image back up to the parent form
  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  // Asynchronous method that opens the native device camera subsystem
  void _takePicture() async {
    final imagePicker = ImagePicker();
    try {
      // 1. Trigger camera stream interface with optimized max width to save memory
      // -- Use the imagePicker object to pick an image from the device's photo library
      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      // 2. Early return guard clause if the user leaves the camera without shooting
      if (pickedImage == null) {
        return;
      }

      // 3. Convert XFile path to a standard Dart File type and update local preview state
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      // 4. Safely broadcast the non-null file reference up to the parent widget tree
      widget.onPickImage(_selectedImage!);
    } catch (error) {
      // Catch platform-level errors or permission rejections gracefully
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not access camera: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI State A: Default placeholder when no photo has been snapped yet
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera_alt), // Swapped to a crisp fill icon
      //icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
      onPressed: _takePicture,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    // UI State B: Live image container preview replacing the trigger button
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture, // Allows user to tap the photo to take a new one!
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
      // content = Image.file(
      //   _selectedImage!,
      //   fit: BoxFit.cover,
      //   width: double.infinity,
      // );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8), // Subtle rounded corner framing
      ),
      child: content,
    );
  }
}
