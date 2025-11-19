import 'package:flutter/material.dart';

class BrandItem extends StatelessWidget {
  final String imageUrl;
  final String brandId;
  final void Function(String brandId) onTap;

  const BrandItem({
    required this.imageUrl,
    required this.brandId,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(brandId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black12,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: _buildBrandImage(),
        ),
      ),
    );
  }

  Widget _buildBrandImage() {
    // 🔥 যদি URL ফাঁকা থাকে, সরাসরি লোকাল image দেখাবে
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/tesla_logo.png',
        fit: BoxFit.contain,
      );
    }

    // 🔥 API image + fallback to local image
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/tesla_logo.png',
          fit: BoxFit.contain,
        );
      },
    );
  }
}
