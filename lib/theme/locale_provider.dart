import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');

  // Available languages
  final Map<String, Locale> _supportedLocales = {
    'English': const Locale('en', 'US'),
    'Hindi': const Locale('hi', 'IN'),
    'Marathi': const Locale('mr', 'IN'),
    'Gujarati': const Locale('gu', 'IN'),
  };

  // Key for storing in SharedPreferences
  static const String _localeKey = 'locale';

  LocaleProvider() {
    _loadLocale();
  }

  Locale get locale => _locale;
  Map<String, Locale> get supportedLocales => _supportedLocales;

  String get currentLanguage {
    for (final entry in _supportedLocales.entries) {
      if (entry.value.languageCode == _locale.languageCode) {
        return entry.key;
      }
    }
    return 'English'; // Default fallback
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeString = prefs.getString(_localeKey);

      if (localeString != null) {
        // Extract language and country codes
        final parts = localeString.split('_');
        if (parts.length == 2) {
          _locale = Locale(parts[0], parts[1]);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading locale: $e');
    }
  }

  Future<void> setLocale(String language) async {
    if (!_supportedLocales.containsKey(language)) return;

    final newLocale = _supportedLocales[language]!;
    if (_locale == newLocale) return;

    _locale = newLocale;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localeKey,
        '${_locale.languageCode}_${_locale.countryCode}',
      );
    } catch (e) {
      print('Error saving locale: $e');
    }

    notifyListeners();
  }
}
