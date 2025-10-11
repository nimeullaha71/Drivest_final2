import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/custome_bottom_nav_bar.dart';
import '../ai_chat_page.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

class HelpAndFeedbackPage extends StatefulWidget {
  const HelpAndFeedbackPage({super.key});

  @override
  State<HelpAndFeedbackPage> createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends State<HelpAndFeedbackPage> {
  int _selectedIndex = 4;
  static const primary = Color(0xff015093);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Help & Feedback"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit a Ticket',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Describe Your Issue',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, horizontal: 12),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Need More Help ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Color(0xFFDDE2E8)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.wifi_calling_3_sharp),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Call Us (+1-212–456–7890)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Our help line service is active: 24/7",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6E7C8D),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
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
}
