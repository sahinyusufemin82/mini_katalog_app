// 🌐 API Servisi — wantapi.com

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _url = 'https://wantapi.com/products.php';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);

      // wantapi.com yanıtı: { "status": "success", "data": [...] }
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Ürünler yüklenemedi (${response.statusCode})');
    }
  }
}
