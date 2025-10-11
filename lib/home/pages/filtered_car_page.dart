import 'package:drivest_office/home/pages/featured_car_list_page.dart';
import 'package:flutter/material.dart';

class FilteredCarPage extends StatelessWidget {
  const FilteredCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeaturedCarListPage(titleName: 'Filtered Car',),
    );
  }
}
