part of 'product_item_base.dart';

class _ProductListItem extends ProductBase {
  const _ProductListItem({
    super.key,
    required super.product,
    required super.errorImage,
    required super.globalKey,
    required super.runCartingAnim,
    super.onTap,
  });

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
                    width: (MediaQuery.of(context).size.width * 0.4).w,
                    child: CachedNetworkImage(
                      cacheKey: product.itemCode,
                      imageUrl: product.imagePath ?? '',
                      imageBuilder: (context, imageProvider) => ProductImage(
                        product: product,
                        decorationImage: DecorationImage(image: imageProvider),
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
                  const Gap(12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                WhatsAppLauncher(
                                  size: 20.0,
                                  itemName: product.itemName ?? '',
                                  urlName: product.urlName ?? '',
                                  unitId: product.unitId,
                                ),
                                const Gap(8),
                                ProductHeart(
                                  size: 18.0,
                                  productId: product.itemId,
                                  unitId: product.unitId,
                                ),
                              ],
                            ),
                            ProductRating(rating: product.rating),
                          ],
                        ),
                        Text(
                          product.itemName ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(6),
                        if (product.endDate != null)
                          Text(
                            settings.priceText(
                              product.sellingPrice,
                              prefixCurrency: true,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2.0,
                            ),
                          ),
                        Text(
                          settings.priceText(
                            product.currentPrice,
                            prefixCurrency: true,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (product.endDate != null) const Gap(6),
                        if (product.endDate != null)
                          CountDowner(
                            endDate: product.endDate!,
                            small: true,
                          ),
                        if (product.endDate != null)
                          const Gap(6)
                        else
                          const Gap(12),
                        ProductCartButton(
                          product: product,
                          globalKey: globalKey,
                          runCartingAnim: runCartingAnim,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (product.discountPercentage != null)
          Positioned(
            top: 10.0,
            left: isRtl ? null : 0.0,
            right: isRtl ? 0.0 : null,
            child: DiscountPercentage(
              verticalMargin: 6.0,
              horizontalMargin: 0,
              product: product,
              percentage: product.discountPercentage!,
            ),
          ),
          if (!appConfig.sellOutOfStock && product.stock <= 0)
            Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                left: 20,
                right: MediaQuery.of(context).size.width * 0.55,
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

class ProductListItemShimmer extends ConsumerWidget {
  const ProductListItemShimmer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomShimmer(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.4).w,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.8.w,
                        height: 18.0.h,
                        child: const ShimmerContainer(opacity: 0.5),
                      ),
                      const Gap(12),
                      SizedBox(
                        width: constraints.maxWidth * 0.8.w,
                        height: 18.0.h,
                        child: const ShimmerContainer(opacity: 0.5),
                      ),
                      const Gap(16),
                      SizedBox(
                        width: constraints.maxWidth * 0.4.w,
                        height: 18.0.h,
                        child: const ShimmerContainer(opacity: 0.5),
                      ),
                      const Gap(16),
                      SizedBox(
                        height: 34.h,
                        width: constraints.maxWidth.w,
                        child: const ShimmerContainer(opacity: 0.5),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
