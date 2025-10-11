import 'package:flutter/material.dart';

class BrandItem extends StatelessWidget {
  final String imagePath;
  const BrandItem({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 70,
        height: 70,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),

    );
  }
}
