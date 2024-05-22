import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/wishlist/providers/wish_list_provider.dart';

import '../../auth/providers/login_state_provider.dart';

class ProductHeart extends ConsumerStatefulWidget {
  const ProductHeart({
    super.key,
    required this.productId,
    required this.unitId,
    this.size = 24.0,
  });

  final int productId;
  final int unitId;
  final double size;

  @override
  ConsumerState<ProductHeart> createState() => _ProductHeartState();
}

class _ProductHeartState extends ConsumerState<ProductHeart> {
  late bool favourite;
  int? wishListId;
  @override
  void initState() {
    favourite = _wishListProvider.existInWishList(widget.productId);
    wishListId = _wishListProvider.itemWithProductId(widget.productId)?.id;
    super.initState();
  }

  WishListProvider get _wishListProvider => ref.read(wishListProvider.notifier);

  Future<void> _addToFavourites() async {
    if (ref.read(loginStateProvider) is LoggedIn) {
    setState(() => favourite = true);
    try {
      await _wishListProvider.insertwishlistItems(
        widget.productId,
        widget.unitId,
      );
    } catch (e) {
      setState(() => favourite = false);
    }
    } else {
      ref.read(loginStateProvider.notifier).state = LoginRequired(
        Random().nextInt(100),
      );
    }
  }

  Future<void> _removeFromwishlist() async {
    setState(() => favourite = false);
    try {
      if (wishListId != null) {
        await _wishListProvider.removeWishlistItem(
          wishListId!,
        );
      } else {
        setState(() => favourite = true);
      }
    } catch (e) {
      setState(() => favourite = true);
    }
  }

  void _initListener() {
    ref.listen(wishListProvider, (previous, next) {
      wishListId = next.itemWithProductId(widget.productId)?.id;
      favourite = wishListId != null;
      setState(() {});
    });
  }

  bool get enablewishlist => ref.read(appConfigProvider).enablewishlist;

  @override
  Widget build(BuildContext context) {
    _initListener();
    if (!enablewishlist) return const SizedBox.shrink();
    return IconButton(
      iconSize: widget.size,
      style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact),
      onPressed: () {
        if (favourite) {
          _removeFromwishlist();
        } else {
          _addToFavourites();
        }
      },
      icon: Icon(
        FontAwesomeIcons.solidHeart,
        size: widget.size,
        color: favourite ? Colors.pink.shade500 : Colors.black54,
      ),
    );
  }
}
