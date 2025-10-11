import 'package:drivest_office/main_bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/saved_car_controller.dart';
import '../../widgets/car_card.dart';

class SavedPage extends StatelessWidget {
  final SavedCarController savedController = Get.find();
  static const primary = Color(0xff015093);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Saved Cars', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () =>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainBottomNavScreen()), (route)=>false),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: primary),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12),
        ),
      ),
      body: Obx(() {
        final saved = savedController.savedCars;
        if (saved.isEmpty) {
          return const Center(child: Text('No cars saved yet.'));
        }
        return ListView.builder(
          itemCount: saved.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final car = saved[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CarCard(
                car: car,
                onFavoriteToggle: () {
                  savedController.toggleSave(car);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
