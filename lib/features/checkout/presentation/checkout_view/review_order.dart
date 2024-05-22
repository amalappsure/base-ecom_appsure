import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class ReviewOrder extends ConsumerWidget {
  const ReviewOrder({
    super.key,
    required this.giftWrapEnabled,
    required this.remarksController,
    required this.giftWrapController,
    required this.deliveryCharge,
    required this.onGiftWrapChanged,
  });

  final bool giftWrapEnabled;
  final TextEditingController remarksController;
  final TextEditingController giftWrapController;
  final double deliveryCharge;
  final ValueChanged<bool?> onGiftWrapChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final cart = ref.watch(cartProvider);
    final appConfig = ref.read(appConfigProvider);
    return DefaultCard(
      margin: EdgeInsets.zero,
      border: Border.all(
        color: Theme.of(context).dividerColor.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _labelAndValue(
            context,
            "${settings.selectedLocale!.translate('ItemTotal')}"
                " (${cart.itemsCount} "
                "${settings.selectedLocale!.translate('items')})",
            settings.priceText(cart.cartValue.toDouble()),
          ),
          if (deliveryCharge > 0)
            _labelAndValue(
              context,
              settings.selectedLocale!.translate('DeliveryCharges'),
              settings.priceText(deliveryCharge),
            ),
          _labelAndValue(
            context,
            settings.selectedLocale!.translate('SubTotal'),
            settings.priceText(
              cart.cartValue.toDouble() + deliveryCharge,
            ),
          ),
          const Divider(),
          if (cart.totalPromoDiscount > 0)
            _labelAndValue(
              context,
              settings.selectedLocale!.translate('PromoCodeDiscount'),
              settings.priceText(cart.totalPromoDiscount),
            ),
          _labelAndValue(
            context,
            settings.selectedLocale!.translate(
              'Total',
            ),
            settings.priceText(
              cart.cartValue.toDouble() -
                  cart.totalPromoDiscount +
                  deliveryCharge,
            ),
            fontWeight: FontWeight.w600,
          ),
          if (appConfig.enableGiftWrapping) ...[
            const Divider(),
            Row(
              children: [
                Checkbox(
                  value: giftWrapEnabled,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: onGiftWrapChanged,
                ),
                const Gap(6),
                Text(
                  settings.selectedLocale!.translate(
                    'GiftWrapping',
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstCurve: const Interval(
                0.0,
                0.6,
                curve: Curves.fastOutSlowIn,
              ),
              secondCurve: const Interval(
                0.4,
                1.0,
                curve: Curves.fastOutSlowIn,
              ),
              sizeCurve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 200),
              crossFadeState: giftWrapEnabled
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  const Gap(6),
                  TextFieldWithTitleBase.widget(
                    label: settings.selectedLocale!.translate(
                      'GiftWrapMessage',
                    ),
                    controller: giftWrapController,
                    minLines: 3,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                  ),
                  const Gap(6)
                ],
              ),
            ),
          ],
          if (appConfig.eableRemarksInSalesOrder) ...[
            const Divider(),
            const Gap(6),
            TextFieldWithTitleBase.widget(
              label: settings.selectedLocale!.translate('Remarks'),
              controller: remarksController,
              minLines: 3,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
            )
          ],
        ],
      ),
    );
  }

  Row _labelAndValue(
      BuildContext context,
      String label,
      String value, {
        FontWeight fontWeight = FontWeight.w400,
      }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: fontWeight,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: fontWeight,
            ),
          ),
        ],
      );
}
