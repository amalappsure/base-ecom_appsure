import 'package:base_ecom_appsure/features/products/providers/products_list_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AvailabilitySelectorBS extends ConsumerWidget {
  const AvailabilitySelectorBS({
    required this.family,
    super.key,
  });

  final String family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final provider = ref.watch(productListProvider(family));

    onChanged(bool? value) {
      provider.showOutOfStock = (value ?? false);
      Future.delayed(
        const Duration(milliseconds: 600),
            () => Navigator.of(context).pop(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
            child: Text(
              settings.selectedLocale!.translate('Availability'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(!provider.showOutOfStock),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: provider.showOutOfStock,
                    onChanged: onChanged,
                  ),
                  Text(
                    settings.selectedLocale!.translate('Include Out of Stock'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const Gap(16.0)
        ],
      ),
    );
  }
}
