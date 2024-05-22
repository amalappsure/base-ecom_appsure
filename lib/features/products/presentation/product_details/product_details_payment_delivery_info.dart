import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/checkout/presentation/delivery_options.dart';
import 'package:base_ecom_appsure/features/checkout/presentation/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/product_details.dart';
import 'package:base_ecom_appsure/features/products/providers/product_details_provider.dart';
import 'package:base_ecom_appsure/foundation/utils.dart';

class ProductDetailsPaymentDeliveryInfo extends ConsumerWidget {
  const ProductDetailsPaymentDeliveryInfo({
    super.key,
    required this.productId,
    required this.details,
  });

  final int productId;
  final ProductDetails details;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final appConfig = ref.read(appConfigProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (appConfig.showPaymentMethodsInDetailPage) ...[
          Text(
            capitalizeFirstLetterOfEachWord(
              settings.selectedLocale!.translate(
                'AvailablePaymentMethods',
              ),
            ),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          Consumer(
            builder: (context, ref, child) =>
                ref.watch(paymentMethodsProvider(productId)).when(
                  onLoading: () => const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator.adaptive()],
                  ),
                  onSuccess: (data) => PaymentMethodsChooser(
                    paymentMetods: data,
                  ),
                  onError: (error) => const SizedBox.shrink(),
                ),
          )
        ],
        if (appConfig.showEstimatedDeliveryCaption &&
            details.itemDeliveryOptions.isNotEmpty) ...[
          const Gap(16),
          Text(
            capitalizeFirstLetterOfEachWord(
              settings.selectedLocale!.translate(
                'DeliveryOptions',
              ),
            ),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(8),
          DeliveryOptions(
            deliveryOptions: details.itemDeliveryOptions,
          )
        ],
      ],
    );
  }
}
