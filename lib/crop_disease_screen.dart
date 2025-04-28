// crop_disease_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:image/image.dart' as img;
import 'dart:math' show max;

class CropDiseaseScreen extends StatefulWidget {
  const CropDiseaseScreen({Key? key}) : super(key: key);

  @override
  State<CropDiseaseScreen> createState() => _CropDiseaseScreenState();
}

class _CropDiseaseScreenState extends State<CropDiseaseScreen> {
  File? _image;
  Map<String, dynamic>? _diseaseData;
  bool _isLoading = false;
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();
  String _predictedDisease = '';
  String _diseaseDescription = '';
  List<String> _symptoms = [];
  List<String> _solutions = [];
  List<String> _preventiveMeasures = [];
  double _confidence = 0.0;

  final List<String> _labels = [
    'Apple___Apple_scab',
    'Apple___Black_rot',
    'Apple___Cedar_apple_rust',
    'Apple___healthy',
    'Background_without_leaves',
    'Blueberry___healthy',
    'Cherry___Powdery_mildew',
    'Cherry___healthy',
    'Corn___Cercospora_leaf_spot Gray_leaf_spot',
    'Corn___Common_rust',
    'Corn___Northern_Leaf_Blight',
    'Corn___healthy',
    'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
    'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)',
    'Peach___Bacterial_spot',
    'Peach___healthy',
    'Pepper,_bell___Bacterial_spot',
    'Pepper,_bell___healthy',
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
    'Raspberry___healthy',
    'Soybean___healthy',
    'Squash___Powdery_mildew',
    'Strawberry___Leaf_scorch',
    'Strawberry___healthy',
    'Tomato___Bacterial_spot',
    'Tomato___Early_blight',
    'Tomato___Late_blight',
    'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot',
    'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy',
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadDiseaseData();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/plant_disease_model.tflite',
      );

      print("✅ Disease model loaded successfully");
    } catch (e) {
      print("❌ Disease model failed to load");
      print(e);
    }
  }

  Future<void> _loadDiseaseData() async {
    try {
      final String data = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/disease_data.json');

      setState(() {
        _diseaseData = json.decode(data);
      });

      print("✅ Disease JSON loaded");
    } catch (e) {
      print("❌ Disease JSON failed");
      print(e);
    }
  }

  void _resetFields() {
    setState(() {
      _image = null;
      _predictedDisease = '';
      _diseaseDescription = '';
      _symptoms = [];
      _solutions = [];
      _preventiveMeasures = [];
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
    print("Opening: $source");

    final XFile? pickedFile = await _picker.pickImage(source: source);

    print("Picked: ${pickedFile?.path}");

    if (pickedFile == null) {
      print("No image selected");
      return;
    }

    _image = File(pickedFile.path);

    print("File exists: ${await _image!.exists()}");

    setState(() {});

    print("Calling detect...");
    await _detectDisease();
  }

  Future<void> _detectDisease() async {
    print("===== DETECT STARTED =====");
    if (_image == null || _interpreter == null || _diseaseData == null) return;
    setState(() => _isLoading = true);

    try {
      final imageBytes = await _image!.readAsBytes();

      print("Bytes: ${imageBytes.length}");

      final image = img.decodeImage(imageBytes);

      print("Decoded image: $image");
      final resizedImage = img.copyResize(image!, width: 224, height: 224);

      var input = List<double>.filled(224 * 224 * 3, 0);
      var pixelIndex = 0;
      for (var y = 0; y < 224; y++) {
        for (var x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = pixel.r / 255.0;
          input[pixelIndex++] = pixel.g / 255.0;
          input[pixelIndex++] = pixel.b / 255.0;
        }
      }

      var reshapedInput = input.reshape([1, 224, 224, 3]);
      print("✅ Input prepared");
      print("Input length: ${input.length}");
      var outputArray = List<List<double>>.filled(
        1,
        List<double>.filled(_labels.length, 0),
      );
      print("🚀 Running model...");
      _interpreter!.run(reshapedInput, outputArray);
      print("✅ Model finished");
      print(outputArray);

      final predictions = outputArray[0];
      final maxIndex = predictions.indexOf(predictions.reduce(max));
      final confidence = predictions[maxIndex] * 100;

      print("Max Index: $maxIndex");
      print("Label: ${_labels[maxIndex]}");
      print("Confidence: $confidence");

      setState(() {
        _confidence = confidence; // Store the confidence value

        if (confidence > 20) {
          print("Confidence above threshold");
          final diseaseKey = _labels[maxIndex];
          if (_diseaseData!.containsKey(diseaseKey)) {
            final diseaseInfo = _diseaseData![diseaseKey];
            _predictedDisease = diseaseKey;
            _diseaseDescription = diseaseInfo['description'] ?? '';
            _symptoms = List<String>.from(diseaseInfo['symptoms'] ?? []);
            _solutions = List<String>.from(diseaseInfo['solutions'] ?? []);
            _preventiveMeasures = List<String>.from(
              diseaseInfo['preventive_measures'] ?? [],
            );
          } else {
            print("Disease key not found in JSON");
            _resetFields();
          }
        } else {
          print("Confidence below threshold");
          _resetFields();
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error during prediction: $e');
      setState(() => _isLoading = false);
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
            'Crop Disease Detection',
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
                                'tap to add photo',
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'camera',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'gallery',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _resetFields,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'reset',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!, width: 1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disease: ${_predictedDisease.replaceAll('___', ' ').replaceAll('_', ' ')}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 0, 0, 0),
                        ),
                      ),
                      if (_confidence > 0)
                        Text(
                          'Confidence: ${_confidence.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        'Description: $_diseaseDescription',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xDD094900),
                          height: 1.5,
                        ),
                      ),
                      if (_symptoms.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Symptoms:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xDD094900),
                          ),
                        ),
                        ..._symptoms.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              '• $s',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_solutions.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Solutions:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xDD094900),
                          ),
                        ),
                        ..._solutions.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              '• $s',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_preventiveMeasures.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Preventive Measures:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xDD094900),
                          ),
                        ),
                        ..._preventiveMeasures.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              '• $s',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
