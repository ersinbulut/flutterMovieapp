import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// CategoryPage sayfasını kullanabilmek için içeri aktarıyoruz (DiscoverPage yerine)
import 'package:movie_app/pages/CategoryPage.dart';
// Film detay sayfasını kullanabilmek için MoviePage sayfasını içeri aktarıyoruz
import 'package:movie_app/pages/MoviePage.dart';
import 'package:movie_app/database_helper.dart'; // DatabaseHelper'ı içeri aktar
import 'package:movie_app/models/movie.dart'; // Movie modelini içeri aktar
import 'package:movie_app/models/user.dart'; // User modelini içeri aktar
import 'package:movie_app/pages/ProfilePage.dart';

// Ana sayfa içeriğini ayrı bir widget olarak tanımlamak iyi bir pratiktir.
// Şimdilik doğrudan HomePageState içinde tutacağız.

// Ana sayfa widget'ı
// Alt navigasyon çubuğundaki sekme değişikliklerini yönetmek için StatefulWidget kullanıyoruz
class HomePage extends StatefulWidget {
  final User currentUser;
  
  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// HomePage widget'ının durumunu yöneten sınıf
class _HomePageState extends State<HomePage> {
  // Aktif olarak seçili olan alt navigasyon sekmesinin indeksi
  int _selectedIndex = 0;
  // Veritabanından çekilen film listesi
  List<Movie> _movies = [];
  // Veri yükleniyor mu kontrolü
  bool _isLoading = true;

  // Gösterilecek sayfaların listesi
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadMovies(); // Filmleri yükle
    
    // Sayfaları başlat
    _pages = [
      _HomePageContent(
        isLoading: _isLoading,
        movies: _movies,
        currentUser: widget.currentUser,
        onProfileTap: () {
           setState(() {
            _selectedIndex = 3; // Profil sayfasının indeksi (0 tabanlı)
           });
        }, // Profil ikonuna tıklama işlevi
      ),
      CategoryPage(),
      Center(child: Text('Favoriler Sayfası', style: TextStyle(color: Colors.white54))),
      ProfilePage(currentUser: widget.currentUser),
    ];
  }

  // Filmleri veritabanından asenkron olarak yükleyen fonksiyon
  Future<void> _loadMovies() async {
    final dbHelper = DatabaseHelper();
    final movies = await dbHelper.getMovies();
    setState(() {
      _movies = movies;
      _isLoading = false;
      // Filmler yüklendiğinde ana sayfa içeriğini güncelle
      _pages[0] = _HomePageContent(
        isLoading: _isLoading,
        movies: _movies,
        currentUser: widget.currentUser,
        onProfileTap: () {
           setState(() {
            _selectedIndex = 3; // Profil sayfasının indeksi (0 tabanlı)
           });
        }, // Profil ikonuna tıklama işlevi
      );
    });
  }

