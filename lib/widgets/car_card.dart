import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/controller/saved_car_controller.dart';
import '../home/model/car_model.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback onFavoriteToggle;

  const CarCard({Key? key, required this.car, required this.onFavoriteToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savedController = Get.find<SavedCarController>();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: car.imageUrl.isNotEmpty
                      ? Image.network(
                    car.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: Image.asset("assets/images/car.png"),
                        ),
                  )
                      : Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.directions_car,
                        size: 60, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'For Sale',
                      style: TextStyle(
                        color: Color.fromRGBO(1, 80, 147, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      await savedController.toggleSave(car);
                    },
                    child: Obx(() {
                      final isSaved = savedController.isSaved(car);
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSaved
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isSaved
                              ? Colors.red
                              : const Color.fromRGBO(1, 80, 147, 1),
                          size: 24,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                car.make,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(92, 92, 92, 1)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    car.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  '\$${car.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(1, 80, 147, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${car.city}, ${car.country}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(92, 92, 92, 1)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Year: ${car.year}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 12),
                Text(
                  'Color: ${car.color}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

