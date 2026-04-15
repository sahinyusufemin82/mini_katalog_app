// 📦 Ürün Modeli — wantapi.com yapısına göre

class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    Map<String, String> parsedSpecs = {};
    if (json['specs'] != null) {
      (json['specs'] as Map<String, dynamic>).forEach((key, value) {
        parsedSpecs[key] = value.toString();
      });
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      tagline: json['tagline'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      currency: json['currency'] ?? 'USD',
      image: json['image'] ?? '',
      specs: parsedSpecs,
    );
  }
}
