import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

class ConfirmationDialog extends ConsumerWidget {
  const ConfirmationDialog({
    super.key,
    required this.message,
    this.positiveButtonLabel,
    this.showCancelButton = true,
  });

  final String message;
  final String? positiveButtonLabel;
  final bool showCancelButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(8),
          Row(
            children: [
              if (positiveButtonLabel != null)
                Expanded(
                  child: TextButton(
                    style: const ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () => Navigator.pop(
                      context,
                      true,
                    ),
                    child: Text(positiveButtonLabel!),
                  ),
                ),
              if (showCancelButton)
                Expanded(
                  child: TextButton(
                    style: const ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () => Navigator.pop(
                      context,
                      false,
                    ),
                    child: Text(
                      settings.selectedLocale!.translate(
                        'Cancel',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
