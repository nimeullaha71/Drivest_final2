import 'package:drivest_office/home/pages/profile/profile_page.dart';
import 'package:drivest_office/home/pages/saved_page.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/custome_bottom_nav_bar.dart';
import 'ai_chat_page.dart';
import 'compare_selection_page.dart';

class TopBrandsPage extends StatelessWidget {
  const TopBrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> brandLogos = [
      'assets/images/bmw_logo.png',
      'assets/images/volvo_logo.png',
      'assets/images/tesla_logo.png',
      'assets/images/brand_logo.png',
      'assets/images/brand_logo.png',
      'assets/images/volvo_logo.png',
      'assets/images/brand_logo.png',
      'assets/images/volvo_logo.png',
      'assets/images/bmw_logo.png',
      'assets/images/volvo_logo.png',
      'assets/images/brand_logo.png',
      'assets/images/volvo_logo.png',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: DrivestAppBar(title: "Top Brands"),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: GridView.builder(
          itemCount: brandLogos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  brandLogos[index],
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompareSelectionPage()));
          }
          if (index == 2) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SavedPage()));
          }
          if (index == 3) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AiChatPage()));
          }
          if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          }
        },
      ),
    );
  }
}
