import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'crop_recommendation_screen.dart';
import 'crop_disease_screen.dart';
import 'fruit_identification.dart';
import 'app_info_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import 'crop_healthy_or_rotten.dart';
import 'package:flutter/cupertino.dart';
import 'theme/theme_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'AgrowAssist',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {
        '/crop_recommendation': (context) => const CropRecommendationScreen(),
        '/crop_disease': (context) => const CropDiseaseScreen(),
        '/fruit_identification': (context) => const FruitIdentificationScreen(),
        '/crop_healthy_or_rotten':
            (context) => const CropHealthyOrRottenScreen(),
        '/app_info': (context) => const AppInfoScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenContent(),
    const CropRecommendationScreen(),
    const CropDiseaseScreen(),
    const FruitIdentificationScreen(),
    const CropHealthyOrRottenScreen(),
    const AppInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          'AgrowAssist',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/analytics');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/app_info');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: GNav(
              rippleColor: colorScheme.primary.withOpacity(0.2),
              hoverColor: colorScheme.primary.withOpacity(0.1),
              gap: 4,
              activeColor: colorScheme.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: colorScheme.primary.withOpacity(0.1),
              color: colorScheme.onSurface.withOpacity(0.7),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
                GButton(
                  icon: Icons.agriculture_outlined,
                  text: 'Crops',
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
                GButton(
                  icon: Icons.bug_report_outlined,
                  text: 'Diseases',
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
                GButton(
                  icon: Icons.image_search_outlined,
                  text: 'Identify',
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
                GButton(
                  icon: Icons.health_and_safety_outlined,
                  text: 'Health',
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/banner.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder:
                    (context) => Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'AGRO ASSISTANT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: Icon(
                              Icons.agriculture,
                              color: colorScheme.primary,
                            ),
                            title: const Text('Crop Recommendation'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/crop_recommendation',
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.bug_report,
                              color: colorScheme.primary,
                            ),
                            title: const Text('Crop Disease Detection'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/crop_disease');
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.image_search,
                              color: colorScheme.primary,
                            ),
                            title: const Text('Fruit/Crop Identification'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/fruit_identification',
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.health_and_safety,
                              color: colorScheme.primary,
                            ),
                            title: const Text('Fruit Health Classifier'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                '/crop_healthy_or_rotten',
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.analytics,
                              color: colorScheme.primary,
                            ),
                            title: const Text('Crop Analytics'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/analytics');
                            },
                          ),
                        ],
                      ),
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'AGRO ASSISTANT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Key Features'),
          const SizedBox(height: 16),
          _buildFeatureList(context),
          _buildCopyrightFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _buildFeatureListItem(
          context,
          'Smart Crop Recommendation',
          'Get personalized crop suggestions based on soil and climate data',
          Icons.agriculture_outlined,
          () => Navigator.pushNamed(context, '/crop_recommendation'),
        ),
        const SizedBox(height: 16),
        _buildFeatureListItem(
          context,
          'Disease Prediction',
          'Detect and identify crop diseases early for better management',
          Icons.bug_report_outlined,
          () => Navigator.pushNamed(context, '/crop_disease'),
        ),
        const SizedBox(height: 16),
        _buildFeatureListItem(
          context,
          'Crop/Fruit Identification',
          'Instantly identify various crops and fruits from images',
          Icons.image_search_outlined,
          () => Navigator.pushNamed(context, '/fruit_identification'),
        ),
        const SizedBox(height: 16),
        _buildFeatureListItem(
          context,
          'Fruit Health Classification',
          'Assess the health and quality of fruits using AI',
          Icons.health_and_safety_outlined,
          () => Navigator.pushNamed(context, '/crop_healthy_or_rotten'),
        ),
        const SizedBox(height: 16),
        _buildFeatureListItem(
          context,
          'Crop Analysis',
          'Get comprehensive insights into crop performance and health',
          Icons.analytics_outlined,
          () => Navigator.pushNamed(context, '/analytics'),
        ),
      ],
    );
  }

  Widget _buildFeatureListItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyrightFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        '© 2026 AgrowAssist. All rights reserved.',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
