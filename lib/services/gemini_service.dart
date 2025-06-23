import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey;
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  final String _model = 'gemini-pro';
  final int _maxRetries = 2;

  GeminiService(this._apiKey);

  // Generate a response using Gemini API through direct HTTP request
  Future<String> getResponse(String prompt) async {
    if (prompt.trim().isEmpty) {
      return "I didn't receive a question. What would you like to know about farming?";
    }

    int retryCount = 0;
    Exception? lastException;

    while (retryCount <= _maxRetries) {
      try {
        final url = '$_baseUrl/models/$_model:generateContent?key=$_apiKey';

        // Create a context for the farming app to help Gemini understand the domain
        final fullPrompt = '''
You are an expert agricultural assistant for Indian farmers. 
You provide comprehensive, helpful, and practical information about all aspects of farming in India including:
- Crop recommendations, disease detection, and general agricultural advice
- Current farming news, trends, and market prices 
- Government schemes and subsidies for farmers
- Weather patterns and climate-adaptive farming
- Cutting-edge farming techniques and innovations
- Traditional and modern farming practices
- Farm equipment and technology
- Soil health, fertilizers, and pest management
- Sustainable and organic farming methods
- Agricultural economics and marketing strategies
- Water conservation and irrigation techniques
- Seasonal crop planning
- Solutions to common farming problems

You are also knowledgeable about the AgrowAssist app features, which include crop disease detection, crop recommendation, crop health analysis, and information services.

Keep your responses concise but comprehensive, using simple language that farmers can easily understand. Provide detailed, actionable information whenever possible.

Address the user with respect and provide useful information that can help them with their farming needs.

Please respond to the following question or statement:
$prompt
''';

        // Prepare request body
        final requestBody = jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': fullPrompt},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 800},
        });

        // Make HTTP POST request with timeout
        final response = await http
            .post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: requestBody,
            )
            .timeout(
              const Duration(seconds: 20),
              onTimeout: () {
                throw TimeoutException('Request timeout after 20 seconds');
              },
            );

        if (response.statusCode == 200) {
          return _parseResponseText(response.body, prompt);
        } else if (response.statusCode == 429 || response.statusCode >= 500) {
          // Rate limiting or server error - retry after delay
          if (retryCount < _maxRetries) {
            debugPrint(
              'Temporary API error (${response.statusCode}), retrying in ${(retryCount + 1) * 2} seconds...',
            );
            await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
            retryCount++;
            continue;
          } else {
            debugPrint(
              'API Error after retries: ${response.statusCode} - ${response.body}',
            );
            return getOfflineResponse(prompt);
          }
        } else {
          debugPrint('API Error: ${response.statusCode} - ${response.body}');
          return getOfflineResponse(prompt);
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        if (e is TimeoutException || e.toString().contains('Socket')) {
          // Network or timeout error - retry
          if (retryCount < _maxRetries) {
            debugPrint(
              'Network error, retrying (${retryCount + 1}/$_maxRetries): $e',
            );
            await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
            retryCount++;
            continue;
          }
        }

        debugPrint('Error generating Gemini response: $e');
        break;
      }
    }

    debugPrint('Failed after $_maxRetries retries. Last error: $lastException');
    return getOfflineResponse(prompt);
  }

  // Helper method to parse response text with error handling
  String _parseResponseText(String responseBody, String originalPrompt) {
    try {
      final jsonResponse = jsonDecode(responseBody);

      // Extract the text from the response with careful null checking
      if (jsonResponse is Map &&
          jsonResponse.containsKey('candidates') &&
          jsonResponse['candidates'] is List &&
          jsonResponse['candidates'].isNotEmpty) {
        final candidate = jsonResponse['candidates'][0];
        if (candidate is Map &&
            candidate.containsKey('content') &&
            candidate['content'] is Map &&
            candidate['content'].containsKey('parts') &&
            candidate['content']['parts'] is List &&
            candidate['content']['parts'].isNotEmpty) {
          final part = candidate['content']['parts'][0];
          if (part is Map &&
              part.containsKey('text') &&
              part['text'] is String) {
            final text = part['text'].trim();
            if (text.isNotEmpty) {
              return text;
            }
          }
        }
      }

      // If we got here, something was wrong with the response format
      debugPrint('Invalid response format: $responseBody');
      return getOfflineResponse(originalPrompt);
    } catch (e) {
      debugPrint('Error parsing Gemini response: $e');
      return getOfflineResponse(originalPrompt);
    }
  }

  // Return offline response based on keywords in the user's prompt
  String getOfflineResponse(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    // Check for sensitive mental health keywords first
    if (lowerPrompt.contains('suicide') ||
        lowerPrompt.contains('kill myself') ||
        lowerPrompt.contains('die') && lowerPrompt.contains('want to')) {
      return "I understand farming can be stressful, and mental health is important. If you're feeling distressed, please talk to someone who can help. India has a toll-free mental health helpline: 1800-599-0019. There are also community resources through Kisan Call Centers at 1800-180-1551 that can provide agricultural support.";
    }

    // Check for "help" command first
    if (lowerPrompt == "help" ||
        lowerPrompt.contains("what can you do") ||
        lowerPrompt.contains("what do you know") ||
        lowerPrompt.contains("topics")) {
      return "I can provide information on: soil types, crop rotation, fertilizers, organic farming, mental health, kharif crops, rabi crops, water conservation, pest management, rice cultivation, wheat cultivation, sustainable farming, climate change, government schemes, seeds, irrigation, marketing, organic pesticides, crop insurance, vermicomposting, millet cultivation, greenhouse farming, polyhouse, soil health card, zero budget farming, farming innovations, market prices, farming news, agricultural equipment, crop diseases, and much more. Just ask about any farming topic!";
    }

    // Keywords mapping for common topics
    final keywordMap = {
      'app': [
        'app',
        'agroassist',
        'agrowassist',
        'features',
        'this app',
        'application',
      ],
      'news': ['news', 'recent', 'latest', 'current', 'development', 'update'],
      'prices': ['price', 'market', 'cost', 'rate', 'mandi', 'sell', 'buying'],
      'problems': [
        'problem',
        'issue',
        'challenge',
        'difficulty',
        'trouble',
        'obstacle',
      ],
      'hacks': [
        'hack',
        'trick',
        'tip',
        'technique',
        'idea',
        'smart',
        'innovative',
      ],
      'innovations': [
        'innovation',
        'technology',
        'tech',
        'modern',
        'advance',
        'new method',
      ],
      'equipment': [
        'equipment',
        'machine',
        'tool',
        'implement',
        'device',
        'tractor',
      ],
      'diseases': [
        'disease',
        'pest',
        'infection',
        'fungus',
        'virus',
        'bacteria',
        'rot',
        'damaged',
      ],
      'organic_farming': [
        'organic',
        'natural',
        'chemical-free',
        'pesticide-free',
      ],
      'soil_types': ['soil', 'earth', 'ground', 'land'],
      'crop_rotation': ['rotation', 'crop cycle', 'sequence'],
      'irrigation': ['irrigation', 'water', 'watering', 'drip', 'sprinkler'],
      'fertilizer': [
        'fertilizer',
        'nutrient',
        'manure',
        'compost',
        'neem cake',
      ],
      'marketing': ['market', 'sell', 'selling', 'buying', 'trader', 'mandi'],
      'sustainable_farming': ['sustainable', 'ecology', 'eco-friendly'],
      'zero_budget_farming': ['zero budget', 'zbnf', 'no cost', 'low cost'],
      'loans': ['loan', 'credit', 'finance', 'funding', 'money', 'bank'],
      'insurance': ['insurance', 'cover', 'risk', 'protection', 'claim'],
      'cultivation': ['grow', 'plant', 'cultivate', 'sow', 'harvest'],
    };

    // Check for keyword matches
    for (var key in keywordMap.keys) {
      for (var keyword in keywordMap[key]!) {
        if (lowerPrompt.contains(keyword)) {
          // Handle special cases for cultivation
          if (key == 'cultivation') {
            if (lowerPrompt.contains('rice'))
              return "Rice cultivation in India requires proper land preparation, quality seeds, water management, nutrient management, and pest control. Puddling is important for water retention.";
            if (lowerPrompt.contains('wheat'))
              return "Wheat cultivation in India typically occurs in the rabi season. It requires well-drained loamy soil, moderate temperature (12-25°C), and 50-75 cm annual rainfall.";
            if (lowerPrompt.contains('millet'))
              return "Millets are nutritious, drought-resistant crops ideal for arid regions of India. They require minimal inputs and can be grown in poor soil conditions. Popular varieties include ragi (finger millet), jowar (sorghum), and bajra (pearl millet).";
          }

          // Check offline data for direct matches to the keyword category
          return _getOfflineDataResponse(key);
        }
      }
    }

    // If we get here, try direct matching with offline data
    return _getOfflineDataResponse(lowerPrompt);
  }

  // Helper method to get response from offline data by key
  String _getOfflineDataResponse(String query) {
    try {
      // Try to load from asset (should be pre-loaded but just in case)
      final Map<String, dynamic> offlineData = {
        "questions": {
          "about_app":
              "AgrowAssist is an AI-powered app designed to help Indian farmers with crop recommendations, disease detection, and farming advice. It features crop disease detection using your camera, personalized crop recommendations based on soil and climate data, and a knowledge base of agricultural information.",
          "app_features":
              "AgrowAssist offers several key features: 1) Crop Disease Detection - analyze plant photos to identify diseases, 2) Crop Recommendation - suggests suitable crops based on soil data, 3) Crop Health Analysis - determines if produce is healthy or rotten, 4) Agricultural Information - provides farming knowledge and advice, and 5) Offline Mode - works without internet connection.",
          "farming_news":
              "Recent farming developments in India include: implementation of new agricultural reforms, expansion of micro-irrigation projects, advancements in climate-resistant crop varieties, increased focus on organic farming, and the development of digital platforms connecting farmers directly to markets. For the latest news, check agricultural websites like IARI or Krishi Vigyan Kendra.",
          "market_prices":
              "Current agricultural market prices vary by region and season. Key staples like rice average ₹1800-2400/quintal, wheat ₹1900-2300/quintal, and pulses ₹4500-7000/quintal. Vegetables and fruits have greater price fluctuation. For current prices in your area, check the government's Agmarknet portal or local APMC market rates.",
          "farming_problems":
              "Major challenges facing Indian farmers include: unpredictable weather patterns, water scarcity, soil degradation, limited access to credit, fragmented landholdings, post-harvest losses, price volatility, pest resistance, high input costs, and limited market access. Government schemes and modern farming techniques can help address many of these issues.",
        },
      };

      final questions = offlineData["questions"] as Map<String, dynamic>;

      // Try exact matches first
      for (var key in questions.keys) {
        if (query.contains(key) || key.contains(query)) {
          return questions[key];
        }
      }

      // If no match, return default response
      return "I can provide information about many farming topics like crop rotation, organic farming, soil types, crop diseases, government schemes, irrigation, and more. Please try asking a specific question about farming practices, or type 'help' to see common topics.";
    } catch (e) {
      debugPrint('Error getting offline response: $e');
      return "I can provide information about many farming topics like crop rotation, organic farming, soil types, crop diseases, government schemes, irrigation, and more. Please try asking a specific question about farming practices, or type 'help' to see common topics.";
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
