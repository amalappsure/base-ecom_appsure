import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/checkout/providers/checkout_provider.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/item_delivery_option.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';

class DeliveryOptions extends StatelessWidget {
  const DeliveryOptions({
    super.key,
    required this.deliveryOptions,
    this.groupValue,
    this.onChanged,
  });

  final List<ItemDeliveryOption> deliveryOptions;
  final ItemDeliveryOption? groupValue;
  final ValueChanged<ItemDeliveryOption?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: deliveryOptions.length,
      itemBuilder: (context, index) => _DeliveryOption(
        option: deliveryOptions[index],
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      separatorBuilder: (context, index) => const Gap(8),
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  const _DeliveryOption({
    required this.option,
    this.groupValue,
    this.onChanged,
  });

  final ItemDeliveryOption option;
  final ItemDeliveryOption? groupValue;
  final ValueChanged<ItemDeliveryOption?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(option),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: option == groupValue
              ? Border.all(
            color: Theme.of(context).colorScheme.primary,
          )
              : Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          boxShadow: const [shadow1],
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (onChanged != null) ...[
              Radio.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.comfortable,
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              const Gap(8)
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option.title ?? option.deliveryOption ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final settings = ref.read(settingsProvider);
                          return ref.watch(areaDetails).when(
                            onLoading: () => const SizedBox.shrink(),
                            onSuccess: (data) {
                              double charge;
                              if (option.title?.contains('Normal') ?? false) {
                                charge = data.deliveryCharge;
                              } else {
                                charge = data.fastDeliveryCharge;
                              }

                              return Text(
                                settings.priceText(charge),
                                style: Theme.of(context).textTheme.bodyLarge,
                              );
                            },
                            onError: (error) => const SizedBox.shrink(),
                          );
                        },
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    option.deliveryTerms ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
