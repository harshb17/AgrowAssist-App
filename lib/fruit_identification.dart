//CROP IDENFICATION
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class FruitIdentificationScreen extends StatefulWidget {
  const FruitIdentificationScreen({Key? key}) : super(key: key);

  @override
  State<FruitIdentificationScreen> createState() =>
      _FruitIdentificationScreenState();
}

class _FruitIdentificationScreenState extends State<FruitIdentificationScreen> {
  File? _image;
  bool _isLoading = false;
  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();
  String _predictedFruit = '';
  double _confidence = 0.0;
  List<dynamic>? _fruitData;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
    _loadFruitData();
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
        'assets/fruit_vegetable_classifier_quantized.tflite',
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
      ).loadString('assets/labels.txt');
      setState(() {
        _labels = data.split('\n').where((label) => label.isNotEmpty).toList();
      });
      print('Labels loaded: ${_labels.length}');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<void> _loadFruitData() async {
    try {
      final String data = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/fruit_data.json');
      setState(() {
        _fruitData = json.decode(data);
      });
      print('Fruit data loaded successfully');
    } catch (e) {
      print('Error loading fruit data: $e');
    }
  }

  void _resetFields() {
    setState(() {
      _image = null;
      _predictedFruit = '';
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
          _identifyFruit();
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

  Future<void> _identifyFruit() async {
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
      final topResults = results.take(5).toList();

      setState(() {
        if (topResults[0].value * 100 < 50) {
          _predictedFruit = "Low confidence prediction";
          _confidence = 0.0;
        } else {
          _predictedFruit = topResults[0].key;
          _confidence = topResults[0].value * 100;
        }
        _isLoading = false;
      });

      print("Top 5 predictions:");
      for (var result in topResults) {
        print("${result.key}: ${(result.value * 100).toStringAsFixed(2)}%");
      }
    } catch (e) {
      print('Error during prediction: $e');
      setState(() {
        _isLoading = false;
        _predictedFruit = "Error identifying fruit";
        _confidence = 0.0;
      });
    }
  }

  Map<String, dynamic>? _getFruitInfo(String fruitName) {
    try {
      if (_fruitData == null) return null;

      final normalizedName = fruitName.toLowerCase().trim();

      for (var fruit in _fruitData!) {
        if (fruit['name'].toString().toLowerCase() == normalizedName) {
          return Map<String, dynamic>.from(fruit);
        }
      }
      return null;
    } catch (e) {
      print('Error getting fruit info: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? fruitInfo;
    List<String>? vitamins;

    if (_predictedFruit.isNotEmpty &&
        _predictedFruit != "Low confidence prediction" &&
        _predictedFruit != "Error identifying fruit") {
      fruitInfo = _getFruitInfo(_predictedFruit);
      if (fruitInfo != null && fruitInfo.containsKey('vitamins')) {
        vitamins = List<String>.from(fruitInfo['vitamins']);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F9F5),
        surfaceTintColor: const Color(0xFFF3F9F5),
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Fruit Identification',
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
                      _predictedFruit == "Low confidence prediction"
                          ? "We don't have this fruit in our data or the image is unclear."
                          : 'Fruit: ${_predictedFruit.isEmpty ? "" : _predictedFruit}',
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
                          color:
                              _confidence > 80
                                  ? Colors.green[800]
                                  : _confidence > 60
                                  ? Colors.amber[800]
                                  : Colors.red[800],
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (fruitInfo != null) ...[
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xDD094900),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fruitInfo['description'] ?? 'No description available',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Calories: ${fruitInfo['calories']} per 100g',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      if (vitamins != null && vitamins.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Vitamins:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xDD094900),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...vitamins.map(
                          (vitamin) => Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                            child: Text(
                              '• $vitamin',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ] else if (_predictedFruit.isEmpty) ...[
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xDD094900),
                        ),
                      ),
                    ],
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
