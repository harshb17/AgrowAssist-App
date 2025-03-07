import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to get current instance from context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Add all the UI strings here
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'AgrowAssist',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'cancel': 'Cancel',
      'ok': 'OK',
      'save': 'Save',
      'notifications': 'Notifications',
      'about': 'About',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'app_version': 'App Version',
      'developer': 'Developer',

      // App Settings
      'dark_mode_enabled': 'Dark theme enabled',
      'light_mode_enabled': 'Light theme enabled',
      'enable_notifications': 'Enable Notifications',
      'receive_updates': 'Receive updates and alerts',
      'select_language': 'Select Language',
      'appearance': 'Appearance',
      'app_settings': 'App Settings',

      // Home Screen
      'agro_assistant': 'AGRO ASSISTANT',
      'key_features': 'Key Features',
      'smart_crop_recommendation': 'Smart Crop Recommendation',
      'disease_prediction': 'Disease Prediction',
      'crop_identification': 'Crop/Fruit Identification',
      'fruit_health': 'Fruit Health Classification',
      'crop_analysis': 'Crop Analysis',
      'crop_recommendation_desc':
          'Get personalized crop suggestions based on soil and climate data',
      'disease_prediction_desc':
          'Detect and identify crop diseases early for better management',
      'crop_identification_desc':
          'Instantly identify various crops and fruits from images',
      'fruit_health_desc': 'Assess the health and quality of fruits using AI',
      'crop_analysis_desc':
          'Get comprehensive insights into crop performance and health',

      // Features
      'crop_recommendation': 'Crop Recommendation',
      'crop_disease': 'Crop Disease Detection',
      'fruit_identification': 'Fruit Identification',
      'fruit_health_classifier': 'Fruit Health Classifier',
      'crop_analytics': 'Crop Analytics',

      // Crop Recommendation
      'enter_crop_parameters': 'Enter Crop Parameters',
      'nitrogen': 'Nitrogen (N)',
      'phosphorus': 'Phosphorus (P)',
      'potassium': 'Potassium (K)',
      'temperature': 'Temperature (°C)',
      'humidity': 'Humidity (%)',
      'ph': 'pH',
      'rainfall': 'Rainfall (mm)',
      'get_recommendation': 'Get Recommendation',
      'reset': 'Reset',
      'enter': 'Enter',

      // Disease Detection
      'select_image_source': 'Select Image Source',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'tap_to_add_photo': 'tap to add photo',
      'disease': 'Disease:',
      'description': 'Description:',
      'symptoms': 'Symptoms:',
      'solutions': 'Solutions:',
      'preventive_measures': 'Preventive Measures:',
      'confidence': 'Confidence:',

      // About Screen
      'about_app': 'About App',
      'fruits_vegetables': 'Fruits & Vegetables',
      'diseases': 'Diseases',
      'recommended_crops': 'Recommended Crops',
      'healthy_vs_rotten': 'Healthy vs Rotten',
    },

    'hi': {
      // Common
      'app_name': 'एग्रोअसिस्ट',
      'settings': 'सेटिंग्स',
      'dark_mode': 'डार्क मोड',
      'language': 'भाषा',
      'cancel': 'रद्द करें',
      'ok': 'ठीक है',
      'save': 'सहेजें',
      'notifications': 'सूचनाएं',
      'about': 'के बारे में',
      'privacy_policy': 'गोपनीयता नीति',
      'terms_of_service': 'सेवा की शर्तें',
      'app_version': 'ऐप संस्करण',
      'developer': 'डेवलपर',

      // App Settings
      'dark_mode_enabled': 'डार्क थीम सक्षम',
      'light_mode_enabled': 'लाइट थीम सक्षम',
      'enable_notifications': 'सूचनाएं सक्षम करें',
      'receive_updates': 'अपडेट और अलर्ट प्राप्त करें',
      'select_language': 'भाषा चुनें',
      'appearance': 'उपस्थिति',
      'app_settings': 'ऐप सेटिंग्स',

      // Home Screen
      'agro_assistant': 'कृषि सहायक',
      'key_features': 'मुख्य विशेषताएं',
      'smart_crop_recommendation': 'स्मार्ट फसल सिफारिश',
      'disease_prediction': 'रोग की भविष्यवाणी',
      'crop_identification': 'फसल/फल पहचान',
      'fruit_health': 'फल स्वास्थ्य वर्गीकरण',
      'crop_analysis': 'फसल विश्लेषण',
      'crop_recommendation_desc':
          'मिट्टी और जलवायु डेटा के आधार पर व्यक्तिगत फसल सुझाव प्राप्त करें',
      'disease_prediction_desc':
          'बेहतर प्रबंधन के लिए फसल रोगों का जल्दी पता लगाएं और पहचानें',
      'crop_identification_desc':
          'छवियों से विभिन्न फसलों और फलों की तुरंत पहचान करें',
      'fruit_health_desc':
          'AI का उपयोग करके फलों के स्वास्थ्य और गुणवत्ता का आकलन करें',
      'crop_analysis_desc':
          'फसल प्रदर्शन और स्वास्थ्य में व्यापक अंतर्दृष्टि प्राप्त करें',

      // Features
      'crop_recommendation': 'फसल सिफारिश',
      'crop_disease': 'फसल रोग पहचान',
      'fruit_identification': 'फल पहचान',
      'fruit_health_classifier': 'फल स्वास्थ्य वर्गीकरण',
      'crop_analytics': 'फसल विश्लेषण',

      // Crop Recommendation
      'enter_crop_parameters': 'फसल पैरामीटर दर्ज करें',
      'nitrogen': 'नाइट्रोजन (N)',
      'phosphorus': 'फास्फोरस (P)',
      'potassium': 'पोटेशियम (K)',
      'temperature': 'तापमान (°C)',
      'humidity': 'आर्द्रता (%)',
      'ph': 'पीएच',
      'rainfall': 'वर्षा (मिमी)',
      'get_recommendation': 'सिफारिश प्राप्त करें',
      'reset': 'रीसेट',
      'enter': 'दर्ज करें',

      // Disease Detection
      'select_image_source': 'छवि स्रोत चुनें',
      'camera': 'कैमरा',
      'gallery': 'गैलरी',
      'tap_to_add_photo': 'फोटो जोड़ने के लिए टैप करें',
      'disease': 'रोग:',
      'description': 'विवरण:',
      'symptoms': 'लक्षण:',
      'solutions': 'समाधान:',
      'preventive_measures': 'निवारक उपाय:',
      'confidence': 'विश्वास:',

      // About Screen
      'about_app': 'About App',
      'fruits_vegetables': 'Fruits & Vegetables',
      'diseases': 'Diseases',
      'recommended_crops': 'Recommended Crops',
      'healthy_vs_rotten': 'Healthy vs Rotten',
    },

    'mr': {
      // Common
      'app_name': 'अग्रोअसिस्ट',
      'settings': 'सेटिंग्ज',
      'dark_mode': 'डार्क मोड',
      'language': 'भाषा',
      'cancel': 'रद्द करा',
      'ok': 'ठीक आहे',
      'save': 'जतन करा',
      'notifications': 'सूचना',
      'about': 'बद्दल',
      'privacy_policy': 'गोपनीयता धोरण',
      'terms_of_service': 'सेवेच्या अटी',
      'app_version': 'अॅप आवृत्ती',
      'developer': 'डेव्हलपर',

      // App Settings
      'dark_mode_enabled': 'डार्क थीम सक्षम',
      'light_mode_enabled': 'लाइट थीम सक्षम',
      'enable_notifications': 'सूचना सक्षम करा',
      'receive_updates': 'अपडेट आणि अलर्ट प्राप्त करा',
      'select_language': 'भाषा निवडा',
      'appearance': 'दिसणे',
      'app_settings': 'अॅप सेटिंग्ज',

      // Home Screen
      'agro_assistant': 'कृषी सहाय्यक',
      'key_features': 'मुख्य वैशिष्ट्ये',
      'smart_crop_recommendation': 'स्मार्ट पीक शिफारस',
      'disease_prediction': 'रोग भविष्यवाणी',
      'crop_identification': 'पीक/फळ ओळख',
      'fruit_health': 'फळ आरोग्य वर्गीकरण',
      'crop_analysis': 'पीक विश्लेषण',
      'crop_recommendation_desc':
          'माती आणि हवामान डेटावर आधारित वैयक्तिकृत पीक सूचना मिळवा',
      'disease_prediction_desc':
          'चांगल्या व्यवस्थापनासाठी पीक रोगांची लवकर ओळख आणि पहचान',
      'crop_identification_desc': 'प्रतिमांमधून विविध पिके आणि फळे त्वरित ओळखा',
      'fruit_health_desc': 'AI वापरून फळांचे आरोग्य आणि गुणवत्ता मूल्यांकन करा',
      'crop_analysis_desc':
          'पीक कामगिरी आणि आरोग्याबद्दल सखोल अंतर्दृष्टी मिळवा',

      // Features
      'crop_recommendation': 'पीक शिफारस',
      'crop_disease': 'पीक रोग शोध',
      'fruit_identification': 'फळ ओळख',
      'fruit_health_classifier': 'फळ आरोग्य वर्गीकरण',
      'crop_analytics': 'पीक विश्लेषण',

      // Crop Recommendation
      'enter_crop_parameters': 'पीक पॅरामीटर्स प्रविष्ट करा',
      'nitrogen': 'नायट्रोजन (N)',
      'phosphorus': 'फॉस्फरस (P)',
      'potassium': 'पोटॅशियम (K)',
      'temperature': 'तापमान (°C)',
      'humidity': 'आर्द्रता (%)',
      'ph': 'पीएच',
      'rainfall': 'पाऊस (मिमी)',
      'get_recommendation': 'शिफारस मिळवा',
      'reset': 'रीसेट',
      'enter': 'प्रविष्ट करा',

      // Disease Detection
      'select_image_source': 'प्रतिमा स्त्रोत निवडा',
      'camera': 'कॅमेरा',
      'gallery': 'गેલેરી',
      'tap_to_add_photo': 'फोटो जोडण्यासाठी टૅप करा',
      'disease': 'रोग:',
      'description': 'वर्णन:',
      'symptoms': 'लक्षणे:',
      'solutions': 'उपाय:',
      'preventive_measures': 'प्रतिबंधात्मक उपाय:',
      'confidence': 'विश्वास:',

      // About Screen
      'about_app': 'About App',
      'fruits_vegetables': 'Fruits & Vegetables',
      'diseases': 'Diseases',
      'recommended_crops': 'Recommended Crops',
      'healthy_vs_rotten': 'Healthy vs Rotten',
    },

    'gu': {
      // Common
      'app_name': 'એગ્રોઆસિસ્ટ',
      'settings': 'સેટિંગ્સ',
      'dark_mode': 'ડાર્ક મોડ',
      'language': 'ભાષા',
      'cancel': 'રદ કરો',
      'ok': 'ઠીક છે',
      'save': 'સાચવો',
      'notifications': 'સૂચનાઓ',
      'about': 'વિશે',
      'privacy_policy': 'ગોપનીયતા નીતિ',
      'terms_of_service': 'સેવાની શરતો',
      'app_version': 'એપ્લિકેશન સંસ્કરણ',
      'developer': 'ડેવલપર',

      // App Settings
      'dark_mode_enabled': 'ડાર્ક થીમ સક્ષમ',
      'light_mode_enabled': 'લાઇટ થીમ સક્ષમ',
      'enable_notifications': 'સૂચનાઓ સક્ષમ કરો',
      'receive_updates': 'અપડેટ્સ અને એલર્ટ્સ પ્રાપ્ત કરો',
      'select_language': 'ભાષા પસંદ કરો',
      'appearance': 'દેખાવ',
      'app_settings': 'એપ્લિકેશન સેટિંગ્સ',

      // Home Screen
      'agro_assistant': 'કૃષિ સહાયક',
      'key_features': 'મુખ્ય વિશેષતાઓ',
      'smart_crop_recommendation': 'સ્માર્ટ પાક ભલામણ',
      'disease_prediction': 'રોગ આગાહી',
      'crop_identification': 'પાક/ફળ ઓળખ',
      'fruit_health': 'ફળ આરોગ્ય વર્ગીકરણ',
      'crop_analysis': 'પાક વિશ્લેષણ',
      'crop_recommendation_desc':
          'જમીન અને આબોહવા ડેટા પર આધારિત વ્યક્તિગત પાક સૂચનો મેળવો',
      'disease_prediction_desc':
          'સારા સંચાલન માટે પાક રોગોની વહેલી ઓળખ અને શોધ',
      'crop_identification_desc': 'છબીઓમાંથી વિવિધ પાકો અને ફળોને તરત ઓળખો',
      'fruit_health_desc':
          'AI નો ઉપયોગ કરીને ફળોના આરોગ્ય અને ગુણવત્તાનું મૂલ્યાંકન',
      'crop_analysis_desc':
          'પાક પ્રદર્શન અને આરોગ્ય વિશે વ્યાપક અંતર્દૃષ્ટિ મેળવો',

      // Features
      'crop_recommendation': 'પાક ભલામણ',
      'crop_disease': 'પાક રોગ શોધ',
      'fruit_identification': 'ફળ ઓળખ',
      'fruit_health_classifier': 'ફળ આરોગ્ય વર્ગીકરણ',
      'crop_analytics': 'પાક વિશ્લેષણ',

      // Crop Recommendation
      'enter_crop_parameters': 'પાક પરિમાણો દાખલ કરો',
      'nitrogen': 'નાઇટ્રોજન (N)',
      'phosphorus': 'ફોસ્ફરસ (P)',
      'potassium': 'પોટેશિયમ (K)',
      'temperature': 'તાપમાન (°C)',
      'humidity': 'ભેજ (%)',
      'ph': 'પીએચ',
      'rainfall': 'વરસાદ (મિમી)',
      'get_recommendation': 'ભલામણ મેળવો',
      'reset': 'રીસેટ',
      'enter': 'દાખલ કરો',

      // Disease Detection
      'select_image_source': 'છબી સ્રોત પસંદ કરો',
      'camera': 'કેમેરા',
      'gallery': 'ગેલેરી',
      'tap_to_add_photo': 'ફोટો ઉમેરવા માટે ટેપ કરો',
      'disease': 'રોગ:',
      'description': 'વર્ણન:',
      'symptoms': 'લક્ષણો:',
      'solutions': 'ઉકેલો:',
      'preventive_measures': 'નિવારક પગલાં:',
      'confidence': 'વિશ્વાસ:',

      // About Screen
      'about_app': 'About App',
      'fruits_vegetables': 'Fruits & Vegetables',
      'diseases': 'Diseases',
      'recommended_crops': 'Recommended Crops',
      'healthy_vs_rotten': 'Healthy vs Rotten',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr', 'gu'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

// Extension method for String
extension TranslateX on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context).translate(this);
  }
}
