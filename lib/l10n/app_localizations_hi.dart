// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'एग्रोअसिस्ट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appearance => 'दिखावट';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkThemeEnabled => 'डार्क थीम सक्षम';

  @override
  String get lightThemeEnabled => 'लाइट थीम सक्षम';

  @override
  String get appSettings => 'ऐप सेटिंग्स';

  @override
  String get enableNotifications => 'सूचनाएं सक्षम करें';

  @override
  String get receiveUpdates => 'अपडेट और अलर्ट प्राप्त करें';

  @override
  String get language => 'भाषा';

  @override
  String get about => 'जानकारी';

  @override
  String get appVersion => 'ऐप वर्जन';

  @override
  String get developer => 'डेवलपर';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get home => 'होम';

  @override
  String get crops => 'फसलें';

  @override
  String get diseases => 'रोग';

  @override
  String get identify => 'पहचानें';

  @override
  String get health => 'स्वास्थ्य';

  @override
  String get cropRecommendation => 'फसल सिफारिश';

  @override
  String get cropDiseaseDetection => 'फसल रोग पहचान';

  @override
  String get fruitIdentification => 'फल पहचान';

  @override
  String get fruitHealthClassifier => 'फल स्वास्थ्य वर्गीकरण';

  @override
  String get cropAnalytics => 'फसल विश्लेषण';

  @override
  String get enterCropParameters => 'फसल पैरामीटर दर्ज करें';

  @override
  String get getRecommendation => 'सिफारिश प्राप्त करें';

  @override
  String get reset => 'रीसेट';

  @override
  String get predicting => 'भविष्यवाणी कर रहा है...';

  @override
  String recommendedCrop(String crop) {
    return 'अनुशंसित फसल: $crop';
  }

  @override
  String get selectImageSource => 'छवि स्रोत चुनें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get tapToAddPhoto => 'फोटो जोड़ने के लिए टैप करें';

  @override
  String confidence(String confidence) {
    return 'विश्वसनीयता: $confidence%';
  }

  @override
  String disease(String name) {
    return 'रोग: $name';
  }

  @override
  String get description => 'विवरण';

  @override
  String get symptoms => 'लक्षण';

  @override
  String get solutions => 'समाधान';

  @override
  String get preventiveMeasures => 'निवारक उपाय';

  @override
  String classification(String name) {
    return 'वर्गीकरण: $name';
  }

  @override
  String get healthyCrop => 'फसल स्वस्थ प्रतीत होती है।';

  @override
  String get rottenCrop => 'फसल सड़ी या रोगग्रस्त प्रतीत होती है।';

  @override
  String get fruitsVegetables => 'फल और सब्जियां';

  @override
  String get plantDiseases => 'पौधों के रोग';

  @override
  String get recommendedCrops => 'अनुशंसित फसलें';

  @override
  String get healthyVsRotten => 'स्वस्थ बनाम सड़ी';

  @override
  String get appInformation => 'ऐप जानकारी';

  @override
  String get openAnalyticsDashboard => 'विश्लेषण डैशबोर्ड खोलें';

  @override
  String get cropsInformationDashboard => 'फसल जानकारी डैशबोर्ड';
}
