part of 'categories.dart';

class _CategoriesGrid extends CategoriesBase {
  const _CategoriesGrid({
    super.key,
    required super.refreshController,
    required super.height,
    required super.itemWidth,
    required super.itemBuilder,
  });

  @override
  CategoriesBaseState<_CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends CategoriesBaseState<_CategoriesGrid> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => refresh(),
    );
    widget.refreshController.refresh = refresh;
    super.initState();
  }

  @override
  void refresh() => ref.read(homeProvider).getCategoryListForComponent();

  @override
  int itemCount(BuildContext context) => Responsive.valueWhen(
    context: context,
    mobile: 4,
    smallTablet: 6,
    mediumTablet: 8,
    desktop: 10,
  );

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    ref.listen(settingsProvider, (previous, next) {
      refresh();
    });
    return categories.when(
      onLoading: () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: itemCount(context),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemCount(context),
          childAspectRatio: .85,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
        ),
        itemBuilder: (context, index) => CategoryItemShimmer(
          width: widget.itemWidth,
          height: widget.height,
        ),
      ),
      onSuccess: (categories) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: categories.length >= 4 ? itemCount(context) : categories.length,
            childAspectRatio: .85,
            crossAxisSpacing: 5.w,
            mainAxisSpacing: 5.w,
          ),
          itemBuilder: (context, index) => widget.itemBuilder(
            context: context,
            category: categories[index],
            height: widget.height,
            width: widget.itemWidth,
          ),
        );
      },
      onError: (error) => SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
    );
  }
}
