// 🏠 Ana Sayfa — Kategori filtresi + Dark Mode + Favoriler

import 'package:flutter/material.dart';
import '../main.dart'; // themeNotifier için
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final List<Product> _cart = [];
  final Set<int> _favoriteIds = {}; // Favori ürün id'leri

  bool _isLoading = true;
  String? _errorMessage;
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  // wantapi ürün adlarından kategori çıkar
  static String _getCategory(String name) {
    if (name.contains('iPhone')) return 'iPhone';
    if (name.contains('MacBook')) return 'MacBook';
    if (name.contains('iPad')) return 'iPad';
    if (name.contains('Watch')) return 'Watch';
    if (name.contains('AirPods')) return 'AirPods';
    if (name.contains('HomePod')) return 'HomePod';
    if (name.contains('iMac')) return 'iMac';
    if (name.contains('Vision')) return 'Vision Pro';
    return 'Diğer';
  }

  // Mevcut ürünlerden dinamik kategori listesi oluştur
  List<String> get _categories {
    final cats = _allProducts.map((p) => _getCategory(p.name)).toSet().toList();
    cats.sort();
    return ['Tümü', ...cats];
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final products = await ApiService.getProducts();
      setState(() {
        _allProducts = products;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Arama + Kategori filtresini birlikte uygula
  void _applyFilters() {
    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final matchSearch = _searchQuery.isEmpty ||
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.tagline.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchCategory = _selectedCategory == 'Tümü' ||
            _getCategory(p.name) == _selectedCategory;

        return matchSearch && matchCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    _applyFilters();
  }

  void _toggleFavorite(Product product) {
    setState(() {
      if (_favoriteIds.contains(product.id)) {
        _favoriteIds.remove(product.id);
      } else {
        _favoriteIds.add(product.id);
      }
    });
  }

  void _addToCart(Product product) {
    setState(() => _cart.add(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi ✓'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF1D1D1F),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeFromCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((p) => p.id == product.id);
      if (index != -1) _cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F7);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final subColor = isDark ? const Color(0xFF98989F) : const Color(0xFF6E6E73);
    final blueColor =
        isDark ? const Color(0xFF0A84FF) : const Color(0xFF0071E3);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Üst Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Başlık
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discover',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      Text('Find your perfect device',
                          style: TextStyle(fontSize: 14, color: subColor)),
                    ],
                  ),

                  // İkon Grubu: Favori + Dark Mode + Sepet
                  Row(
                    children: [
                      // ❤️ Favoriler
                      _topBarButton(
                        isDark: isDark,
                        cardColor: cardColor,
                        icon: Icons.favorite,
                        color: _favoriteIds.isNotEmpty
                            ? Colors.red
                            : (isDark ? Colors.white : const Color(0xFF1D1D1F)),
                        badge: _favoriteIds.isNotEmpty
                            ? _favoriteIds.length
                            : null,
                        badgeColor: Colors.red,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesScreen(
                                favoriteProducts: _allProducts
                                    .where((p) => _favoriteIds.contains(p.id))
                                    .toList(),
                                onAddToCart: _addToCart,
                                favoriteIds: _favoriteIds,
                                onFavoriteToggle: _toggleFavorite,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),

                      // 🌙 Dark Mode Toggle
                      _topBarButton(
                        isDark: isDark,
                        cardColor: cardColor,
                        icon: isDark ? Icons.wb_sunny : Icons.nightlight_round,
                        color: isDark
                            ? const Color(0xFFFFD60A)
                            : const Color(0xFF1D1D1F),
                        onTap: () {
                          themeNotifier.value =
                              themeNotifier.value == ThemeMode.light
                                  ? ThemeMode.dark
                                  : ThemeMode.light;
                        },
                      ),
                      const SizedBox(width: 8),

                      // 🛒 Sepet
                      _topBarButton(
                        isDark: isDark,
                        cardColor: cardColor,
                        icon: Icons.shopping_bag_outlined,
                        color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                        badge: _cart.isNotEmpty ? _cart.length : null,
                        badgeColor: blueColor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(
                                cart: _cart,
                                onRemove: _removeFromCart,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Arama Çubuğu ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    hintStyle: TextStyle(color: subColor),
                    prefixIcon: Icon(Icons.search, color: subColor, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Kategori Chip'leri ──
            if (!_isLoading && _errorMessage == null)
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => _onCategorySelected(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? blueColor : cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : subColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 14),

            // ── İçerik ──
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: blueColor))
                  : _errorMessage != null
                      ? _buildError(blueColor)
                      : _buildGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Üst bar ikon butonu
  Widget _topBarButton({
    required bool isDark,
    required Color cardColor,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int? badge,
    Color? badgeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          if (badge != null)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F7);
    final subColor = isDark ? const Color(0xFF98989F) : const Color(0xFF6E6E73);
    final blueColor =
        isDark ? const Color(0xFF0A84FF) : const Color(0xFF0071E3);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return CustomScrollView(
      slivers: [
        // Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/banner.png',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Image.network(
                  'https://wantapi.com/assets/banner.png',
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (c2, e2, s2) => Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [blueColor, const Color(0xFF34AADC)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('🛍️ GIFT STORE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Ürün sayısı
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${_filteredProducts.length} ürün',
              style: TextStyle(color: subColor, fontSize: 13),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        // Grid
        _filteredProducts.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text('Ürün bulunamadı 😕',
                        style: TextStyle(color: subColor, fontSize: 16)),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(
                        product: product,
                        isFavorite: _favoriteIds.contains(product.id),
                        onFavoriteToggle: () => _toggleFavorite(product),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: product,
                                onAddToCart: _addToCart,
                                isFavorite: _favoriteIds.contains(product.id),
                                onFavoriteToggle: () =>
                                    _toggleFavorite(product),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: _filteredProducts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildError(Color blueColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Color(0xFF6E6E73)),
          const SizedBox(height: 16),
          const Text('Bağlantı Hatası',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6E6E73), fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}
