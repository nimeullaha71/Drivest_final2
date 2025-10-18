class CarModel {
  final String id;
  final String title;
  final String color;
  final String make;
  final int year;
  final int price;
  final String city;
  final String country;
  final String imageUrl;

  CarModel({
    required this.id,
    required this.title,
    required this.color,
    required this.make,
    required this.year,
    required this.price,
    required this.city,
    required this.country,
    required this.imageUrl,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return CarModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      color: json['color'] ?? '',
      make: json['make'] ?? '',
      year: parseInt(json['year']),
      price: parseInt(json['price']),
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      imageUrl: json['media']?['cover']?['url'] ?? '',
    );
  }
}
