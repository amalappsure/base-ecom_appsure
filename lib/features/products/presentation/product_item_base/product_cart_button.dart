part of 'product_item_base.dart';

abstract class ProductCartButtonBase extends ConsumerWidget {
  final GlobalKey? globalKey;
  final EdgeInsets padding;
  final Product product;
  final RunCartingAnim? runCartingAnim;
  final bool dontShowDropdown;

  const ProductCartButtonBase({
    super.key,
    this.globalKey,
    this.padding = EdgeInsets.zero,
    required this.product,
    this.runCartingAnim,
    this.dontShowDropdown = false,
  });
}

class ProductCartButton extends ProductCartButtonBase {
  const ProductCartButton({
    super.key,
    super.globalKey,
    super.padding,
    required super.product,
    super.runCartingAnim,
    super.dontShowDropdown,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final cart = ref.watch(cartProvider);
    final appConfig = ref.watch(appConfigProvider);
    return Builder(
      builder: (context) {
        final cannotAddMore = this.cannotAddMore(
          cart,
          appConfig.sellOutOfStock,
        );

        final maxDropDownValue =
        _maxDropDownValue(cart, appConfig.sellOutOfStock);

        // if (!appConfig.sellOutOfStock && product.stock <= 0) {
        //   return Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(6),
        //       color: Theme.of(context).colorScheme.errorContainer,
        //     ),
        //     alignment: Alignment.center,
        //     child: Text(
        //       settings.selectedLocale!.translate('Outofstock'),
        //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        //         color: Theme.of(context).colorScheme.error,
        //       ),
        //     ),
        //   );
        // }
        if (cartContainThis(cart)) {
          VoidCallback? onAddClicked = () => cart.incrOrDecrItemCount(
            product,
            decrease: false,
          );
          if (cannotAddMore) {
            onAddClicked = null;
          }

          if (ref.read(appConfigProvider).quantityAsDropDown &&
              !dontShowDropdown) {
            final count = cart.countOf(
              product.itemId,
              product.unitId,
            );

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
              child: AddOrRemoveDropdown(
                key: Key(maxDropDownValue.toString()),
                count: count,
                maxValue: maxDropDownValue,
                onAdded: (value) {
                  if (!cannotAddMore) {
                    cart.incrOrDecrItemCount(
                      product,
                      number: value ?? 1,
                    );

                    if (runCartingAnim != null) {
                      runCartingAnim!(globalKey);
                    }
                  } else {}
                },
              ),
            );
          }

          return AddOrRemoveButton(
            onRemoveClicked: () => cart.incrOrDecrItemCount(
              product,
              decrease: true,
            ),
            onAddClicked: onAddClicked,
            count: cart.countOf(product.itemId, product.unitId).toString(),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
          child: AddToCartButton(
            onPressed: product.stock > 0
                ? () {
              cart.incrOrDecrItemCount(product, decrease: false);
              if (runCartingAnim != null) {
                runCartingAnim!(globalKey);
              }
            }
                : null,
            padding: padding,
          ),
        );
      },
    );
  }

  bool cartContainThis(CartProvider cart) => cart.contains(
    product.itemId,
    product.unitId,
  );

  bool cannotAddMore(CartProvider cart, bool sellOutOfStock) {
    final count = cart.countOf(product.itemId, product.unitId);
    if (sellOutOfStock && !product.quantityPerCustomerEnabled) {
      return false;
    } else if (sellOutOfStock) {
      return count >= product.qtyPerCustomer;
    }
    return count >= product.maxAllowedCount;
  }

  int _maxDropDownValue(CartProvider cart, bool sellOutOfStock) {
    final count = cart.countOf(product.itemId, product.unitId);
    if (sellOutOfStock && !product.quantityPerCustomerEnabled) {
      return 10;
    } else if (sellOutOfStock) {
      final difference = product.qtyPerCustomer - count;
      return min(product.qtyPerCustomer, min(difference, 10));
    }
    final difference = product.maxAllowedCount - count;
    return min(product.maxAllowedCount, min(difference, 10));
  }
}
