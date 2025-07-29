import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _buildSectionHeader(context, 'Appearance'),

          _buildCard(
            context,
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: Text(
                themeProvider.isDarkMode
                    ? 'Dark theme enabled'
                    : 'Light theme enabled',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              ),
              value: themeProvider.isDarkMode,
              activeColor: colorScheme.primary,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 10),

          _buildSectionHeader(context, 'Preferences'),

          _buildCard(
            context,
            child: ListTile(
              leading: Icon(
                Icons.language,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              title: const Text('Language'),
              subtitle: Text(
                '$_selectedLanguage (Coming Soon)',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              onTap: _showLanguageDialog,
            ),
          ),

          const SizedBox(height: 10),

          _buildSectionHeader(context, 'About'),

          _buildCard(
            context,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person_outline,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  title: const Text('Developer'),
                  subtitle: Text(
                    'Harsh Bhoi',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withOpacity(0.15),
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  title: const Text('Version'),
                  subtitle: Text(
                    'Version 1.0.0 (Stable)',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withOpacity(0.15),
                ),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Privacy Policy'),
                            content: const SingleChildScrollView(
                              child: Text(
                                'AgroAssist respects your privacy.\n\n'
                                '• All crop recommendations and disease predictions are processed locally on your device using TensorFlow Lite.\n\n'
                                '• Images selected from your gallery or captured using the camera are never uploaded to any server.\n\n'
                                '• AgroAssist does not collect, store, or share any personal information.\n\n'
                                '• The Crop Analytics dashboard is provided through Microsoft Power BI and may require an internet connection.\n\n'
                                'By using AgroAssist, you agree to this Privacy Policy.',
                                style: TextStyle(height: 1.45),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withOpacity(0.15),
                ),
                ListTile(
                  leading: Icon(
                    Icons.description_outlined,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  title: const Text('Terms of Service'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text('Terms of Service'),
                            content: const SingleChildScrollView(
                              child: Text(
                                'AgroAssist is developed for educational and informational purposes.\n\n'
                                '• Crop recommendations and disease predictions are generated using machine learning models and may not always be 100% accurate.\n\n'
                                '• Users should verify important agricultural decisions with qualified experts before taking action.\n\n'
                                '• The developer is not responsible for any loss or damage resulting from reliance on the application\'s predictions.\n\n'
                                'By continuing to use AgroAssist, you agree to these Terms of Service.',
                                style: TextStyle(height: 1.45),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const SizedBox(height: 40),

          Icon(Icons.eco_rounded, color: colorScheme.primary, size: 34),

          const SizedBox(height: 8),

          Center(
            child: Text(
              'AgroAssist',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              'Made with ❤️',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Center(
            child: Text(
              '© 2026 Harsh Bhoi',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withOpacity(0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  void _showLanguageDialog() {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English'),
              _buildLanguageOption('Hindi'),
              _buildLanguageOption('Marathi'),
              _buildLanguageOption('Gujarati'),
              const SizedBox(height: 12),
              Text(
                'Language support will be available in a future update.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(language),
      trailing:
          _selectedLanguage == language
              ? Icon(Icons.check, color: colorScheme.primary)
              : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }
}
