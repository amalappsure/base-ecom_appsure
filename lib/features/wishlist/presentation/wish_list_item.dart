import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/features/products/models/product.dart';
import 'package:base_ecom_appsure/features/products/presentation/product_item_base/product_item_base.dart';
import 'package:base_ecom_appsure/features/wishlist/models/wish_list_item.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';
import 'package:base_ecom_appsure/widgets/responsive_builder.dart';

abstract class WishListItemBase extends ConsumerWidget {
  const WishListItemBase({
    super.key,
    required this.item,
    required this.errorImage,
    required this.globalKey,
    required this.runCartingAnim,
    this.onTap,
    this.onRemoveClicked
  });

  const factory WishListItemBase.widget({
    Key? key,
    required WishListItem item,
    required DecorationImage errorImage,
    required GlobalKey globalKey,
    required RunCartingAnim runCartingAnim,
    VoidCallback? onTap,
    VoidCallback? onRemoveClicked,
  }) = _WishListItemWidget;

  final WishListItem item;
  final DecorationImage errorImage;
  final GlobalKey globalKey;
  final RunCartingAnim runCartingAnim;
  final VoidCallback? onTap;
  final VoidCallback? onRemoveClicked;

  Product get product => Product(
    itemId: item.itemId,
    unitId: item.unitId,
    itemName: item.itemName,
    urlName: item.urlName,
    imagePath: item.itemImage,
    sellingPrice: item.sellingPrice,
    stock: item.stock,
    existInWishlist: true,
  );
}

class _WishListItemWidget extends WishListItemBase {
  const _WishListItemWidget({
    super.key,
    required super.item,
    required super.errorImage,
    required super.globalKey,
    required super.runCartingAnim,
    super.onTap,
    super.onRemoveClicked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
              SizedBox(
                width: Responsive.valueWhen(
                  context: context,
                  mobile: MediaQuery.of(context).size.width * 0.4,
                  smallTablet: MediaQuery.of(context).size.width * 0.3,
                  mediumTablet: MediaQuery.of(context).size.width * 0.2,
                  largeTablet: MediaQuery.of(context).size.width * 0.15,
                  desktop: MediaQuery.of(context).size.width * 0.15,
                ),
                height: Responsive.valueWhen(
                  context: context,
                  mobile: MediaQuery.of(context).size.width * 0.4,
                  smallTablet: MediaQuery.of(context).size.width * 0.3,
                  mediumTablet: MediaQuery.of(context).size.width * 0.2,
                  largeTablet: MediaQuery.of(context).size.width * 0.15,
                  desktop: MediaQuery.of(context).size.width * 0.15,
                ),
                child: CachedNetworkImage(
                  cacheKey: item.itemId.toString(),
                  imageUrl: item.itemImage ?? '',
                  imageBuilder: (context, imageProvider) => ProductImage(
                    product: product,
                    decorationImage: DecorationImage(image: imageProvider),
                  ),
                  errorWidget: (context, url, error) => ProductImage(
                    product: product,
                    decorationImage: errorImage,
                  ),
                  progressIndicatorBuilder: (context, url, progress) =>
                      ProductImage(
                        product: product,
                        decorationImage: null,
                      ),
                  fit: BoxFit.cover,
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
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(12),
                    Text(
                      settings.priceText(item.sellingPrice),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // const Gap(12),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ProductCartButton(
                            product: product,
                            globalKey: globalKey,
                            runCartingAnim: runCartingAnim,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                          ),
                        ),
                        const Gap(6),
                        IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onRemoveClicked,
                          icon: const Icon(
                            FontAwesomeIcons.trashCan,
                          ),
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
        ),
      ),
    );
  }
}
