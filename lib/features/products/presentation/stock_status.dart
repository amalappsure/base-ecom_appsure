import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

class StockStatus extends ConsumerWidget {
  const StockStatus({
    super.key,
    this.inStock = false,
  });

  final bool inStock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const green = Color(0xFF28A745);
    final color = inStock ? green : Theme.of(context).colorScheme.error;
    final bgColor = inStock
        ? green.withOpacity(0.1)
        : Theme.of(context).colorScheme.errorContainer;

    final settings = ref.watch(settingsProvider);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 0.0,
      ),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: bgColor,
        border: Border.all(
          color: color,
          width: 0.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        settings.selectedLocale!.translate(inStock ? 'InStock' : 'Outofstock'),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: color,
        ),
      ),
    );
  }
}
