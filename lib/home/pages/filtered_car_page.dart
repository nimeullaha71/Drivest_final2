import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilteredCarPage extends StatefulWidget {
  final Map<String, dynamic> filters;
  const FilteredCarPage({super.key, required this.filters});

  @override
  State<FilteredCarPage> createState() => _FilteredCarPageState();
}

class _FilteredCarPageState extends State<FilteredCarPage> {
  List<dynamic> filteredCars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFilteredCars();
  }

  Future<void> fetchFilteredCars() async {
    final baseUrl = "https://ai-car-app-sandy.vercel.app";
    final queryParams = {
      'make': widget.filters['brand'],
      'fuelType': widget.filters['fuelType'],
      'bodyType': widget.filters['carType'],
      'condition': widget.filters['condition'],
      'location': widget.filters['location'],
      'minPrice': widget.filters['minPrice'].toString(),
      'maxPrice': widget.filters['maxPrice'].toString(),
      'yearMin': widget.filters['yearMin'].toString(),
      'yearMax': widget.filters['yearMax'].toString(),
      'status': 'published',
      'page': '1',
      'limit': '20',
    };

    final uri = Uri.parse('$baseUrl/cars').replace(queryParameters: queryParams);
    print("Fetching cars with filters: $queryParams");
    print("API URL: $uri");

    try {
      final response = await http.get(uri);
      final jsonData = json.decode(response.body);

      print("API Response: $jsonData");

      if (!mounted) return;
      setState(() {
        filteredCars = jsonData['data'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching filtered cars: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Cars'),
        backgroundColor: const Color.fromRGBO(1, 80, 147, 1),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredCars.isEmpty
          ? const Center(child: Text('No cars found'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredCars.length,
        itemBuilder: (context, index) {
          final car = filteredCars[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: car['media'] != null &&
                      car['media']['cover'] != null &&
                      car['media']['cover']['url'] != null
                      ? Image.network(
                    car['media']['cover']['url'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                  )
                      : const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                ),
              ),
              title: Text(
                car['title'] ?? 'Unknown Car',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${car['make'] ?? ''} ${car['model'] ?? ''}\nPrice: \$${car['price'] ?? 'N/A'} | ${car['year'] ?? ''}',
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              isThreeLine: true,

              onTap: (){
                //TODO : Navigator to the details page ;
              },
            )

          );
        },
      ),
    );
  }
}
