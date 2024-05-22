import 'package:base_ecom_appsure/features/products/models/sort_method.dart';
import 'package:base_ecom_appsure/features/products/providers/products_list_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortMethodSelectorBS extends ConsumerWidget {
  const SortMethodSelectorBS({
    required this.family,
    this.selected,
    super.key,
  });

  final String family;
  final SortMethod? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(sortMethodsProvider(family));
    final settings = ref.watch(settingsProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
            child: Text(
              settings.selectedLocale!.translate('Sortby'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          methods.when(
            onLoading: () => const SizedBox(height: 8.0),
            onSuccess: (data) => ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) => TextButton(
                onPressed: () => Navigator.pop(context, data[index]),
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
                      data[index].value,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (selected == data[index])
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
            ),
            onError: (error) => const SizedBox(height: 8.0),
          ),
        ],
      ),
    );
  }
}
