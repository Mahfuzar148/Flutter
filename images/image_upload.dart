import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  //now we pick the image from gallery
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to pick image: $e"),
        ),
      );
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().microsecondsSinceEpoch}.png");

      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            content: Text("Image uploaded successfully"),
          ),
        );
      });

      imageUrl = await reference.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to upload image: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the device dimensions
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            // First, we design a simple UI
            children: [
              //---Profile picture start here---
              Stack(
                alignment: Alignment.center, // Center aligns the CircleAvatar
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundColor:
                        Colors.white, // Background color for visibility
                    child: imageUrl != null
                        ? ClipOval(
                            // This ensures the image is cropped into a circle
                            child: Image.network(
                              imageUrl!,
                              fit: BoxFit
                                  .cover, // Ensures the image covers the entire CircleAvatar
                              width: 100, // Match the size of CircleAvatar
                              height: 100, // Match the size of CircleAvatar
                            ),
                          )
                        : const Icon(Icons.person,
                            size: 100,
                            color: Colors.blue), // Default icon when no image
                  ),
                  Positioned(
                    right: deviceWidth * 0.20, // Responsive positioning
                    top: deviceHeight * 0.05, // Responsive positioning
                    child: GestureDetector(
                      onTap: () {
                        pickImage(); // Call the function to pick an image
                      },
                      child: const Icon(Icons.camera_alt,
                          size: 30, color: Colors.white),
                    ),
                  ),
                ],
              ),
              //---Profile picture end here---
              const SizedBox(height: 20),
              //---Name Field start here---
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User name',
                  hintText: 'Enter your name',
                  suffixIcon: Icon(Icons.person),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white, // Background color
                  filled: true, //
                ),
              ),
              //---Name Field end here---

              // ---password field start here---
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: Icon(Icons.lock),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white, // Background color
                  filled: true, //
                ),
              ),
              // ---password field end here---
            ],
          ),
        ),
      ),
    );
  }
}
