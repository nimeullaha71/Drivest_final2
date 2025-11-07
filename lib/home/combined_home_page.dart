import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/top_appbar.dart';
import 'widgets/condition_selector.dart';
import 'widgets/search_and_filter.dart';
import 'widgets/category_buttons.dart';
import 'widgets/featured_car_section.dart';
import 'widgets/top_brands_section.dart';
import 'widgets/recommended_section.dart';
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
  String selectedCategory = '';

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  List<dynamic> carList = [];

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars([Map<String, dynamic>? filters]) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final queryParams = {
        'status': 'published',
        'page': '1',
        'limit': '10',
        'sort': '-publishedAt',
        if (searchController.text.isNotEmpty) 'q': searchController.text,
      };

      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            queryParams[key] = value.toString();
          }
        }
        );
      }

      debugPrint('Query Params: $queryParams');

      final uri = Uri.parse(Urls.carsUrl).replace(queryParameters: queryParams);
      debugPrint('API URL: $uri');

      final res = await http.get(
          uri,
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );
      if (!mounted) return;

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        debugPrint('API Response: $data');
        if (data['success'] == true) {
          setState(() => carList = data['data'] ?? []);
        }
      } else {
        debugPrint('Failed to load cars: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('API error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

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
            top: 0,
            left: 0,
            right: 0,
            height: appBarHeight,
            child: TopAppBar(appBarHeight: appBarHeight),
          ),
          Positioned(
            top: appBarHeight - overlapHeight,
            left: 16,
            right: 16,
            height: containerHeight,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: Column(
                children: [
                  ConditionSelector(
                    options: conditionOptions,
                    selected: selectedCondition,
                    onChanged: (v) {
                      setState(() => selectedCondition = v);
                      fetchCars();
                    },
                  ),
                  const SizedBox(height: 16),
                  SearchAndFilter(
                    controller: searchController,
                    onSearch: () {
                      fetchCars();
                    },
                    onFilterTap: () async {
                      final filters = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FilterPage()),
                      );
                      if (filters != null && filters is Map) {
                        fetchCars(Map<String, dynamic>.from(filters));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CategoryButtons(
                    options: categoryOptions,
                    onTap: (o) {
                      setState(() => selectedCategory = o);
                      fetchCars();
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: appBarHeight + overlapHeight + 16,
            left: 24,
            right: 24,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (carList.isEmpty)
                    const Text("No cars found", style: TextStyle(color: Colors.grey))
                  else
                    _buildCarList(),
                  const SizedBox(height: 24,),
                  const FeaturedCarSinglePage(),
                  const SizedBox(height: 24),
                  const TopBrandsSection(),
                  const SizedBox(height: 16),
                  const RecommendedSection(),
                  const SizedBox(height: 24),
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

  Widget _buildCarList() {
    return Column(
      children: carList.map((car) {
        final imageUrl =
            car['media']?['cover']?['url'] ?? 'https://via.placeholder.com/150';
        final title = car['title'] ?? 'Unknown Car';
        final make = car['make'] ?? '';
        final model = car['model'] ?? '';
        final price = car['price']?.toString() ?? 'N/A';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.directions_car,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "$make • $model\n\$$price",
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
            isThreeLine: true,
          ),
        );
      }).toList(),
    );
  }

}
