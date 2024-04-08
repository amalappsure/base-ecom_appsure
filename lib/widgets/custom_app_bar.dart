import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import 'package:base_ecom_appsure/features/cart/presentation/cart_action.dart';
import 'package:base_ecom_appsure/widgets/choose_language_action.dart';
import 'package:base_ecom_appsure/widgets/search_action.dart';

typedef CustomAppBarBuilder = CustomAppBar Function(
    String title,
    bool showActions,
    );

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.leading,
    this.showActions = true,
    this.showSearch = true,
    this.cartKey,
    this.showCart = true,
  });

  final String? title;

  final Widget? leading;
  final bool showActions;
  final bool showCart;
  final GlobalKey<CartIconKey>? cartKey;
  final bool showSearch;

  void onLeadingClicked(BuildContext context, WidgetRef ref) =>
      throw UnimplementedError();
  void onCartClicked(BuildContext context, WidgetRef ref) =>
      throw UnimplementedError();
  void onSearchClicked(BuildContext context, WidgetRef ref) =>
      throw UnimplementedError();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      leadingWidth: MediaQuery.of(context).size.width * 0.3,
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onLeadingClicked(context, ref),
        child: leading ??
            Icon(
              isRtl ? Iconsax.arrow_right_1 : Iconsax.arrow_left,
            ),
      ),
      title: title != null ? Text(title!) : null,
      titleSpacing: 0.0,
      actions: showActions
          ? [
        if (showSearch)
          SearchAction(
            onPressed: () => onSearchClicked(context, ref),
          ),
        const ChooseLanguageAction(),
        if (showCart)
          CartAction(
            cartKey: cartKey,
            onPressed: () => onCartClicked(context, ref),
          ),
      ]
          : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().toolbarHeight ?? 48.0);
}