  // Alt navigasyon çubuğuna basıldığında çağrılan fonksiyon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F111D),
      body: _pages[_selectedIndex],
      // Alt navigasyon çubuğu
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0F111D), // Arka plan rengi
        selectedItemColor: Colors.white, // Seçili öğe rengi
        unselectedItemColor: Colors.white54, // Seçili olmayan öğe rengi
        currentIndex: _selectedIndex, // Aktif olarak seçili olan sekmeyi belirtir
        onTap: _onItemTapped, // Sekmeye basıldığında çağrılacak fonksiyon
        type: BottomNavigationBarType.fixed, // Tüm öğelerin görünür olmasını sağlar
        selectedLabelStyle: TextStyle(fontSize: 12), // Seçili etiket boyutu
        unselectedLabelStyle: TextStyle(fontSize: 12), // Seçili olmayan etiket boyutu
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: _selectedIndex == 0 ? BoxDecoration(
                 color: Colors.blueAccent.withOpacity(0.3), // Seçili öğe arka plan rengi
                 borderRadius: BorderRadius.circular(20),
               ) : null,
              child: Icon(Icons.home), // Ev ikonu
            ),
            label: 'Ana Sayfa', // Sekme adı
          ),
          BottomNavigationBarItem(
             icon: Container(
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: _selectedIndex == 1 ? BoxDecoration(
                 color: Colors.blueAccent.withOpacity(0.3), // Seçili öğe arka plan rengi
                 borderRadius: BorderRadius.circular(20),
               ) : null,
             // Kategori ikonu (resimdeki gibi özel bir ikon yerine şimdilik standart olanı kullanıyoruz)
              child: Icon(Icons.category), 
            ),
            label: 'Kategoriler', // Sekme adı
          ),
          BottomNavigationBarItem(
             icon: Container(
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: _selectedIndex == 2 ? BoxDecoration(
                 color: Colors.blueAccent.withOpacity(0.3), // Seçili öğe arka plan rengi
                 borderRadius: BorderRadius.circular(20),
               ) : null,
             // Favori ikonu
              child: Icon(Icons.favorite_border), 
            ),
            label: 'Favoriler', // Sekme adı
          ),
           BottomNavigationBarItem(
             icon: Container(
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: _selectedIndex == 3 ? BoxDecoration(
                 color: Colors.blueAccent.withOpacity(0.3), // Seçili öğe arka plan rengi
                 borderRadius: BorderRadius.circular(20),
               ) : null,
             // Profil ikonu
              child: Icon(Icons.person_outline), 
            ),
            label: 'Profil', // Sekme adı
          ),
        ],
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  final bool isLoading;
  final List<Movie> movies;
  final User currentUser;
  final VoidCallback onProfileTap;

  const _HomePageContent({
    Key? key,
    required this.isLoading,
    required this.movies,
    required this.currentUser,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve profil resmi bölümü
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kullanıcı karşılama metni
                            Text(
                              'Merhaba ${currentUser.username}',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            // Alt başlık
                            Text(
                              'Ne izlemek istersin?',
                              style: TextStyle(fontSize: 18, color: Colors.white54),
                            ),
                          ],
                        ),
                        // Profil resmi yer tutucusu (tıklanabilir hale getirildi)
                        GestureDetector(
                           onTap: onProfileTap,
                           child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              currentUser.username[0].toUpperCase(),
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arama çubuğu bölümü
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1F222F), // Arama çubuğu arka plan rengi
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Ara',
                          hintStyle: TextStyle(color: Colors.white54),
                          icon: Icon(Icons.search, color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  // Yaklaşan Filmler bölüm başlığı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Yaklaşan Filmler',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Tümünü Gör',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Yaklaşan Filmler listesi (yatay kaydırılabilir)
                  Container(
                    height: 180, // Resimlerin yüksekliğine göre ayarlandı
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.where((movie) => movie.category == 'Komedi' || movie.category == 'Korku').toList().length, // Örnek olarak sadece Komedi ve Korku kategorisindeki filmleri alıyoruz
                      itemBuilder: (context, index) {
                        // Filtrelenmiş filmler listesi
                        final upcomingMovies = movies.where((movie) => movie.category == 'Komedi' || movie.category == 'Korku').toList();
                        final movie = upcomingMovies[index];
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 20.0 : 10.0), // İlk öğeye sol kenar boşluğu ekle
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoviePage(
                                    movieImagePath: movie.imagePath,
                                    movieTitle: movie.title,
                                    movieDescription: movie.description,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(movie.imagePath, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Yeni Filmler bölüm başlığı
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Yeni Filmler',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Tümünü Gör',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Yeni Filmler listesi (yatay kaydırılabilir)
                  Container(
                    height: 290,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.where((movie) => movie.category == 'Aksiyon' || movie.category == 'Gerilim').toList().length, // Örnek olarak sadece Aksiyon ve Gerilim kategorisindeki filmleri alıyoruz
                      itemBuilder: (context, index) {
                        // Filtrelenmiş filmler listesi
                        final newMovies = movies.where((movie) => movie.category == 'Aksiyon' || movie.category == 'Gerilim').toList();
                        final movie = newMovies[index];
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 20.0 : 10.0), // İlk öğeye sol kenar boşluğu ekle
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoviePage(
                                    movieImagePath: movie.imagePath,
                                    movieTitle: movie.title,
                                    movieDescription: movie.description,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(movie.imagePath, fit: BoxFit.cover, height: 200, width: 140),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  movie.title,
                                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 2),
                                // Kategori bilgisini göstermek yerine Tür bilgisini gösterebiliriz veya farklı bir alan ekleyebiliriz
                                 Text(
                                  movie.category ?? '', // Kategori bilgisini göster (null ise boş string)
                                  style: TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 15),
                                    SizedBox(width: 5),
                                    Text(
                                      movie.rating?.toString() ?? 'N/A', // Puan bilgisini göster (null ise N/A)
                                      style: TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Şimdilik boş duruyor, CategoryPage entegrasyonu yapıldığında burası güncellenecek.
                   Container(
                     height: 120, // Kategori resimlerinin boyutuna göre ayarlandı
                     child: Center(child: Text('Kategori Listesi Buraya Gelecek', style: TextStyle(color: Colors.white54)))
                   ),
                ],
              ),
            ),
          );
  }
}
