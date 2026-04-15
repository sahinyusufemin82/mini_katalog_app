// ❤️ Favoriler Sayfası

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Product> favoriteProducts;
  final Function(Product) onAddToCart;
  final Set<int> favoriteIds;
  final Function(Product) onFavoriteToggle;

  const FavoritesScreen({
    super.key,
    required this.favoriteProducts,
    required this.onAddToCart,
    required this.favoriteIds,
    required this.onFavoriteToggle,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Product> _favorites;
  late Set<int> _favoriteIds;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favoriteProducts);
    _favoriteIds = Set.from(widget.favoriteIds);
  }

  void _handleToggle(Product product) {
    widget.onFavoriteToggle(product);
    setState(() {
      if (_favoriteIds.contains(product.id)) {
        _favoriteIds.remove(product.id);
        _favorites.removeWhere((p) => p.id == product.id);
      } else {
        _favoriteIds.add(product.id);
        _favorites.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F7);
    final textColor = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final subColor = isDark ? const Color(0xFF98989F) : const Color(0xFF6E6E73);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: textColor),
          ),
        ),
        title: Text('Favorilerim',
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE5E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border,
                        size: 60, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text('Henüz favori yok',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                  const SizedBox(height: 8),
                  Text('Beğendiğin ürünleri kaydet',
                      style: TextStyle(color: subColor)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Ürünleri Keşfet'),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final product = _favorites[index];
                return ProductCard(
                  product: product,
                  isFavorite: true,
                  onFavoriteToggle: () => _handleToggle(product),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                          onAddToCart: widget.onAddToCart,
                          isFavorite: _favoriteIds.contains(product.id),
                          onFavoriteToggle: () => _handleToggle(product),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
