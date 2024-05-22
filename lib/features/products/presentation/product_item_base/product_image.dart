part of 'product_item_base.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.decorationImage,
    this.globalKey,
    required this.product,
    this.showButtons = true,
  });

  final DecorationImage? decorationImage;
  final GlobalKey? globalKey;
  final Product product;
  final bool showButtons;

  @override
  Widget build(BuildContext context) {
    return decorationImage != null
        ? Container(
      key: globalKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: decorationImage,
        ),
    )
        : const Center(child: CircularProgressIndicator.adaptive());
  }
}
