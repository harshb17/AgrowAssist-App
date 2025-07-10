import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'App Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: 'Fruits'),
              Tab(text: 'Diseases'),
              Tab(text: 'Crops'),
              Tab(text: 'Healthy'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFruitsList(context),
            _buildDiseasesList(context),
            _buildCropsList(context),
            _buildHealthyRottenList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFruitsList(BuildContext context) {
    final fruitLabels = [
      'apple',
      'avocado',
      'banana',
      'beetroot',
      'bell pepper',
      'cabbage',
      'capsicum',
      'carrot',
      'cauliflower',
      'cherry',
      'chilli pepper',
      'corn',
      'cucumber',
      'eggplant',
      'garlic',
      'ginger',
      'grapes',
      'guava',
      'jalapeno',
      'kiwi',
      'lemon',
      'lettuce',
      'mango',
      'onion',
      'orange',
      'papaya',
      'paprika',
      'pear',
      'peas',
      'pineapple',
      'pomegranate',
      'potato',
      'radish',
      'soybeans',
      'spinach',
      'strawberries',
      'sweetcorn',
      'sweetpotato',
      'tomato',
      'turnip',
      'watermelon',
    ];

    return _buildListView(
      context,
      fruitLabels,
      'Fruits & Vegetables',
      'The app can identify these 41 fruits and vegetables:',
      Icons.eco_rounded,
    );
  }

  Widget _buildDiseasesList(BuildContext context) {
    final diseaseLabels = [
      'Apple - Apple Scab',
      'Apple - Black Rot',
      'Apple - Cedar Apple Rust',
      'Apple - Healthy',
      'Background without Leaves',
      'Blueberry - Healthy',
      'Cherry - Powdery Mildew',
      'Cherry - Healthy',
      'Corn - Cercospora Leaf Spot Gray Leaf Spot',
      'Corn - Common Rust',
      'Corn - Northern Leaf Blight',
      'Corn - Healthy',
      'Grape - Black Rot',
      'Grape - Esca (Black Measles)',
      'Grape - Leaf Blight',
      'Grape - Healthy',
      'Orange - Huanglongbing',
      'Peach - Bacterial Spot',
      'Peach - Healthy',
      'Pepper Bell - Bacterial Spot',
      'Pepper Bell - Healthy',
      'Potato - Early Blight',
      'Potato - Late Blight',
      'Potato - Healthy',
      'Raspberry - Healthy',
      'Soybean - Healthy',
      'Squash - Powdery Mildew',
      'Strawberry - Leaf Scorch',
      'Strawberry - Healthy',
      'Tomato - Bacterial Spot',
      'Tomato - Early Blight',
      'Tomato - Late Blight',
      'Tomato - Leaf Mold',
      'Tomato - Septoria Leaf Spot',
      'Tomato - Spider Mites Two-Spotted Spider Mite',
      'Tomato - Target Spot',
      'Tomato - Yellow Leaf Curl Virus',
      'Tomato - Mosaic Virus',
      'Tomato - Healthy',
    ];

    return _buildListView(
      context,
      diseaseLabels,
      'Plant Diseases',
      'The app can detect these 39 plant diseases and health conditions:',
      Icons.bug_report_rounded,
      showHealthStatus: true,
    );
  }

  Widget _buildCropsList(BuildContext context) {
    final cropLabels = [
      'rice',
      'maize',
      'jute',
      'cotton',
      'coconut',
      'papaya',
      'orange',
      'apple',
      'muskmelon',
      'watermelon',
      'grapes',
      'mango',
      'banana',
      'pomegranate',
      'lentil',
      'blackgram',
      'mungbean',
      'mothbeans',
      'pigeonpeas',
      'kidneybeans',
      'chickpea',
      'coffee',
    ];

    return _buildListView(
      context,
      cropLabels,
      'Recommended Crops',
      'The app can recommend these 22 crops based on soil and weather conditions:',
      Icons.agriculture_rounded,
    );
  }

  Widget _buildHealthyRottenList(BuildContext context) {
    final healthyRottenLabels = [
      'Apple - Healthy',
      'Apple - Rotten',
      'Banana - Healthy',
      'Banana - Rotten',
      'Bell Pepper - Healthy',
      'Bell Pepper - Rotten',
      'Carrot - Healthy',
      'Carrot - Rotten',
      'Cucumber - Healthy',
      'Cucumber - Rotten',
      'Grape - Healthy',
      'Grape - Rotten',
      'Guava - Healthy',
      'Guava - Rotten',
      'Jujube - Healthy',
      'Jujube - Rotten',
      'Mango - Healthy',
      'Mango - Rotten',
      'Orange - Healthy',
      'Orange - Rotten',
      'Pomegranate - Healthy',
      'Pomegranate - Rotten',
      'Potato - Healthy',
      'Potato - Rotten',
      'Strawberry - Healthy',
      'Strawberry - Rotten',
      'Tomato - Healthy',
      'Tomato - Rotten',
    ];

    return _buildListView(
      context,
      healthyRottenLabels,
      'Healthy vs Rotten Crops',
      'The app can classify these 14 fruits and vegetables as healthy or rotten:',
      Icons.health_and_safety_rounded,
      showHealthStatus: true,
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<String> items,
    String title,
    String description,
    IconData icon, {
    bool showHealthStatus = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              cacheExtent: 500,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final label = items[index];
                final isHealthy = label.toLowerCase().contains('healthy');
                final isRotten = label.toLowerCase().contains('rotten');

                Color badgeColor;
                Color badgeFg;
                IconData? statusIcon;

                if (showHealthStatus && isHealthy) {
                  badgeColor = Colors.green.withOpacity(0.12);
                  badgeFg = Colors.green[700]!;
                  statusIcon = Icons.check_circle_rounded;
                } else if (showHealthStatus && isRotten) {
                  badgeColor = Colors.red.withOpacity(0.10);
                  badgeFg = Colors.red[600]!;
                  statusIcon = Icons.warning_rounded;
                } else if (showHealthStatus) {
                  badgeColor = Colors.orange.withOpacity(0.12);
                  badgeFg = Colors.orange[800]!;
                  statusIcon = Icons.coronavirus_rounded;
                } else {
                  badgeColor = colorScheme.primary.withOpacity(0.12);
                  badgeFg = colorScheme.primary;
                  statusIcon = null;
                }

                return RepaintBoundary(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.08),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      leading: CircleAvatar(
                        radius: 21,
                        backgroundColor: badgeColor,
                        child:
                            statusIcon != null
                                ? Icon(statusIcon, color: badgeFg, size: 20)
                                : Text(
                                  label.split(' ')[0][0].toUpperCase(),
                                  style: TextStyle(
                                    color: badgeFg,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                      ),
                      title: Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
