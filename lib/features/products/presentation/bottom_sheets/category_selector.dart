import 'package:base_ecom_appsure/features/products/providers/products_list_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/home/models/category.dart';

class CategorySelectorBS extends ConsumerWidget {
  const CategorySelectorBS({
    required this.family,
    required this.selected,
    this.categories = const [],
    super.key,
  });

  final Category? selected;
  final String family;
  final List<Category> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(catFilProvider(family));
    final settings = ref.watch(settingsProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 8.0),
            child: Text(
              settings.selectedLocale!.translate('Categories'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (this.categories.isNotEmpty)
            _list(this.categories)
          else
            categories.when(
              onLoading: () => const SizedBox(height: 8.0),
              onSuccess: (data) => _list(data),
              onError: (error) => const SizedBox(height: 8.0),
            ),
        ],
      ),
    );
  }

  Widget _list(List<Category> data) {
    return ListView.separated(
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
              data[index].title,
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
    );
  }
}
