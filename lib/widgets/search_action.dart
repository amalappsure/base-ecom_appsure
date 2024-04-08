import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchAction extends StatelessWidget {
  const SearchAction({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: const Icon(Iconsax.search_normal_1),
      tooltip: 'Search',
    );
  }
}
