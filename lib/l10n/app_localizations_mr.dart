// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'एग्रोअसिस्ट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get appearance => 'दिसणे';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkThemeEnabled => 'डार्क थीम सक्षम';

  @override
  String get lightThemeEnabled => 'लाइट थीम सक्षम';

  @override
  String get appSettings => 'ऍप सेटिंग्स';

  @override
  String get enableNotifications => 'सूचना सक्षम करा';

  @override
  String get receiveUpdates => 'अपडेट्स आणि अलर्ट्स प्राप्त करा';

  @override
  String get language => 'भाषा';

  @override
  String get about => 'माहिती';

  @override
  String get appVersion => 'ऍप व्हर्जन';

  @override
  String get developer => 'डेव्हलपर';

  @override
  String get privacyPolicy => 'गोपनीयता धोरण';

  @override
  String get termsOfService => 'सेवा अटी';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get home => 'Home';

  @override
  String get crops => 'Crops';

  @override
  String get diseases => 'Diseases';

  @override
  String get identify => 'Identify';

  @override
  String get health => 'Health';

  @override
  String get cropRecommendation => 'Crop Recommendation';

  @override
  String get cropDiseaseDetection => 'Crop Disease Detection';

  @override
  String get fruitIdentification => 'Fruit Identification';

  @override
  String get fruitHealthClassifier => 'Fruit Health Classifier';

  @override
  String get cropAnalytics => 'Crop Analytics';

  @override
  String get enterCropParameters => 'Enter Crop Parameters';

  @override
  String get getRecommendation => 'Get Recommendation';

  @override
  String get reset => 'Reset';

  @override
  String get predicting => 'Predicting...';

  @override
  String recommendedCrop(String crop) {
    return 'Recommended Crop';
  }

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get tapToAddPhoto => 'Tap to add photo';

  @override
  String confidence(String confidence) {
    return 'Confidence: $confidence%';
  }

  @override
  String disease(String name) {
    return 'Disease';
  }

  @override
  String get description => 'Description';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get solutions => 'Solutions';

  @override
  String get preventiveMeasures => 'Preventive Measures';

  @override
  String classification(String name) {
    return 'Classification';
  }

  @override
  String get healthyCrop => 'Healthy Crop';

  @override
  String get rottenCrop => 'Rotten Crop';

  @override
  String get fruitsVegetables => 'Fruits & Vegetables';

  @override
  String get plantDiseases => 'Plant Diseases';

  @override
  String get recommendedCrops => 'Recommended Crops';

  @override
  String get healthyVsRotten => 'Healthy vs Rotten';

  @override
  String get appInformation => 'App Information';

  @override
  String get openAnalyticsDashboard => 'Open Analytics Dashboard';

  @override
  String get cropsInformationDashboard => 'Crops Information Dashboard';
}
