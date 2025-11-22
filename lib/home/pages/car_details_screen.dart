import 'package:flutter/material.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import '../../core/services/network/auth_api.dart';
import '../model/car_model.dart';
import '../widgets/trade_analysis_widget.dart';
import 'ai_chat_page.dart';

// Import the separated trade analysis widget
class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key, required this.carId});
  final String carId;

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  late Future<CarModel> futureCar;
  bool showAnalysis = false;

  @override
  void initState() {
    super.initState();
    futureCar = ApiService.fetchCarDetails(widget.carId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DrivestAppBar(title: "Car Details"),
      body: FutureBuilder<CarModel>(
        future: futureCar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No car details found"));
          }

          final car = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Car Image
                  if (car.imageUrl.isNotEmpty)
                    Image.network(
                      car.imageUrl,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                      const Icon(Icons.image, size: 100),
                    )
                  else
                    const Icon(Icons.image_not_supported,
                        size: 100, color: Colors.grey),

                  const SizedBox(height: 16),

                  /// Car Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          car.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${car.make} • ${car.color} • ${car.year}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff5C5C5C),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Features Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Features",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Feature Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _featureItem(Icons.people, "Seats", "${car.specs}"),
                        _featureItem(Icons.speed, "Mileage", "${car.year} km"),
                        _featureItem(Icons.settings, "Engine", "${car.make}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// AI Trade Analysis Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => showAnalysis = !showAnalysis);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff015093),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "AI Trade Analysis",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// AI Trade Analysis Widget (separated)
                  if (showAnalysis)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TradeAnalysisWidget(
                        carData: {
                          "title": car.title,
                          "brand": car.make,
                          "year_numeric": car.year,
                          "mileage_numeric": car.mileage, // তুমি চাইলে correct mileage বসাবে
                          "price_numeric": car.price,
                          "is_premium": 0,
                          "age": DateTime.now().year - car.year,
                          "url": car.imageUrl,
                        },
                      ),
                    ),



                  const SizedBox(height: 24),

                  /// Price Section + AI Suggestion Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${car.price}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff015093),
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AiChatPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff015093),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(87),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                "AI Suggestion",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Feature Item UI
  Widget _featureItem(IconData icon, String title, String value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xffCCDCE9),
          child: Icon(icon, color: const Color(0xff015093)),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(fontSize: 12, color: Color(0xff5C5C5C))),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
