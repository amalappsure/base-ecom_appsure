import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/presentation/add_or_remove_button.dart';
import 'package:base_ecom_appsure/features/cart/presentation/add_or_remove_dropdown.dart';
import 'package:base_ecom_appsure/features/cart/presentation/add_to_cart_button.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/features/products/models/product.dart';
import 'package:base_ecom_appsure/features/products/presentation/count_downer.dart';
import 'package:base_ecom_appsure/features/products/presentation/discount_percentage.dart';
import 'package:base_ecom_appsure/features/wishlist/presentation/product_heart.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';
import 'package:base_ecom_appsure/widgets/responsive_builder.dart';
import 'package:base_ecom_appsure/widgets/shimmer.dart';
import 'package:base_ecom_appsure/widgets/whats_app_launcher.dart';

import 'product_rating.dart';

part 'list_item.dart';
part 'panel_item.dart';
part 'product_cart_button.dart';
part 'product_image.dart';

abstract class ProductBase extends ConsumerWidget {
  const ProductBase({
    super.key,
    this.errorImage,
    required this.product,
    required this.globalKey,
    required this.runCartingAnim,
    this.onTap,
  });

  const factory ProductBase.panel({
    Key? key,
    required Product product,
    required double width,
    double horizontalMargin,
    double verticalMargin,
    DecorationImage? errorImage,
    required GlobalKey globalKey,
    required RunCartingAnim runCartingAnim,
    VoidCallback? onTap,
  }) = _PanelProduct;

  const factory ProductBase.list({
    Key? key,
    required Product product,
    required DecorationImage errorImage,
    required GlobalKey globalKey,
    required RunCartingAnim runCartingAnim,
    VoidCallback? onTap,
  }) = _ProductListItem;

  final Product product;
  final DecorationImage? errorImage;
  final GlobalKey globalKey;
  final RunCartingAnim runCartingAnim;
  final VoidCallback? onTap;
}
