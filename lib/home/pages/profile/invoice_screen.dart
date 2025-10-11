import 'package:drivest_office/home/pages/profile/profile_page.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/custome_bottom_nav_bar.dart';
import '../ai_chat_page.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  static const _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Invoice"),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vat Number",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color.fromRGBO(51, 51, 51, 1)),),
            const SizedBox(height: 8,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),
              ),
            ),
            SizedBox(height: 16,),
            Text("Company Name",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color.fromRGBO(51, 51, 51, 1)),),
            const SizedBox(height: 8,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),
              ),
            ),
            SizedBox(height: 16,),
            Text("Company Address",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color.fromRGBO(51, 51, 51, 1)),),
            const SizedBox(height: 8,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),
              ),
            ),
            SizedBox(height: 16,),
            Text("Country",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color.fromRGBO(51, 51, 51, 1)),),
            const SizedBox(height: 8,),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 16),
              ),
            ),
            SizedBox(height: 48,),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){}, child: Text("Save & continue"),
              ),
            ),
            SizedBox(height: 16,),
            Center(child: TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
            }, child: Text("Skip for now",style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w400,color: Color.fromRGBO(1, 80, 147, 1)),)))
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
