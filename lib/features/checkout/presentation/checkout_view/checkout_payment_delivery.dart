import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/checkout/models/time_slot.dart';
import 'package:base_ecom_appsure/features/checkout/presentation/delivery_options.dart';
import 'package:base_ecom_appsure/features/checkout/presentation/payment_methods.dart';
import 'package:base_ecom_appsure/features/checkout/providers/checkout_provider.dart';
import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/item_delivery_option.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';
import 'package:base_ecom_appsure/widgets/separated_layouts.dart';
import 'package:base_ecom_appsure/widgets/shimmer.dart';

class CheckoutPaymentDelivery extends ConsumerWidget {
  const CheckoutPaymentDelivery({
    super.key,
    required this.onPaymentMethodChanged,
    required this.onItemDeliveryOptionChanged,
    this.onTimeSlotChanged,
    this.paymentMethod,
    this.deliveryOption,
    this.timeSlot,
  });

  final ValueChanged<PaymentMethod?> onPaymentMethodChanged;
  final ValueChanged<ItemDeliveryOption?> onItemDeliveryOptionChanged;
  final ValueChanged<TimeSlot?>? onTimeSlotChanged;
  final PaymentMethod? paymentMethod;
  final ItemDeliveryOption? deliveryOption;
  final TimeSlot? timeSlot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final appConfig = ref.read(appConfigProvider);
    final enableMultipleDeliveryOption = appConfig.enableMultipleDeliveryOption;
    final enableDeliveryTimeSlots = appConfig.deliveryTimeSlotAllocation;

    return ref.watch(checkoutOptionsProvider).when(
      onLoading: () => CustomShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _container(
              height: 23,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            const Gap(12.0),
            _container(height: 56),
            const Gap(8),
            _container(height: 56),
            const Gap(18.0),
            _container(
              height: 23,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const Gap(12.0),
            _container(height: 95),
            const Gap(8),
            _container(height: 95),
          ],
        ),
      ),
      onSuccess: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _title(
              context,
              settings.selectedLocale!.translate(
                'PaymentMethod',
              ),
            ),
            const Gap(12.0),
            PaymentMethodsChooser(
              paymentMetods: data.paymentMethods,
              onChanged: onPaymentMethodChanged,
              groupValue: paymentMethod,
            ),
            const Gap(18.0),
            if (enableMultipleDeliveryOption) ...[
              _title(
                context,
                settings.selectedLocale!.translate(
                  'ChooseADeliveryOption',
                ),
              ),
              const Gap(12.0),
              DeliveryOptions(
                deliveryOptions: data.deliveryOptions,
                groupValue: deliveryOption,
                onChanged: onItemDeliveryOptionChanged,
              ),
            ],
            if (enableDeliveryTimeSlots) ...[
              const Gap(18.0),
              _title(
                context,
                settings.selectedLocale!.translate(
                  'DeliveryTime',
                ),
              ),
              const Gap(12.0),
              TimeSlotSelector(
                timeSlots: data.timeSlots,
                onChanged: onTimeSlotChanged,
                selectedSlot: timeSlot,
              )
            ],
          ],
        );
      },
      onError: (error) => const SizedBox.shrink(),
    );
  }

  Container _container({
    required double height,
    double width = double.infinity,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.8),
      ),
      width: width,
    );
  }

  Widget _title(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class TimeSlotSelector extends StatelessWidget {
  const TimeSlotSelector({
    super.key,
    required this.timeSlots,
    this.selectedSlot,
    this.onChanged,
  });

  final List<TimeSlot> timeSlots;
  final TimeSlot? selectedSlot;
  final ValueChanged<TimeSlot?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: timeSlots
          .map(
            (e) => GestureDetector(
          onTap: () => onChanged?.call(e),
          child: DefaultCard(
            margin: const EdgeInsets.only(bottom: 6.0),
            border: e == selectedSlot
                ? Border.all(
              color: Theme.of(context).colorScheme.primary,
            )
                : Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.calendar_1),
                    const Gap(8),
                    Text(
                      "${e.slotDate} ${e.day}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio.adaptive(
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        value: e,
                        groupValue: selectedSlot,
                        onChanged: onChanged,
                      ),
                      const Gap(12),
                      const Icon(
                        Iconsax.clock,
                        size: 18,
                      ),
                      const Gap(8),
                      Text(
                        e.slot,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
          .toList(),
    ).separated(
      context,
      separatorBuilder: (context) => const Gap(8),
    );
  }
}
