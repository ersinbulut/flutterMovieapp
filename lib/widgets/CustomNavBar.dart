// Özel Alt Navigasyon Çubuğu Widget'ı
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  // İhtiyaca göre parametreler eklenecek (örn: currentIndex, onTap)
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // BottomNavigationBar özellikleri buraya eklenecek
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
    );
  }
} 