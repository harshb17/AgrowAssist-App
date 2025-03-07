// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'એગ્રોઅસિસ્ટ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'ડાર્ક મોડ';

  @override
  String get darkThemeEnabled => 'ડાર્ક થીમ સક્ષમ';

  @override
  String get lightThemeEnabled => 'લાઇટ થીમ સક્ષમ';

  @override
  String get appSettings => 'એપ્લિકેશન સેટિંગ્સ';

  @override
  String get enableNotifications => 'સૂચનાઓ સક્ષમ કરો';

  @override
  String get receiveUpdates => 'અપડેટ્સ અને અલર્ટ્સ મેળવો';

  @override
  String get language => 'ભાષા';

  @override
  String get about => 'વિશે';

  @override
  String get appVersion => 'એપ્લિકેશન વર્ઝન';

  @override
  String get developer => 'ડેવલપર';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get termsOfService => 'સેવાની શરતો';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

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
    return 'વિશ્વસનીયતા: $confidence%';
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
