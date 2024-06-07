import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/features/products/models/sort_method.dart';
import 'package:base_ecom_appsure/features/products/presentation/bottom_sheets/availability_selector.dart';
import 'package:base_ecom_appsure/features/products/presentation/bottom_sheets/category_selector.dart';
import 'package:base_ecom_appsure/features/products/presentation/bottom_sheets/price_selector.dart';
import 'package:base_ecom_appsure/features/products/presentation/bottom_sheets/sort_method_selector.dart';
import 'package:base_ecom_appsure/features/products/providers/products_list_provider.dart';

class SortMethodChooser extends ConsumerWidget {
  const SortMethodChooser({
    super.key,
    required this.family,
  });

  final String family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final provider = ref.watch(productListProvider(family));
    final sortData = provider.sortBy;
    String label;
    if (sortData?.value == null || sortData!.value.isEmpty) {
      label = settings.selectedLocale!.translate('Sortby');
    } else {
      label = sortData.value;
    }

    return ChooserContainer(
      onTap: () => showBS(context, provider),
      label: label,
      active: provider.sortBy != null,
    );
  }

  Future<void> showBS(
      BuildContext context,
      CategoryProductsProvider provider,
      ) async {
    final result = await showModalBottomSheet<SortMethod?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) => SortMethodSelectorBS(
        selected: provider.sortBy,
        family: family,
      ),
    );

    if (result != null) {
      provider.updateSortBy(result);
    }
  }
}

class CategoryChooser extends ConsumerWidget {
  const CategoryChooser({
    required this.family,
    this.categories = const [],
    super.key,
  });

  final String family;
  final List<Category> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(productListProvider(family));
    final settings = ref.watch(settingsProvider);
    String label;
    if (provider.category?.title == null || provider.category!.title.isEmpty) {
      label = settings.selectedLocale!.translate('Categories');
    } else {
      label = provider.category!.title;
    }

    return ChooserContainer(
      onTap: () => showBS(context, provider),
      label: label,
      active: provider.category != null,
    );
  }

  Future<void> showBS(
      BuildContext context,
      CategoryProductsProvider provider,
      ) async {
    final result = await showModalBottomSheet<Category?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) => CategorySelectorBS(
        selected: provider.category,
        family: family,
        categories: categories,
      ),
    );

    if (result != null) {
      provider.setCategory(result);
    }
  }
}

class PriceChooser extends ConsumerWidget {
  const PriceChooser({
    super.key,
    required this.family,
  });

  final String family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(productListProvider(family));
    final settings = ref.watch(settingsProvider);
    final numbers = provider.selectedPricePairs;

    String label;
    if (numbers == null || numbers.isEmpty) {
      label = settings.selectedLocale!.translate('Price');
    } else {
      label = 'KD ${numbers.first.toInt()} - KD ${numbers.last.toInt()}';
    }

    return ChooserContainer(
      onTap: () => showBS(context, provider),
      label: label,
      active: provider.selectedPricePairs != null,
    );
  }

  Future<void> showBS(
      BuildContext context,
      CategoryProductsProvider provider,
      ) async {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) => PriceSelectorBS(
        family: family,
      ),
    );
  }
}

class ChooserContainer extends StatelessWidget {
  const ChooserContainer({
    super.key,
    required this.label,
    this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 12.0,
        ).copyWith(
          right: isRtl ? 12.0 : 4.0,
          left: isRtl ? 4.0 : 12.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFADADAD),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }
}

class AvailabilityChooser extends ConsumerWidget {
  const AvailabilityChooser({
    required this.family,
    super.key,
  });

  final String family;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final provider = ref.read(productListProvider(family));
    return ChooserContainer(
      onTap: () => showBS(context, provider),
      label: settings.selectedLocale!.translate('Availability'),
      active: provider.showOutOfStock,
    );
  }

  Future<void> showBS(
      BuildContext context,
      CategoryProductsProvider provider,
      ) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (context) => AvailabilitySelectorBS(
        family: family,
      ),
    );
  }
}
