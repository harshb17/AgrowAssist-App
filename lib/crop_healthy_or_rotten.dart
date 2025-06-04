import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class CropHealthyOrRottenScreen extends StatefulWidget {
  const CropHealthyOrRottenScreen({Key? key}) : super(key: key);

  @override
  State<CropHealthyOrRottenScreen> createState() =>
      _CropHealthyOrRottenScreenState();
}

class _CropHealthyOrRottenScreenState extends State<CropHealthyOrRottenScreen> {
  File? _image;
  bool _isLoading = false;
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();
  String _predictedClass = '';
  double _confidence = 0.0;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      final options = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset(
        'assets/fruit_vegetable_healty_classifier.tflite',
        options: options,
      );
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final String data = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/class_names.txt');
      setState(() {
        _labels = data.split('\n').where((label) => label.isNotEmpty).toList();
      });
      print('Labels loaded: ${_labels.length}');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  void _resetFields() {
    setState(() {
      _image = null;
      _predictedClass = '';
      _confidence = 0.0;
    });
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _classifyCrop();
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _classifyCrop() async {
    if (_image == null || _interpreter == null || _labels.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final imageBytes = await _image!.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Failed to decode image');

      final resizedImage = img.copyResize(image, width: 224, height: 224);

      var inputBuffer = Float32List(1 * 224 * 224 * 3);
      int pixelIndex = 0;
      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          inputBuffer[pixelIndex++] = pixel.r / 255.0;
          inputBuffer[pixelIndex++] = pixel.g / 255.0;
          inputBuffer[pixelIndex++] = pixel.b / 255.0;
        }
      }

      var outputBuffer = List<double>.filled(
        _labels.length,
        0,
      ).reshape([1, _labels.length]);
      _interpreter!.run(inputBuffer.reshape([1, 224, 224, 3]), outputBuffer);

      final predictions = outputBuffer[0];
      List<MapEntry<String, double>> results = [];
      for (int i = 0; i < predictions.length; i++) {
        results.add(MapEntry(_labels[i], predictions[i]));
      }
      results.sort((a, b) => b.value.compareTo(a.value));
      final topResult = results.first;

      setState(() {
        if (topResult.value * 100 < 50) {
          _predictedClass =
              "We don't have this fruit in our data or the image is unclear.";
          _confidence = topResult.value * 100;
        } else {
          _predictedClass = topResult.key;
          _confidence = topResult.value * 100;
        }
        _isLoading = false;
      });

      print(
        "Top prediction: ${topResult.key}: ${(topResult.value * 100).toStringAsFixed(2)}%",
      );
    } catch (e) {
      print('Error during classification: $e');
      setState(() {
        _isLoading = false;
        _predictedClass = "Error classifying crop";
        _confidence = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F9F5),
        surfaceTintColor: const Color(0xFFF3F9F5),
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Fruit Health Classifier',
            style: TextStyle(
              color: Color(0xFF52B788),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF52B788),
              decorationThickness: 2,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[600]!, width: 1),
                  ),
                  child:
                      _image == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                size: 64,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add photo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                    ),
                    child: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                    ),
                    child: const Text(
                      'Gallery',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _resetFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200],
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Classification: ${_predictedClass.isEmpty ? "" : _predictedClass}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (_confidence > 0)
                      Text(
                        'Confidence: ${_confidence.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _confidence > 80
                                  ? Colors.green[800]
                                  : _confidence > 60
                                  ? Colors.amber[800]
                                  : Colors.red[800],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      _predictedClass.contains('Healthy')
                          ? 'The crop appears to be healthy.'
                          : _predictedClass.contains('Rotten')
                          ? 'The crop appears to be rotten or diseased.'
                          : 'Description',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
