import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome ve SystemUiMode için gerekli
import 'package:movie_app/pages/LoginPage.dart';
import 'package:movie_app/database_helper.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/category.dart';
import 'package:firebase_core/firebase_core.dart';

// Uygulamanın başlangıç noktası
// MyApp widget'ını çalıştırır
void main() async { // main fonksiyonunu async yapıyoruz
  WidgetsFlutterBinding.ensureInitialized(); // Flutter binding'lerin başlatıldığından emin ol
  await Firebase.initializeApp();
  await DatabaseHelper().database; // Veritabanını başlat
  await _addInitialData(); // Başlangıç verilerini ekle
  runApp(const MyApp());
}

// Başlangıç film ve kategori verilerini eklemek için yardımcı fonksiyon
Future<void> _addInitialData() async {
  final dbHelper = DatabaseHelper();

  // Örnek film verileri (HomePage.dart dosyasından alınanlar ve eklemeler)
  final List<Movie> initialMovies = [
    Movie(
      title: 'Çakallarla Dans 6',
      description: 'Bu ilk yaklaşan filmin örnek açıklaması. Detaylar burada yer alacak.',
      imagePath: 'images/up1.jpg', // Yerel resim yolu
      category: 'Komedi',
      rating: 7.0,
    ),
    Movie(
      title: 'Lanetli Göl',
      description: 'Bu ikinci yaklaşan filmin örnek açıklaması. Detaylar burada yer alacak.',
      imagePath: 'images/up2.jpeg', // Yerel resim yolu
      category: 'Korku',
      rating: 5.5,
    ),
     Movie(
      title: 'Emanet', // Örnek film adı
      description: 'Bu ilk yeni filmin örnek açıklaması. Detaylar burada yer alacak.', // Film açıklaması
      imagePath: 'images/new1.jpg', // Film resmi
      category: 'Aksiyon',
      rating: 8.5,
    ),
    Movie(
      title: 'Gerçek Ötesi', // Film başlığı
      description: 'Bu ikinci yeni filmin örnek açıklaması. Detaylar burada yer alacak.', // Film açıklaması
      imagePath: 'images/new2.jpg', // Film resmi
      category: 'Gerilim',
      rating: 7.8,
    ),
     // Diğer filmleri buraya ekleyebilirsiniz
  ];

  // Örnek kategori verileri
  final List<Category> initialCategories = [
    Category(name: 'Aksiyon', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
    Category(name: 'Komedi', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
    Category(name: 'Aşk', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
    Category(name: 'Dram', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
    Category(name: 'Korku', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
    Category(name: 'Gerilim', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
    Category(name: 'Fantastik', imageUrl: 'https://img.tamindir.com/2022/03/476720/kaptan-amerika-filmleri-hangi-sirayla-izlenir.jpg'),
  ];

  // Filmleri veritabanına ekle
  for (var movie in initialMovies) {
    await dbHelper.insertMovie(movie);
  }

  // Kategorileri veritabanına ekle
  for (var category in initialCategories) {
    await dbHelper.insertCategory(category);
  }
}

// StatefulWidget kullanarak durum yönetimi yapabilen ana uygulama widget'ı
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF0F111D),
      ),
      home: LoginPage(),
    );
  }
}

