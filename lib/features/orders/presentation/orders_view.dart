import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/orders/presentation/order_cancel_modal.dart';
import 'package:base_ecom_appsure/features/orders/presentation/orders_list_item.dart';
import 'package:base_ecom_appsure/features/orders/providers/orders_provider.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/widgets/custom_app_bar.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({
    super.key,
    required this.appBarBuilder,
    required this.onProductClicked,
    required this.onTrackClicked,
  });

  final OnProductClicked onProductClicked;
  final OnTrackClicked onTrackClicked;
  final CustomAppBarBuilder appBarBuilder;

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => ref.read(ordersProvider).getOrders(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final snapshot = ref.watch(ordersListProvider);
    return Scaffold(
      appBar: widget.appBarBuilder(
        settings.selectedLocale!.translate('YourOrders'),
        true,
      ),
      body: Builder(
        builder: (context) {
          return snapshot.when(
            onLoading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            onSuccess: (data) {
              final orders = snapshot.data!.orders;
              return RefreshIndicator(
                onRefresh: () => ref.read(ordersProvider).getOrders(
                  refresh: true,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final items = snapshot.data!.items
                        .where((element) => element.vid == orders[index].vid)
                        .toList();
                    return OrdersListItem(
                      order: orders[index],
                      onProductClicked: widget.onProductClicked,
                      onTrackClicked: widget.onTrackClicked,
                      onCancelClicked: (items, order) => _showCancelModal(
                        context,
                        order.vid,
                      ),
                      items: items,
                    );
                  },
                ),
              );
            },
            onError: (error) => Center(child: Text(error.toString())),
          );
        },
      ),
    );
  }

  Future<void> _showCancelModal(BuildContext context, int voucherId) async {
    final settings = ref.read(settingsProvider);

    if (ref.read(appConfigProvider).disableCancelRequest) return;
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => OrderCancelModal(voucherId: voucherId),
    );
    if (result == true) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        message: settings.selectedLocale!.translate('YourCancelRequest'),
      );
    }
    if (result is AppException) {
      final string = result.toString();
      final translated = settings.selectedLocale!.translate(string);
      final message = translated == string ? string : translated;
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: message,
      );
    }
    ref.read(ordersProvider).getOrders();
  }
}
