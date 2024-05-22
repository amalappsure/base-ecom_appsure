part of 'categories.dart';

class CategoryItemBase extends ConsumerWidget {
  const CategoryItemBase({
    super.key,
    required this.category,
    this.errorImage,
    this.onTap,
    this.height,
    this.width,
    this.imageShape = BoxShape.rectangle,
  });

  const factory CategoryItemBase.widget({
    Key? key,
    required Category category,
    DecorationImage? errorImage,
    ValueChanged<bool>? onTap,
    double? height,
    double? width,
    BoxShape imageShape,
  }) = _CategoryItem;

  final Category category;
  final DecorationImage? errorImage;
  final ValueChanged<bool>? onTap;
  final double? height;
  final double? width;
  final BoxShape imageShape;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }

  Container _container(DecorationImage? decorationImage) => Container(
    decoration: BoxDecoration(
      shape: imageShape,
      image: decorationImage,
    ),
  );
}

class _CategoryItem extends CategoryItemBase {
  const _CategoryItem({
    super.key,
    required super.category,
    super.errorImage,
    super.onTap,
    super.height,
    super.width,
    super.imageShape,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(
            settings.selectedLocale!.subCategoriesOf(category.id).isNotEmpty,
          );
        }
      },
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
          elevation: 0.0,
          surfaceTintColor: Colors.white,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 6,
                  child: CachedNetworkImage(
                    imageUrl: category.imagePath ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(errorImage.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                Flexible(
                  flex: 4,
                  child: Text(
                    category.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).size.width * 0.024),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItemLeftSideNavShimmer extends StatelessWidget {
  const CategoryItemLeftSideNavShimmer({
    super.key,
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,  // Light grey shimmer
      highlightColor: Colors.grey[100]!,  // Nearly white shimmer
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(bottom: 8.0, right: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 60.0,  // Example height for the image
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 10.0,  // Example height for the text
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItemShimmer extends StatelessWidget {
  const CategoryItemShimmer({
    super.key,
    this.height,
    this.width,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        child: CircleAvatar(),
        height: height,
        width: width,
        margin: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 0.0,
        ),
      ),
    );
  }
}
