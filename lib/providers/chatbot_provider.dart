import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/gemini_service.dart';

class ChatbotProvider with ChangeNotifier {
  String _apiKey = '';
  bool _isOnlineMode = true;
  late GeminiService _geminiService;

  ChatbotProvider() {
    _loadSettings();
    _geminiService = GeminiService(_apiKey);
  }

  String get apiKey => _apiKey;
  bool get isOnlineMode => _isOnlineMode;

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Only load online/offline preference from SharedPreferences
      _isOnlineMode = prefs.getBool('chatbot_online_mode') ?? true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading chatbot settings: $e');
      }
    }
  }

  // Toggle online mode
  Future<void> toggleOnlineMode() async {
    _isOnlineMode = !_isOnlineMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('chatbot_online_mode', _isOnlineMode);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving online mode: $e');
      }
    }

    notifyListeners();
  }

  // Set online mode
  Future<void> setOnlineMode(bool isOnline) async {
    if (_isOnlineMode != isOnline) {
      _isOnlineMode = isOnline;

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('chatbot_online_mode', _isOnlineMode);
      } catch (e) {
        if (kDebugMode) {
          print('Error saving online mode: $e');
        }
      }

      notifyListeners();
    }
  }

  // Get response from either Gemini API or offline database
  Future<String> getGeminiResponse(String prompt) async {
    // Special handling for sensitive topics in both modes
    final lowerPrompt = prompt.toLowerCase();
    if (lowerPrompt.contains('suicide') ||
        lowerPrompt.contains('kill myself') ||
        lowerPrompt.contains('die') && lowerPrompt.contains('want to')) {
      return _geminiService.getOfflineResponse(prompt);
    }

    if (!_isOnlineMode) {
      // If offline mode, use the offline response directly
      return _geminiService.getOfflineResponse(prompt);
    }

    try {
      // Use the full Gemini API implementation with a timeout
      final response = await _geminiService
          .getResponse(prompt)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => _geminiService.getOfflineResponse(prompt),
          );

      // If response looks like the default offline response, that means the API call failed
      if (response.contains(
        "I can provide information about many farming topics",
      )) {
        if (kDebugMode) {
          print('API call failed or returned offline response');
        }
        // Toggle to offline mode automatically after multiple failures
        setOnlineMode(false);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error in getGeminiResponse: $e');
      }
      return _geminiService.getOfflineResponse(prompt);
    }
  }
}
