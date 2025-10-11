class CarModel {
  final String id;
  final String title;
  final String color;
  final int year;
  final int price;
  final String city;
  final String country;
  final String imageUrl;

  CarModel({
    required this.id,
    required this.title,
    required this.color,
    required this.year,
    required this.price,
    required this.city,
    required this.country,
    required this.imageUrl,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      color: json['color'] ?? '',
      year: json['year'] ?? 0,
      price: json['price'] ?? 0,
      city: json['location']?['city'] ?? '',
      country: json['location']?['country'] ?? '',
      imageUrl: json['media']?['cover']?['url'] ?? '',
    );
  }
}
