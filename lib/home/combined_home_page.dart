import 'package:flutter/material.dart';
import 'widgets/top_appbar.dart';
import 'widgets/condition_selector.dart';
import 'widgets/search_and_filter.dart';
import 'widgets/category_buttons.dart';
import 'widgets/featured_car_section.dart';
import 'widgets/top_brands_section.dart';
import 'widgets/recommended_section.dart';
import 'widgets/top_agents_section.dart';
import 'widgets/ai_suggestion_card.dart';
import 'pages/filter_page.dart';

class CombinedHomePage extends StatefulWidget {
  const CombinedHomePage({super.key});

  @override
  State<CombinedHomePage> createState() => _CombinedHomePageState();
}

class _CombinedHomePageState extends State<CombinedHomePage> {
  final List<String> conditionOptions = const ['New', 'Old', 'Repaired'];
  final List<String> categoryOptions = const ['Jeep', 'Sports', 'Others'];
  String selectedCondition = 'New';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = screenHeight * 0.28;
    const double containerHeight = 224.0;
    const double overlapHeight = containerHeight / 2;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0, height: appBarHeight,
            child: TopAppBar(appBarHeight: appBarHeight),
          ),
          Positioned(
            top: appBarHeight - overlapHeight, left: 16, right: 16, height: containerHeight,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  ConditionSelector(
                    options: conditionOptions,
                    selected: selectedCondition,
                    onChanged: (v) => setState(() => selectedCondition = v),
                  ),
                  const SizedBox(height: 16),
                  SearchAndFilter(
                    onFilterTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>  FilterPage()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CategoryButtons(
                    options: categoryOptions,
                    onTap: (o) => debugPrint('Category selected: $o'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: appBarHeight + overlapHeight + 16,
            left: 24, right: 24, bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FeaturedCarSinglePage(),
                  const SizedBox(height: 24),
                  const TopBrandsSection(),
                  const SizedBox(height: 16),
                  const RecommendedSection(),
                  const SizedBox(height: 24),
                  //const AgentRowSection(),
                  //const SizedBox(height: 16),
                  const AiSuggestionCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
