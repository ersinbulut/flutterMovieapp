// Gerekli Flutter material kütüphanesini içeri aktar
import 'package:flutter/material.dart';
import 'package:movie_app/database_helper.dart'; // DatabaseHelper'ı içeri aktar
import 'package:movie_app/models/category.dart'; // Category modelini içeri aktar

// Kategori sayfası widget'ı
// Durum yönetimi gerektirmediği için StatelessWidget kullanılır
// Veritabanından veri çekmek için StatefulWidget'a dönüştürüldü
class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Veritabanından çekilen kategori listesi
  List<Category> _categories = [];
  // Veri yükleniyor mu kontrolü
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Kategorileri yükle
  }

  // Kategorileri veritabanından asenkron olarak yükleyen fonksiyon
  Future<void> _loadCategories() async {
    final dbHelper = DatabaseHelper();
    final categories = await dbHelper.getCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  // Constructor
  // const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Temel sayfa yapısı için Scaffold widget'ı
    return Scaffold(
      // Sayfa başlığı (AppBar)
      appBar: AppBar(
        // Geri butonu
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Geri ikonu ve rengi
          onPressed: () {
            // Geri butonuna basıldığında yapılacak işlem (şimdilik boş)
            Navigator.pop(context); // Önceki sayfaya dönmek için kullanılabilir
          },
        ),
        // Başlık metni
        title: Text(
          'Kategoriler', // Başlık 'Keşfet'ten 'Kategoriler' olarak güncellendi
          style: TextStyle(color: Colors.white), // Başlık metni rengi
        ),
        // AppBar arka plan rengi (ana temadaki renk ile aynı)
        backgroundColor: Color(0xFF0F111D),
        // Başlığın ortalanması
        centerTitle: true,
      ),
      // Sayfa içeriği
      body: _isLoading // Veri yükleniyorsa Indicator göster
          ? Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              // Liste elemanlarının sayısı (veritabanından çekilen kategori sayısına göre ayarlanacak)
              itemCount: _categories.length,
              // Her bir liste elemanını oluşturan fonksiyon
              itemBuilder: (context, index) {
                final category = _categories[index];
                // Liste elemanı (Örnek: Resim, Kategori Adı, Ok ikonu)
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Kenar boşlukları
                  child: Row(
                    children: [
                      // Kategori resmi
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                        child: Image.network(
                          category.imageUrl, // Kategori modelinden gelen resim URL'si
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16), // Resim ve metin arasına boşluk
                      // Kategori adı metni
                      Expanded(
                        child: Text(
                          category.name, // Kategori modelinden gelen ad
                          style: TextStyle(fontSize: 18, color: Colors.white), // Metin stili
                        ),
                      ),
                      // İleri ok ikonu
                      Icon(Icons.chevron_right, color: Colors.white54), // Ok ikonu ve rengi
                    ],
                  ),
                );
              },
            ),
      // Alt navigasyon çubuğu (HomePage ile aynı olacak)
      // Bu sayfa alt navigasyonun bir sekmesi olacağı için BottomNavigationBar burada tekrar tanımlanmaz.
      // Ancak örnek olması için yoruma alarak gösterebiliriz.
      /*
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0F111D),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoriler',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
      */
    );
  }
} 