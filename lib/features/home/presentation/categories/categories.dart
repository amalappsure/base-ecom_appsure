import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/home/models/category.dart';
import 'package:base_ecom_appsure/features/home/providers/home_provider.dart';
import 'package:base_ecom_appsure/foundation/refresh_controller.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';
import 'package:base_ecom_appsure/widgets/responsive_builder.dart';
import 'package:base_ecom_appsure/widgets/shimmer.dart';
import 'package:shimmer/shimmer.dart';

part 'categories_grid.dart';
part 'categories_horiz_list.dart';
part 'category_item.dart';

typedef OnCategoryClicked = void Function(bool, Category);
typedef ItemBuilder = CategoryItemBase Function({
required BuildContext context,
required Category category,
required double height,
required double width,
});

abstract class CategoriesBase extends ConsumerStatefulWidget {
  const CategoriesBase({
    super.key,
    required this.refreshController,
    required this.height,
    required this.itemWidth,
    required this.itemBuilder,
  });

  factory CategoriesBase.basedOnSetting({
    Key? key,
    required RefreshController refreshController,
    required double height,
    required double itemWidth,
    required ItemBuilder itemBuilder,
    required WidgetRef ref,
  }) {
    if (ref.read(appConfigProvider).enableSlidingCategory) {
      return CategoriesBase.horizListWidget(
        refreshController: refreshController,
        height: height,
        itemWidth: itemWidth,
        itemBuilder: itemBuilder,
      );
    } else {
      return CategoriesBase.gridWidget(
        refreshController: refreshController,
        height: height,
        itemWidth: itemWidth,
        itemBuilder: itemBuilder,
      );
    }
  }

  const factory CategoriesBase.horizListWidget({
    Key? key,
    required RefreshController refreshController,
    required double height,
    required double itemWidth,
    required ItemBuilder itemBuilder,
  }) = _CategoriesHorizList;

  const factory CategoriesBase.gridWidget({
    Key? key,
    required RefreshController refreshController,
    required double height,
    required double itemWidth,
    required ItemBuilder itemBuilder,
  }) = _CategoriesGrid;

  final RefreshController refreshController;
  final double height;
  final double itemWidth;
  final ItemBuilder itemBuilder;

  @override
  CategoriesBaseState<CategoriesBase> createState();
}

abstract class CategoriesBaseState<T extends CategoriesBase>
    extends ConsumerState<T> {
  void refresh();

  int itemCount(BuildContext context);
}
