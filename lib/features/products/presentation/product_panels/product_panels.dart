import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/features/home/providers/home_provider.dart';
import 'package:base_ecom_appsure/foundation/refresh_controller.dart';
import 'package:base_ecom_appsure/widgets/responsive_builder.dart';
import 'package:base_ecom_appsure/widgets/shimmer.dart';

import '../../models/product.dart';
import '../../models/product_panels.dart';
import '../product_item_base/product_item_base.dart';

part 'panel.dart';
part 'title.dart';

abstract class PanelsBase extends ConsumerStatefulWidget {
  const PanelsBase({
    super.key,
    required this.refreshController,
    required this.itemBuilder,
    required this.panelTitleBuilder,
  });

  const factory PanelsBase.widget({
    Key? key,
    required RefreshController refreshController,
    required PanelItemBuilder itemBuilder,
    required PanelTitleBuilder panelTitleBuilder,
  }) = _Panels;

  final RefreshController refreshController;
  final PanelItemBuilder itemBuilder;
  final PanelTitleBuilder panelTitleBuilder;

  @override
  PanelsBaseState<PanelsBase> createState();
}

abstract class PanelsBaseState<T extends PanelsBase> extends ConsumerState<T> {
  void refresh();
}

class _Panels extends PanelsBase {
  const _Panels({
    super.key,
    required super.refreshController,
    required super.itemBuilder,
    required super.panelTitleBuilder,
  });

  @override
  PanelsBaseState<_Panels> createState() => _ProductPanelsState();
}

class _ProductPanelsState extends PanelsBaseState<_Panels> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => refresh(),
    );
    widget.refreshController.refresh = refresh;
    super.initState();
  }

  @override
  void refresh() => ref.read(homeProvider).getProductPanels();

  @override
  Widget build(BuildContext context) {
    final panels = ref.watch(panelsProvider);
    ref.listen(settingsProvider, (previous, next) {
      refresh();
    });
    return panels.when(
      onLoading: () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) => const PanelShimmer(),
      ),
      onSuccess: (panels) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: panels.length,
        itemBuilder: (context, index) {
          if (panels[index].panelProducts.isEmpty) {
            return const SizedBox.shrink();
          }

          final extraheight = panels[index]
              .panelProducts
              .firstWhereOrNull((element) => element.endDate != null) !=
              null;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  panels[index].title == "DEALS" ? Colors.green.shade100 : panels[index].title == "Recently arrived" ? Colors.pink.shade50 : Colors.white,
                  panels[index].title == "DEALS" ? Colors.blue.shade100 : panels[index].title == "Recently arrived" ? Colors.blue.shade100 : Colors.white, // end color
                ],
              ),
            ),
            child: PanelBase.widget(
              panel: panels[index],
              extraheight: extraheight,
              itemBuilder: widget.itemBuilder,
              panelTitleBuilder: widget.panelTitleBuilder,
            ),
          );
        },
      ),
      onError: (error) => const SizedBox.shrink(),
    );
  }
}
