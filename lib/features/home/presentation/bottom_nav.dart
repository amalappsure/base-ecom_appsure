import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

final navCartKeyProvider = StateProvider<GlobalKey<CartIconKey>>(
      (ref) => GlobalKey<CartIconKey>(),
);

class HomeNavigationBar extends ConsumerWidget {
  const HomeNavigationBar({
    super.key,
    required this.onTap,
    this.currentIndex = 0,
    this.showAlerts = true,
    // this.showCart = false,
  });

  final ValueChanged<int> onTap;
  final int currentIndex;
  final bool showAlerts;
  // final showCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cart = ref.watch(cartProvider);
    // final cartKey = ref.watch(navCartKeyProvider);
    // final isRtl = Directionality.of(context) == TextDirection.rtl;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      elevation: 12.0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: const Color(0xFFADADAD),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Iconsax.home_2),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Iconsax.category),
          label: 'Categories',
        ),
        if (showAlerts)
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.notification),
            label: 'Alerts',
          )
        // else if (showCart)
        //   BottomNavigationBarItem(
        //     icon: Stack(
        //       children: [
        //         cart.isNotEmpty
        //             ? AddToCartIcon(
        //                 key: cartKey,
        //                 icon: const Icon(Iconsax.shopping_cart),
        //                 badgeOptions: const BadgeOptions(active: false),
        //               )
        //             : const Icon(Iconsax.shopping_cart),
        //         if (cart.isNotEmpty)
        //           Transform.translate(
        //             offset: Offset(isRtl ? -10 : 28, -8),
        //             child: Container(
        //               padding: const EdgeInsets.all(3),
        //               decoration: const BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: Colors.red,
        //               ),
        //               child: Text(
        //                 cart.itemsCount.toString(),
        //                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
        //                       color: Colors.white,
        //                       fontSize: 9,
        //                     ),
        //               ),
        //             ),
        //           )
        //       ],
        //     ),
        //     label: 'Cart',
        //   )
        ,
        const BottomNavigationBarItem(
          icon: Icon(Iconsax.user),
          label: 'Account',
        ),
      ],
    );
  }
}
