import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nsfw/api/api.dart';

class NSFWDetectorFile extends StatefulWidget {
  const NSFWDetectorFile({Key? key}) : super(key: key);

  @override
  State<NSFWDetectorFile> createState() => _NSFWDetectorFileState();
}

class _NSFWDetectorFileState extends State<NSFWDetectorFile> {
  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;
  bool? _isImageNSFW;
  bool _isLoading = false;
  String getText = '';

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NSFW Detector'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imageFile != null)
                  Image.file(
                    imageFile!,
                    height: 200,
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Pick an image'),
                ),
                const SizedBox(height: 16),
                if (imageFile != null)
                  ElevatedButton(
                    onPressed: () async {
                      if (imageFile != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        await APIAccess.detectNSFWFile(imageFile!)
                            .then((value) {
                          setState(() {
                            _isImageNSFW = value['unsafe'];
                            getText = (value['objects'] as List)
                                .map((e) => e['label'])
                                .toList()
                                .join(', ');
                          });
                        });
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? SizedBox(
                            height: 14,
                            width: 14,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ))
                        : const Text('Detect NSFW'),
                  ),
                // if (_isImageNSFW != null && !_isImageNSFW!)
                //   Text('This image is Safe'),
                if (_isImageNSFW ?? false)
                  Column(
                    children: [
                      const Text(
                        'The image is NSFW!',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                Text(
                    'YOu will get Information from API as you mention on my Linkedin'),
                Text(getText)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
