import 'package:base_ecom_appsure/features/products/providers/products_list_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceSelectorBS extends ConsumerWidget {
  const PriceSelectorBS({
    required this.family,
    super.key,
  });

  final String family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final provider = ref.read(productListProvider(family));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
            child: Text(
              settings.selectedLocale!.translate('Price'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.pricePairs.length,
            itemBuilder: (context, index) => TextButton(
              onPressed: () {
                provider.selectedPricePairs = provider.pricePairs[index];
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label(provider.pricePairs[index]),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (provider.selectedPricePairs == provider.pricePairs[index])
                    const Icon(
                      Icons.check_rounded,
                      size: 18.0,
                    ),
                ],
              ),
            ),
            separatorBuilder: (context, index) => const Divider(
              endIndent: 12,
              indent: 12,
              thickness: 0.0,
              height: 1.0,
            ),
          )
        ],
      ),
    );
  }

  String label(List<num> numbers) {
    return 'KD ${numbers.first.toInt()} - KD ${numbers.last.toInt()}';
  }
}
