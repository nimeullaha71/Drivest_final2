import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/custome_bottom_nav_bar.dart';
import '../ai_chat_page.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Terms & Condition"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              _buildNumberedItem(
                  1,
                  "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing"),
              _buildNumberedItem(
                  2,
                  "Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
              _buildNumberedItem(
                  3,
                  "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing"),
              _buildNumberedItem(
                  4,
                  "Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
              _buildNumberedItem(
                  5,
                  "Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => CompareSelectionPage()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => SavedPage()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => AiChatPage()));
        },
      ),
    );
  }

  Widget _buildNumberedItem(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
