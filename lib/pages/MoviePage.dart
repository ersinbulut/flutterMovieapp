// Film detay sayfası
import 'package:flutter/material.dart';

// Film detay sayfası widget'ı
// Filmin detaylarını göstermek için StatelessWidget kullanıyoruz
class MoviePage extends StatelessWidget {
  // Filmin verileri için değişkenler
  final String movieImagePath;
  final String movieTitle;
  final String movieDescription;

  // Constructor: Film verilerini zorunlu olarak alır
  const MoviePage({
    Key? key,
    required this.movieImagePath,
    required this.movieTitle,
    required this.movieDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Temel sayfa yapısı için Scaffold widget'ı
    return Scaffold(
      // AppBar: Geri butonu ve Favori ikonu içerir
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Geri ikonu
          onPressed: () {
            Navigator.pop(context); // Geri butonuna basıldığında bir önceki sayfaya dön
          },
        ),
        title: Text(movieTitle, style: TextStyle(color: Colors.white)), // Film başlığı
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white), // Favori ikonu
            onPressed: () {
              // Favori butonuna basıldığında yapılacak işlem (şimdilik boş)
            },
          ),
        ],
        backgroundColor: Color(0xFF0F111D), // AppBar arka plan rengi
        centerTitle: true, // Başlığı ortala
      ),
      // Sayfa içeriği kaydırılabilir yapıldı
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // İçeriği sola hizala
          children: [
            // Film posteri ve oynatma butonu bölümü
            Padding(
              padding: const EdgeInsets.all(16.0), // Kenar boşlukları
              child: Stack(
                children: [
                  // Film poster resmi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                    child: Image.asset(
                      movieImagePath, // Dinamik olarak gelen resim yolu
                      fit: BoxFit.cover, // Resmi uygun şekilde sığdır
                      width: MediaQuery.of(context).size.width, // Genişliği ekran kadar yap
                      height: MediaQuery.of(context).size.height * 0.4, // Ekran yüksekliğinin %40'ı kadar yükseklik
                    ),
                  ),
                  // Oynatma butonu (resmin ortasında)
                  Positioned.fill(
                    child: Center(
                      child: FloatingActionButton(
                        onPressed: () {
                          // Oynatma butonuna basıldığında yapılacak işlem (şimdilik boş)
                        },
                        child: Icon(Icons.play_arrow, size: 50, color: Colors.white), // Oynatma ikonu boyutu ve rengi
                        backgroundColor: Colors.red, // Buton rengi kırmızı olarak güncellendi
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Aksiyon butonları bölümü (+, Kalp, İndir, Paylaş)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Kenar boşlukları
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Butonları eşit aralıklarla yerleştir
                children: [
                  // Ekle butonu
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: 28), // Ekle ikonu boyutu
                    onPressed: () {},
                  ),
                  // Kalp butonu
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white, size: 28), // Kalp ikonu boyutu
                    onPressed: () {},
                  ),
                  // İndir butonu
                  IconButton(
                    icon: Icon(Icons.download, color: Colors.white, size: 28), // İndir ikonu boyutu
                    onPressed: () {},
                  ),
                  // Paylaş butonu
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.white, size: 28), // Paylaş ikonu boyutu
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Film başlığı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Kenar boşlukları
              child: Text(
                movieTitle, // Dinamik olarak gelen film başlığı
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Başlık stili
              ),
            ),

            // Film açıklaması
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Kenar boşlukları
              child: Text(
                movieDescription, // Dinamik olarak gelen film açıklaması
                style: TextStyle(fontSize: 16, color: Colors.white70), // Açıklama stili
              ),
            ),

            // Önerilen Filmler bölüm başlığı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Kenar boşlukları
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended', // Bölüm başlığı güncellendi
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Başlık stili
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All', // Tümünü gör butonu güncellendi
                      style: TextStyle(color: Colors.blueAccent), // Buton stili
                    ),
                  ),
                ],
              ),
            ),

            // Önerilen Filmler listesi yer tutucusu (yatay kaydırılabilir)
            Container(
              height: 200, // Yükseklik artırıldı
              // Yatay kaydırılabilir liste oluşturulacak
               child: ListView(
                        scrollDirection: Axis.horizontal, // Yatay kaydırma
                         children: [
                          // Önerilen film öğeleri buraya eklenecek (şimdilik yer tutucu)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0), // Sol kenar boşluğu
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                                child: Image.asset('images/rec1.jpeg', fit: BoxFit.cover, height: 200, width: 140) // Örnek resim eklendi
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left: 8.0), // Resimler arası boşluk
                             child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                                child: Image.asset('images/rec2.jpeg', fit: BoxFit.cover, height: 200, width: 140) // Örnek resim eklendi
                            ),
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 16.0), // Son resim sağ kenar boşluğu
                             child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0), // Köşe yuvarlama
                                child: Image.asset('images/rec3.jpeg', fit: BoxFit.cover, height: 200, width: 140) // Örnek resim eklendi
                            ),
                          ),
                        ],
                      ),
            ),
            SizedBox(height: 20), // Sayfa sonuna boşluk
          ],
        ),
      ),
       // Alt navigasyon çubuğu (HomePage ile aynı olacak - burada gösterilmeyecek)
    );
  }
} 