import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  Future<void> _openDashboard(BuildContext context) async {
    final Uri url = Uri.parse(
      'https://app.powerbi.com/view?r=eyJrIjoiYzc4YTM2NTMtZjZmNi00NDAzLTg0MzktZTY3YjQ0NzVkNTYzIiwidCI6IjBkMDRhNmQxLWFlNDctNGZjZS04MTgxLWMxYTQwNzI5MTNiYiJ9',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open dashboard'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F9F5),
        surfaceTintColor: const Color(0xFFF3F9F5),
        elevation: 0,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Crop Analytics',
            style: TextStyle(
              color: Color(0xFF52B788),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF52B788),
              decorationThickness: 2,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.analytics_rounded,
                size: 80,
                color: Color(0xFF52B788),
              ),

              const SizedBox(height: 24),

              const Text(
                'Crop Analytics Dashboard',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              const Text(
                'Explore interactive crop analytics,\ntrends and agricultural insights\npowered by Power BI.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: 260,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _openDashboard(context),
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: const Text(
                    'Open Dashboard',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52B788),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Requires an internet connection.',
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
