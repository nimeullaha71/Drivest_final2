
import 'package:flutter/material.dart';
import '../../widgets/brand_item.dart';

class TopBrandsSection extends StatelessWidget {
  const TopBrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Top Brands',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                print("View all top brands clicked");
              },
              child: Text(
                "view all",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(1, 80, 147, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              BrandItem(imagePath: 'assets/images/bmw_logo.png'),
              BrandItem(imagePath: 'assets/images/brand_logo.png'),
              BrandItem(imagePath: 'assets/images/tesla_logo.png'),
              BrandItem(imagePath: 'assets/images/volvo_logo.png'),
              BrandItem(imagePath: 'assets/images/brand_logo.png'),
              BrandItem(imagePath: 'assets/images/volvo_logo.png'),
              BrandItem(imagePath: 'assets/images/tesla_logo.png'),
              BrandItem(imagePath: 'assets/images/bmw_logo.png'),
            ],
          ),
        ),
      ],
    );
  }
}
