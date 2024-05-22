import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchAction extends StatelessWidget {
  const SearchAction({
    super.key,
    this.onPressed,
    this.color,
  });

  final VoidCallback? onPressed;
  final bool? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: Icon(Iconsax.search_normal_1, color: color == true ? Colors.black : Colors.white),
      tooltip: 'Search',
    );
  }
}
