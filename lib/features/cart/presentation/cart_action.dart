import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:iconsax/iconsax.dart';

class CartAction extends ConsumerWidget {
  const CartAction({
    super.key,
    this.cartKey,
    this.onPressed,
    this.color,
  });

  final GlobalKey<CartIconKey>? cartKey;
  final VoidCallback? onPressed;
  final bool? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Stack(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: onPressed,
          icon: SizedBox.square(
            dimension: 24.0,
            child: Builder(builder: (context) {
              if (cartKey != null) {
                return AddToCartIcon(
                  key: cartKey!,
                  icon: Icon(Iconsax.shopping_cart5,color: color == true ? Colors.black : Colors.white),
                  badgeOptions: const BadgeOptions(active: false),
                );
              }
              return  Icon(Iconsax.shopping_cart5,color: color == true ? Colors.black : Colors.white);
            }),
          ),
          tooltip: 'Cart',
        ),
        if (cart.isNotEmpty)
          Positioned(
            top: 2.0,
            right: 4.0,
            child: Container(
              padding: const EdgeInsets.all(3.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text(
                cart.itemsCount.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}
