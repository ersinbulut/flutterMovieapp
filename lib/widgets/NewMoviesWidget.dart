// Yeni Filmler Widget'ı
import 'package:flutter/material.dart';

class NewMoviesWidget extends StatelessWidget {
  // Film listesi gibi parametreler eklenecek
  const NewMoviesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Yeni filmlerin yatay listesi buraya eklenecek
      child: Center(child: Text('Yeni Filmler Widget', style: TextStyle(color: Colors.white54))),
    );
  }
} 