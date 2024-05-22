import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

class CategoryTile extends ConsumerWidget {
  const CategoryTile({
    super.key,
    required this.category,
    this.onSubcategoryTapped,
  });

  final Category category;
  final ValueChanged<Category>? onSubcategoryTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18.0,
          ),
        ),
        collapsedIconColor: const Color(0xFFADADAD),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: settings.selectedLocale!
            .subCategoriesOf(category.id)
            .map(
              (f) => TextButton(
            onPressed: onSubcategoryTapped == null
                ? null
                : () => onSubcategoryTapped!(f),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  f.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 18.0,
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
