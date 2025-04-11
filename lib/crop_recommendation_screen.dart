import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:math';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({Key? key}) : super(key: key);

  @override
  _CropRecommendationScreenState createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    7,
    (index) => TextEditingController(),
  );
  Interpreter? _interpreter;
  String _result = "Enter values and press 'Get Recommendation'";
  bool _isLoading = false;

  final List<String> inputLabels = [
    "Nitrogen (N)",
    "Phosphorus (P)",
    "Potassium (K)",
    "Temperature (°C)",
    "Humidity (%)",
    "pH",
    "Rainfall (mm)",
  ];

  final List<String> cropLabels = [
    'rice',
    'maize',
    'jute',
    'cotton',
    'coconut',
    'papaya',
    'orange',
    'apple',
    'muskmelon',
    'watermelon',
    'grapes',
    'mango',
    'banana',
    'pomegranate',
    'lentil',
    'blackgram',
    'mungbean',
    'mothbeans',
    'pigeonpeas',
    'kidneybeans',
    'chickpea',
    'coffee',
  ];

  // Min and max values from your training data for normalization
  // Replace these with the actual values from your MinMaxScaler
  final List<double> minValues = [
    0.0,
    5.0,
    5.0,
    8.825674745,
    14.27327988,
    3.504752314,
    20.36001144,
  ];
  final List<double> maxValues = [
    140.0,
    145.0,
    205.0,
    43.67549305,
    99.98187601,
    9.93509073,
    298.5601175,
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _resetForm() {
    setState(() {
      for (var controller in _controllers) {
        controller.clear();
      }
      _result = "Enter values and press 'Get Recommendation'";
    });
  }

  Future<void> _loadModel() async {
    setState(() => _isLoading = true);
    try {
      _interpreter = await Interpreter.fromAsset(
        "assets/crop_recommendation.tflite",
      );
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading model: $e')));
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String? _validateInput(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    double? number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    switch (field) {
      case "Nitrogen (N)":
        if (number < 0 || number > 140) return 'Range: 0-140';
        break;
      case "Phosphorus (P)":
        if (number < 0 || number > 145) return 'Range: 0-145';
        break;
      case "Potassium (K)":
        if (number < 0 || number > 205) return 'Range: 0-205';
        break;
      case "Temperature (°C)":
        if (number < -5 || number > 45) return 'Range: -5-45';
        break;
      case "Humidity (%)":
        if (number < 0 || number > 100) return 'Range: 0-100';
        break;
      case "pH":
        if (number < 0 || number > 14) return 'Range: 0-14';
        break;
      case "Rainfall (mm)":
        if (number < 0 || number > 300) return 'Range: 0-300';
        break;
    }
    return null;
  }

  // Normalize input before prediction
  List<double> normalizeInput(List<double> input) {
    List<double> normalized = [];
    for (int i = 0; i < input.length; i++) {
      normalized.add((input[i] - minValues[i]) / (maxValues[i] - minValues[i]));
    }
    return normalized;
  }

  Future<void> _predictCrop() async {
    if (_interpreter == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Model not loaded yet')));
      return;
    }

    bool isValid = true;

    for (int i = 0; i < _controllers.length; i++) {
      print("Field: ${inputLabels[i]}");
      print("Value: '${_controllers[i].text}'");

      String? error = _validateInput(_controllers[i].text, inputLabels[i]);

      print("Validation: $error");

      if (error != null) {
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please check all input values')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "Predicting...";
    });

    try {
      // Get raw input values
      List<double> inputList =
          _controllers.map((c) => double.parse(c.text)).toList();

      // Normalize the input values
      List<double> normalizedInput = normalizeInput(inputList);

      // Convert to Float32List for TFLite
      var input = Float32List.fromList(normalizedInput);
      var output = List.generate(1, (_) => List.filled(22, 0.0));

      // Run the model
      _interpreter!.run([input], output);

      // Debug output
      print("Raw model output: ${output[0]}");

      // Find the index with highest probability
      int predictedIndex = output[0].indexOf(output[0].reduce(max));

      setState(() {
        _result =
            (predictedIndex >= 0 && predictedIndex < cropLabels.length)
                ? "Recommended crop: ${cropLabels[predictedIndex].toUpperCase()}"
                : "Invalid Prediction";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = "Error: ${e.toString()}";
        _isLoading = false;
      });
      print("Prediction error: $e");
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
          padding: EdgeInsets.only(top: 8), // Increase to 10 or 12 if needed
          child: Text(
            'Crop Recommendation',
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

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Enter Crop Parameters',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(
                              _controllers.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: TextFormField(
                                  controller: _controllers[index],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: inputLabels[index],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorText:
                                        _controllers[index].text.isEmpty
                                            ? null
                                            : _validateInput(
                                              _controllers[index].text,
                                              inputLabels[index],
                                            ),
                                    helperText: 'Enter ${inputLabels[index]}',
                                    prefixIcon: Icon(
                                      _getIconForField(inputLabels[index]),
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150, // Fixed width for both buttons
                          child: ElevatedButton(
                            onPressed: _predictCrop,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Get Recommendation",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150, // Same width as recommend button
                          child: ElevatedButton(
                            onPressed: _resetForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Reset",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _result,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  IconData _getIconForField(String field) {
    switch (field) {
      case "Nitrogen (N)":
        return Icons.science;
      case "Phosphorus (P)":
        return Icons.science;
      case "Potassium (K)":
        return Icons.science;
      case "Temperature (°C)":
        return Icons.thermostat;
      case "Humidity (%)":
        return Icons.water_drop;
      case "pH":
        return Icons.water;
      case "Rainfall (mm)":
        return Icons.umbrella;
      default:
        return Icons.input;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _interpreter?.close();
    super.dispose();
  }
}
