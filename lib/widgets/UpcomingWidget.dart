// Yaklaşan Filmler Widget'ı
import 'package:flutter/material.dart';

class UpcomingWidget extends StatelessWidget {
   // Film listesi gibi parametreler eklenecek
  const UpcomingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Yaklaşan filmlerin yatay listesi buraya eklenecek
      child: Center(child: Text('Yaklaşan Filmler Widget', style: TextStyle(color: Colors.white54))),
    );
  }
} 