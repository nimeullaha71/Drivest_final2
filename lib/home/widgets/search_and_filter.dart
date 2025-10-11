import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAndFilter extends StatelessWidget {
  final VoidCallback onFilterTap;
  const SearchAndFilter({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search car,brand',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48, height: 48,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(1, 80, 147, 1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onFilterTap,
            icon: SvgPicture.asset('assets/images/filter-circle-svgrepo-com.svg', color: Colors.white),
          ),
        ),
      ],
    );
  }
}
