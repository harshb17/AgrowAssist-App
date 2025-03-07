// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AgroAssist';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkThemeEnabled => 'Dark theme enabled';

  @override
  String get lightThemeEnabled => 'Light theme enabled';

  @override
  String get appSettings => 'App Settings';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get receiveUpdates => 'Receive updates and alerts';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get developer => 'Developer';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get selectLanguage => 'Select Language';

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
