import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/products/providers/products_list_provider.dart';

class ListGridChooser extends ConsumerWidget {
  const ListGridChooser({
    required this.family,
    super.key,
  });

  final String family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(productListProvider(family));
    return GestureDetector(
      onTap: () {
        provider.listView = !provider.listView;
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFADADAD),
          ),
        ),
        child: Icon(
          provider.listView ? Icons.grid_view_rounded : Icons.list_rounded,
          size: 18.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
