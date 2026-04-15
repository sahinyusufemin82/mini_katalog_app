// 🔍 Ürün Detay Sayfası — Dark Mode + Favori butonu

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onAddToCart;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _handleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final imgBg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F7);
    final textColor = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final subColor = isDark ? const Color(0xFF98989F) : const Color(0xFF6E6E73);
    final blueColor =
        isDark ? const Color(0xFF0A84FF) : const Color(0xFF0071E3);
    final specBg = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF5F5F7);
    final divColor = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA);

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
              color: imgBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: textColor),
          ),
        ),
        title: Text('Back',
            style: TextStyle(
                color: blueColor, fontSize: 16, fontWeight: FontWeight.w500)),
        titleSpacing: 0,

        // ❤️ Favori butonu AppBar'da
        actions: [
          GestureDetector(
            onTap: _handleFavorite,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: imgBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : subColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Ürün Görseli ──
                  Container(
                    width: double.infinity,
                    height: 280,
                    color: imgBg,
                    child: Image.network(
                      widget.product.image,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                              color: blueColor, strokeWidth: 2),
                        );
                      },
                      errorBuilder: (c, e, s) => Center(
                        child: Icon(Icons.image_not_supported,
                            size: 80, color: subColor),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ürün Adı
                        Text(widget.product.name,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        const SizedBox(height: 4),

                        // Tagline
                        Text(widget.product.tagline,
                            style: TextStyle(fontSize: 15, color: subColor)),
                        const SizedBox(height: 12),

                        // Fiyat
                        Text(widget.product.price,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: blueColor)),

                        const SizedBox(height: 20),
                        Divider(color: divColor),
                        const SizedBox(height: 16),

                        // Açıklama
                        Text('Description',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        const SizedBox(height: 8),
                        Text(widget.product.description,
                            style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? const Color(0xFFE5E5EA)
                                    : const Color(0xFF3A3A3C),
                                height: 1.6)),

                        // Specifications
                        if (widget.product.specs.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text('Specifications',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor)),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: specBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: widget.product.specs.entries
                                  .map((e) => _specRow(e.key, e.value,
                                      textColor, subColor, divColor))
                                  .toList(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Sepete Ekle Butonu ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onAddToCart(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.product.name} sepete eklendi ✓'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xFF1D1D1F),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Add to Cart',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specRow(String key, String value, Color textColor, Color subColor,
      Color divColor) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                key[0].toUpperCase() + key.substring(1),
                style: TextStyle(color: subColor, fontSize: 14),
              ),
              Text(
                value,
                style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Divider(color: divColor, height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
