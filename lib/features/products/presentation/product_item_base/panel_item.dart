part of 'product_item_base.dart';

class _PanelProduct extends ProductBase {
  const _PanelProduct({
    super.key,
    required super.product,
    required this.width,
    this.horizontalMargin = 6.0,
    this.verticalMargin = 6.0,
    super.errorImage,
    required super.globalKey,
    required super.runCartingAnim,
    super.onTap,
  });

  final double width;
  final double horizontalMargin;
  final double verticalMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final appConfig = ref.watch(appConfigProvider);
    if (appConfig.disableZeroStockItems && product.stock <= 0) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            width: width,
            padding: const EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(
              vertical: verticalMargin,
              horizontal: horizontalMargin,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [shadow1],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround ,
                  children: [
                    Responsive(
                      mobile: (context, constraints, child) => AspectRatio(
                        aspectRatio: product.endDate == null ? 1 : 1.1
                        ,
                        child: child,
                      ),
                      desktop: (context, constraints, child) => AspectRatio(
                        aspectRatio: 4 / 3,
                        child: child,
                      ),
                      child: CachedNetworkImage(
                        cacheKey: product.itemCode,
                        imageUrl: product.imagePath ?? '',
                        imageBuilder: (context, imageProvider) => ProductImage(
                          product: product,
                          decorationImage: DecorationImage(
                            image: imageProvider,
                          ),
                          globalKey: globalKey,
                        ),
                        errorWidget: (context, url, error) => ProductImage(
                          product: product,
                          decorationImage: errorImage,
                          globalKey: globalKey,
                        ),
                        progressIndicatorBuilder: (context, url, progress) =>
                            ProductImage(
                              product: product,
                              decorationImage: null,
                              globalKey: globalKey,
                            ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Gap(6.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         WhatsAppLauncher(
                    //           size: 25.0,
                    //           itemName: product.itemName ?? '',
                    //           urlName: product.urlName ?? '',
                    //           unitId: product.unitId,
                    //         ),
                    //         const Gap(5),
                    //         ProductHeart(
                    //           size: 20.0,
                    //           productId: product.itemId,
                    //           unitId: product.unitId,
                    //         ),
                    //       ],
                    //     ),
                    //     ProductRating(rating: product.rating),
                    //   ],
                    // ),
                    // const Gap(3.0),
                    Tooltip(
                      message: product.itemName ?? '',
                      child: Text(
                        product.itemName ?? '',
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.start,
                        maxLines: product.endDate != null ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(6),
                    StatefulBuilder(
                        key: Key(product.id.toString()),
                        builder: (context, setState) {
                          var myGroup = AutoSizeGroup();
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.endDate != null)
                              AutoSizeText(
                                settings.priceText(
                                  product.sellingPrice,
                                  prefixCurrency: settings.selectedLocale!.isEnglish,
                                ),
                                // group: myGroup,
                                maxLines: 1,
                                maxFontSize: 12,
                                minFontSize: 9,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2.0,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    settings.priceText(
                                      product.currentPrice,
                                      prefixCurrency:
                                      settings.selectedLocale!.isEnglish,
                                    ),
                                    // group: myGroup,
                                    maxLines: 1,
                                    maxFontSize: 14,
                                    minFontSize: 10,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  ProductRating(rating: product.rating),
                                ],
                              )
                            ],
                          );
                        }),
                    const Gap(6),
                    if (product.endDate != null)
                    CountDowner(
                      endDate: product.endDate!,
                      small: true,
                    ),
                    const Gap(6),
                    // const Spacer(),
                    ProductCartButton(
                      product: product,
                      globalKey: globalKey,
                      runCartingAnim: runCartingAnim,
                    ),
                  ],
                );
              },
            ),
          ),
          if (product.discountPercentage != null)
          Positioned(
            top: 10.0,
            left: isRtl ? null : 0.0,
            right: isRtl ? 0.0 : null,
            child: DiscountPercentage(
              verticalMargin: verticalMargin,
              horizontalMargin: horizontalMargin,
              product: product,
              percentage: product.discountPercentage!,
            ),
          ),
          Positioned(
              top: 20.0,
              left: isRtl ? 11.0 : 0.0,
              right: isRtl ? 0.0 : 11.0,
              child: Align(
                alignment: isRtl ? Alignment.topLeft : Alignment.topRight,
                child: ProductHeart(
                  size: 20.0,
                  productId: product.itemId,
                  unitId: product.unitId,
                ),
              )
          ),
          Positioned(
              top: 60.0,
              left: isRtl ? 15.0 : 0.0,
              right: isRtl ? 0.0 : 15.0,
              child: Align(
                alignment: isRtl ? Alignment.topLeft : Alignment.topRight,
                child: WhatsAppLauncher(
                  size: 25.0,
                  itemName: product.itemName ?? '',
                  urlName: product.urlName ?? '',
                  unitId: product.unitId,
                ),
              )
          ),
          if (!appConfig.sellOutOfStock && product.stock <= 0)
            Positioned(
                top: MediaQuery.of(context).size.height * 0.13,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    settings.selectedLocale!.translate('Outofstock'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
            )
        ],
      ),
    );
  }
}

class PanelProductShimmer extends StatelessWidget {
  const PanelProductShimmer({
    super.key,
    required this.width,
    required this.horizontalMargin,
    required this.verticalMargin,
  });

  final double width;
  final double horizontalMargin;
  final double verticalMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(0),
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomShimmer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Responsive(
                  mobile: (context, constraints, child) => AspectRatio(
                    aspectRatio: 0.83,
                    child: child,
                  ),
                  desktop: (context, constraints, child) => AspectRatio(
                    aspectRatio: 4 / 3,
                    child: child,
                  ),
                  child: CustomShimmer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: constraints.maxWidth * 1.w,
                  height: 18.0.h,
                  child: const ShimmerContainer(),
                ),
                const Gap(8),
                SizedBox(
                  width: constraints.maxWidth * 0.5.w,
                  height: 18.0.h,
                  child: const ShimmerContainer(),
                ),
                const Gap(6),
                SizedBox(
                  height: 36.h,
                  width: constraints.maxWidth * 1.w,
                  child: const ShimmerContainer(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
