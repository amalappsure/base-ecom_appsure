part of 'categories.dart';

class _CategoriesHorizList extends CategoriesBase {
  const _CategoriesHorizList({
    super.key,
    required super.refreshController,
    required super.height,
    required super.itemWidth,
    required super.itemBuilder,
  });

  @override
  CategoriesBaseState<_CategoriesHorizList> createState() =>
      _CategoriesHorizListState();
}

class _CategoriesHorizListState
    extends CategoriesBaseState<_CategoriesHorizList> {

  final ScrollController _scrollController = ScrollController();


  void scrollToBeginning() async {
    if (_scrollController.hasClients) {
      final double endPosition = _scrollController.position.extentInside;
      await _scrollController.animateTo(
        endPosition,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
      await _scrollController.animateTo(
        0,
        duration: Duration(seconds: 8),
        curve: Curves.easeInOut,
      );
    }
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBeginning());
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    ref.listen(settingsProvider, (previous, next) {
      refresh();
    });
    return categories.when(
      onLoading: () => SizedBox(
        height: widget.height,
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          itemCount: itemCount(context),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => CategoryItemShimmer(
            width: widget.itemWidth,
            height: widget.height,
          ),
          separatorBuilder: (context, index) => Gap(5.w),
        ),
      ),
      onSuccess: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: widget.height,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            shrinkWrap: true,
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => widget.itemBuilder(
              context: context,
              category: categories[index],
              height: widget.height,
              width: widget.itemWidth,
            ),
            separatorBuilder: (context, index) => Gap(5.w),
          ),
        );
      },
      onError: (error) => SizedBox(
        height: widget.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
