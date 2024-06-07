import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/models/cart_item.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/features/products/models/product.dart';
import 'package:base_ecom_appsure/features/products/presentation/product_item_base/product_item_base.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';

abstract class CartListItemBase extends ConsumerWidget {
  const CartListItemBase({
    required this.item,
    required this.errorImage,
    this.onTap,
    super.key,
  });

  final CartItem item;
  final DecorationImage errorImage;
  final VoidCallback? onTap;

  const factory CartListItemBase.widget({
    Key? key,
    required CartItem item,
    required DecorationImage errorImage,
    VoidCallback? onTap,
  }) = _CartListItem;

  Product get product => Product(
    itemId: item.itemId,
    unitId: item.unitId,
    itemName: item.itemName,
    urlName: item.urlName,
    imagePath: item.itemImage,
    sellingPrice: item.sellingPrice,
    stock: item.stock,
  );
}

class _CartListItem extends CartListItemBase {
  const _CartListItem({
    super.key,
    required super.item,
    required super.errorImage,
    super.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final cart = ref.watch(cartProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [shadow1],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.35).w,
                  child: CachedNetworkImage(
                    cacheKey: item.itemCode,
                    imageUrl: item.itemImage ?? '',
                    imageBuilder: (context, imageProvider) => ProductImage(
                      product: product,
                      decorationImage: DecorationImage(image: imageProvider,fit: BoxFit.cover),
                      showButtons: false,
                    ),
                    errorWidget: (context, url, error) => ProductImage(
                      product: product,
                      decorationImage: errorImage,
                      showButtons: false,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.itemName ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndValue(
                          context,
                          title: settings.selectedLocale!.translate('Price'),
                          value: settings.priceText(item.sellingPrice),
                        ),
                        titleAndValue(
                          context,
                          title: settings.selectedLocale!.translate('Unit'),
                          value: item.unit ?? '',
                          crossAxisAlignment: CrossAxisAlignment.end,
                        ),
                      ],
                    ),
                    const Gap(8),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.037,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GestureDetector(
                        onTap: () {},
                        behavior: HitTestBehavior.opaque,
                        child: ProductCartButton(
                          product: product,
                          dontShowDropdown: true,
                        ),
                      ),
                    ),
                    // const Gap(8),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 7,
                    //       child: GestureDetector(
                    //         onTap: () {},
                    //         behavior: HitTestBehavior.opaque,
                    //         child: ProductCartButton(
                    //           product: product,
                    //           dontShowDropdown: true,
                    //         ),
                    //       ),
                    //     ),
                    //     const Spacer(flex: 3),
                    //   ],
                    // ),
                    const Gap(6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndValue(
                          context,
                          title: settings.selectedLocale!.translate('Total'),
                          value: settings.priceText(
                            cart.totalPriceOf(product.itemId, product.unitId),
                          ),
                        ),
                        IconButton(
                          onPressed: () => cart.removeFromCart(
                            item.itemId,
                            item.unitId,
                          ),
                          icon: const Icon(FontAwesomeIcons.trashCan),
                          color: Theme.of(context).colorScheme.error,
                          iconSize: 18.0,
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Column titleAndValue(
      BuildContext context, {
        required String title,
        required String value,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
      }) =>
      Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
          ),
          const Gap(1),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
          ),
        ],
      );
}
