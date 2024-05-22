import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/models/custom_locale.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:iconsax/iconsax.dart';

class ChooseLanguageAction extends ConsumerWidget {
  const ChooseLanguageAction({super.key, this.color});

  final bool? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final enable = ref.read(appConfigProvider).languageSwitching;

    if (!enable) return const SizedBox.shrink();
    return PopupMenuButton<CustomLocale>(
      padding: EdgeInsets.zero,
      iconSize: 16.0,
      itemBuilder: (context) => settings.locales
          .map((e) => PopupMenuItem(
        value: e,
        child: Text(e.displayName.toUpperCase()),
      ))
          .toList(),
      tooltip: 'Choose language',
      initialValue: settings.selectedLocale!,
      onSelected: (value) => settings.selectedLocale = value,
      icon: Row(
        children: [
          Text(
            settings.selectedLocale!.locale.languageCode.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color == true ?Colors.black:Colors.white,
            ),
          ),
          const Gap(3),
          Icon(
            Iconsax.arrow_down_14,
            color: color == true ?Colors.black:Colors.white,
          ),
        ],
      ),
    );
  }
}
