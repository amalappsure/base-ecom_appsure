import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/models/cart_item.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';

class CheckoutItem extends ConsumerWidget {
  const CheckoutItem({
    super.key,
    required this.item,
    required this.onTap,
    this.errorImagePath,
  });

  final CartItem item;
  final ValueChanged<CartItem>? onTap;
  final String? errorImagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final cart = ref.watch(cartProvider);

    return GestureDetector(
      onTap: () => onTap?.call(item),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children : [
            Flexible(
              flex: 2,
              child: CachedNetworkImage(
                height: 100,
                width: 100,
                imageUrl:
                item.itemImage ?? '',
                errorWidget: (context, url, error) =>
                    _imageContainer(
                      context,
                      errorImagePath != null
                          ? DecorationImage(
                          image:
                          AssetImage(errorImagePath!))
                          : null,
                    ),
                imageBuilder: (context, imageProvider) =>
                    _imageContainer(
                      context,
                      DecorationImage(image: imageProvider),
                    ),
                progressIndicatorBuilder:
                    (context, url, progress) => _imageContainer(
                  context,
                  null,
                ),
              ),
            ),
            Gap(5),
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.itemName ?? '',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _titleAndValue(
                        context,
                        settings.selectedLocale!.translate('Unit'),
                        item.unit ?? '',
                        CrossAxisAlignment.start,
                      ),
                      _titleAndValue(
                        context,
                        settings.selectedLocale!.translate('Quantity'),
                        item.quantity.toString(),
                        CrossAxisAlignment.center,
                      ),
                      _titleAndValue(
                        context,
                        settings.selectedLocale!.translate('Sub total'),
                        settings
                            .priceText(cart.totalPriceOf(item.itemId, item.unitId)),
                        CrossAxisAlignment.end,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Column _titleAndValue(
      BuildContext context,
      String title,
      String value,
      CrossAxisAlignment alignment,
      ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _imageContainer(
      BuildContext context,
      DecorationImage? decorationImage, {
        GlobalKey? globalKey,
      }) =>
      InteractiveViewer(
        child: Container(
          margin: const EdgeInsets.all(4),
          child: decorationImage != null
              ? Container(
            key: globalKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: decorationImage,
              ),
            ),
          )
              : const Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
}
