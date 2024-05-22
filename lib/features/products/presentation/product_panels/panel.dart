part of 'product_panels.dart';

typedef PanelItemBuilder = ProductBase Function(
    BuildContext context,
    Product product,
    int pageLength,
    );

typedef PanelTitleBuilder = Widget Function(
    BuildContext context,
    ProductPanel panel,
    );

abstract class PanelBase extends ConsumerWidget {
  const PanelBase({
    super.key,
    required this.panel,
    required this.itemBuilder,
    required this.panelTitleBuilder,
    required this.extraheight,
  });

  const factory PanelBase.widget({
    Key? key,
    required ProductPanel panel,
    required PanelItemBuilder itemBuilder,
    required PanelTitleBuilder panelTitleBuilder,
    required bool extraheight,
  }) = _Panel;

  final ProductPanel panel;
  final PanelItemBuilder itemBuilder;
  final PanelTitleBuilder panelTitleBuilder;
  final bool extraheight;
}

class _Panel extends PanelBase {
  const _Panel({
    super.key,
    required super.panel,
    required super.itemBuilder,
    required super.panelTitleBuilder,
    required super.extraheight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageLength = Responsive.valueWhen(
      context: context,
      mobile: ref.read(appConfigProvider).enableTwoItemInMobileCarousel ? 2 : 1,
      smallTablet: 3,
      mediumTablet: 4,
      desktop: 8,
    );

    if (panel.panelProducts.length.isOdd) {
      panel.panelProducts.add(panel.panelProducts.first);
    }

    final slices = panel.panelProducts.slices(pageLength).toList();
    final cart = ref.read(cartProvider);

    return Column(
      children: [
        panelTitleBuilder(context, panel),
        Responsive(
          mobile: (_, constraints, child) => SizedBox(
            height:
            MediaQuery.of(context).size.width * (0.85),
            child: child,
          ),
          smallTablet: (_, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.width * 0.6,
            child: child,
          ),
          mediumTablet: (_, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.width * 0.45,
            child: child,
          ),
          desktop: (context, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.height / 2.4,
            child: child,
          ),
          child: _PanelsPageView(
            itemCount: slices.length,
            itemBuilder: (context, index) => _row(
              context,
              slices[index].toList(),
              pageLength,
              cart,
            ),
          ),
        ),
      ],
    );
  }

  Row _row(
      BuildContext context,
      List<Product> items,
      int pageLength,
      CartProvider cart,
      ) =>
      Row(
        children: List.generate(
          items.length,
              (index) => itemBuilder(context, items[index], pageLength),
        ),
      );
}

class _PanelsPageView extends ConsumerStatefulWidget {
  const _PanelsPageView({
    required this.itemBuilder,
    required this.itemCount,
  });

  final NullableIndexedWidgetBuilder itemBuilder;
  final int itemCount;

  @override
  ConsumerState<_PanelsPageView> createState() => _PanelsPageViewState();
}

class _PanelsPageViewState extends ConsumerState<_PanelsPageView> {
  final _pageController = PageController();
  bool showLeft = false;
  bool showRight = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        if (widget.itemCount < 2) {
          showLeft = false;
          showLeft = false;
        } else {
          final isRtl = Directionality.of(context) == TextDirection.rtl;
          showLeft = isRtl ? true : false;
          showRight = isRtl ? false : true;
        }

        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final lastPageIndex = widget.itemCount - 1;
    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
            onPageChanged: (value) {
              if (value == lastPageIndex) {
                if (isRtl) {
                  showRight = true;
                  showLeft = false;
                } else {
                  showRight = false;
                  showLeft = true;
                }
              } else if (value == 0) {
                if (isRtl) {
                  showRight = false;
                  showLeft = true;
                } else {
                  showRight = true;
                  showLeft = false;
                }
              } else {
                showLeft = true;
                showRight = true;
              }
              setState(() {});
            },
          ),
        ),
        if (showLeft)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Center(
              child: Icon(
                Iconsax.arrow_left_2,
                size: 24,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
        if (showRight)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Center(
              child: Icon(
                Iconsax.arrow_right_3,
                size: 24,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
      ],
    );
  }
}

class PanelShimmer extends StatelessWidget {
  const PanelShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageLength = Responsive.valueWhen(
      context: context,
      mobile: 2,
      smallTablet: 3,
      mediumTablet: 4,
      desktop: 8,
    );
    return Column(
      children: [
        const PanelTitleShimmer(),
        Responsive(
          mobile: (_, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.width * 0.85,
            child: child,
          ),
          smallTablet: (_, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.width * 0.6,
            child: child,
          ),
          mediumTablet: (_, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.width * 0.45,
            child: child,
          ),
          desktop: (context, constraints, child) => SizedBox(
            height: MediaQuery.of(context).size.height / 2.4,
            child: child,
          ),
          child: PageView.builder(
            itemCount: 2,
            itemBuilder: (context, index) => _row(
              context,
              pageLength,
            ),
          ),
        ),
      ],
    );
  }

  Row _row(
      BuildContext context,
      int pageLength,
      ) =>
      Row(
        children: List.generate(
          pageLength,
              (index) => PanelProductShimmer(
            width: (MediaQuery.of(context).size.width / pageLength) - 12,
            verticalMargin: 6.0,
            horizontalMargin: 6.0,
          ),
        ),
      );
}
