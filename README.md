<img width="500" height="1020" alt="Ekran görüntüsü 2026-04-17 110952" src="https://github.com/user-attachments/assets/c60dff9f-9f73-4ec4-a1b2-301004d31726" />
<img width="462" height="1002" alt="Ekran görüntüsü 2026-04-17 111019" src="https://github.com/user-attachments/assets/6d57003d-2740-4e75-9f73-4b00ff9f8492" />

Eğitim: Flutter Günlük Eğitim Programı
📋 Proje Açıklaması
Mini Katalog, wantapi.com'dan gelen gerçek ürün verileriyle çalışan bir mobil alışveriş kataloğudur.
Kullanıcılar ürünleri kategoriye göre filtreleyebilir, favorilerine ekleyebilir, sepete atabilir ve karanlık mod ile aydınlık mod arasında geçiş yapabilir.
✨ Özellikler

🔍 Gerçek zamanlı ürün arama
🗂️ Kategori bazlı filtreleme (iPhone, MacBook, iPad vb.)
❤️ Favorilere ekleme ve favori listesi sayfası
🛒 Sepet yönetimi (ekleme / çıkarma / toplam fiyat)
🌙 Karanlık mod / Aydınlık mod desteği
📄 Ürün detay sayfası (açıklama + özellikler tablosu)
🌐 REST API entegrasyonu

🛠️ Kullanılan Teknolojiler
TeknolojiVersiyonFlutter3.xDart3.xhttp paketi^1.2.0Material Design3


🚀 Çalıştırma Adımları
Gereksinimler

Flutter SDK kurulu olmalıdır → flutter.dev
Android Studio veya VS Code kurulu olmalıdır
Bir Android emülatör veya fiziksel cihaz bağlı olmalıdır

Adımlar
bash# 1. Projeyi klonla
git clone https://github.com/sahinyusufemin82/mini_katalog.git

# 2. Proje klasörüne gir
cd mini_katalog

# 3. Bağımlılıkları yükle
flutter pub get

# 4. Uygulamayı başlat
flutter run

📁 Proje Klasör Yapısı
mini_katalog/
├── assets/
│   └── banner.png
├── lib/
│   ├── main.dart                        # Uygulama giriş noktası, tema yönetimi
│   ├── models/
│   │   └── product.dart                 # Ürün veri modeli
│   ├── services/
│   │   └── api_service.dart             # HTTP istekleri
│   ├── screens/
│   │   ├── home_screen.dart             # Ana sayfa (Discover)
│   │   ├── product_detail_screen.dart   # Ürün detay sayfası
│   │   ├── cart_screen.dart             # Sepet sayfası
│   │   └── favorites_screen.dart        # Favoriler sayfası
│   └── widgets/
│       └── product_card.dart            # Yeniden kullanılabilir ürün kartı
├── pubspec.yaml
└── README.md
