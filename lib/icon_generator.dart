import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const IconGeneratorApp());
}

class IconGeneratorApp extends StatelessWidget {
  const IconGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Icon Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IconGeneratorPage(),
    );
  }
}

class IconGeneratorPage extends StatefulWidget {
  const IconGeneratorPage({super.key});

  @override
  State<IconGeneratorPage> createState() => _IconGeneratorPageState();
}

class _IconGeneratorPageState extends State<IconGeneratorPage> {
  final GlobalKey _iconKey = GlobalKey();
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('College Tracker Icon Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Import Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Import Your Own Image',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _pickImageFromCamera,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Icon Preview
            Container(
              key: _iconKey,
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: kIsWeb
                          ? Image.memory(
                              _selectedImageBytes!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _selectedImage!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    )
                  : const CollegeTrackerIcon(),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'How to Use Your Custom Icon:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '1. Import an image from your gallery or camera\n'
                      '2. The image will be displayed above\n'
                      '3. Take a screenshot or save the image\n'
                      '4. Use an online tool to generate all required sizes\n'
                      '5. Replace the default icon in your iOS project',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: (_selectedImage != null || _selectedImageBytes != null) ? _resetToDefault : null,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset to Default'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _generateIcon,
                  icon: const Icon(Icons.download),
                  label: const Text('Save Icon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Icon Size Requirements
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Required Icon Sizes for iOS:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '• App Store: 1024x1024 px\n'
                      '• iPhone: 180x180 px, 120x120 px, 87x87 px, 80x80 px\n'
                      '• iPad: 167x167 px, 152x152 px, 76x76 px\n'
                      '• Settings: 58x58 px, 29x29 px\n'
                      '• Spotlight: 120x120 px, 87x87 px',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 100,
      );
      
      if (image != null) {
        if (kIsWeb) {
          // For web, read as bytes
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null;
          });
        } else {
          // For mobile, use File
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
          });
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image imported successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error importing image: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      // Request camera permission
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera permission is required'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 100,
      );
      
      if (image != null) {
        if (kIsWeb) {
          // For web, read as bytes
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null;
          });
        } else {
          // For mobile, use File
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
          });
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing image: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _resetToDefault() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reset to default graduation cap icon'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateIcon() {
    if (_selectedImage != null || _selectedImageBytes != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Take a screenshot of your custom icon above to save it!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Take a screenshot of the default icon above to save it!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

class CollegeTrackerIcon extends StatelessWidget {
  const CollegeTrackerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
          ),
          
          // Main graduation cap (larger and more prominent)
          Positioned(
            top: 25,
            child: Container(
              width: 100,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[900]!.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          
          // Cap brim (bottom part)
          Positioned(
            top: 85,
            child: Container(
              width: 110,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          // Cap tassel (more prominent)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 6,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          
          // Cap tassel ball (larger)
          Positioned(
            top: 50,
            right: 17,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.amber[600],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber[800]!.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          
          // Small graduation cap icon in bottom right (representing college search)
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),
          ),
          
          // Small cap brim
          Positioned(
            bottom: 20,
            right: 15,
            child: Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Small cap tassel
          Positioned(
            bottom: 45,
            right: 25,
            child: Container(
              width: 3,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.amber[500],
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
          
          // Small cap tassel ball
          Positioned(
            bottom: 30,
            right: 23.5,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.amber[500],
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Center accent - small graduation cap
          Positioned(
            bottom: 60,
            child: Container(
              width: 30,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.blue[500],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(3),
                ),
              ),
            ),
          ),
          
          // Center cap brim
          Positioned(
            bottom: 60,
            child: Container(
              width: 35,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
