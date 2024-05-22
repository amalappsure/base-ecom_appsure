import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

class AddToCartButton extends ConsumerWidget {
  const AddToCartButton({
    super.key,
    this.padding = EdgeInsets.zero,
    this.onPressed,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.label,
    this.gap = 6,
    this.iconSize = 18.0,
  });

  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final String? label;
  final double gap;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? Colors.white,
        backgroundColor:
        backgroundColor ?? Theme.of(context).colorScheme.primary,
        padding: padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Iconsax.shopping_cart,
            size: iconSize,
            color: Colors.white,
          ),
          Gap(gap),
          Text(
            label ?? settings.selectedLocale!.translate('AddtoCart'),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
