import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

import 'package:base_ecom_appsure/features/products/models/product.dart';
import 'package:gap/gap.dart';
import 'count_downer.dart';

class DiscountPercentage extends ConsumerWidget {
  const DiscountPercentage({
    super.key,
    required this.verticalMargin,
    required this.horizontalMargin,
    required this.percentage,
    required this.product,
  });

  final double verticalMargin;
  final double horizontalMargin;
  final int percentage;
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final topLeft =
    isRtl ? const Radius.circular(2) : const Radius.circular(16);
    final topRight =
    isRtl ? const Radius.circular(16) : const Radius.circular(2);
    return Container(
      padding: const EdgeInsets.all(2),
      margin: EdgeInsets.only(
        top: verticalMargin,
        left: isRtl ? 0.0 : horizontalMargin,
        right: isRtl ? horizontalMargin : 0.0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/offeryellowbackground.jpg'),
          fit: BoxFit.cover, // This ensures the image covers the whole container
        ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(2),
          topRight: const Radius.circular(2),
          bottomLeft: const Radius.circular(2),
          bottomRight: const Radius.circular(2),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // if (product.discountPercentage != null)
          Text(
            '$percentage% ${settings.selectedLocale!.translate('Off')}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12
            ),
          ),
          // Gap(6),
          // CountDowner(
          //   endDate: product.endDate!=null?product.endDate!:DateTime.now(),
          //   small: true,
          // ),
        ],
      )
    );
  }
}
