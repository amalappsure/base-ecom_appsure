import 'package:base_ecom_appsure/features/orders/models/orders_list/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:base_ecom_appsure/features/addresses/presentation/address_item.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/orders/models/orders_list/order_item.dart';
import 'package:base_ecom_appsure/features/orders/presentation/order_timeline.dart';
import 'package:base_ecom_appsure/features/orders/presentation/orders_list_item.dart';
import 'package:base_ecom_appsure/features/orders/providers/orders_provider.dart';
import 'package:base_ecom_appsure/widgets/custom_app_bar.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';

class TrackOrderView extends ConsumerWidget {
  const TrackOrderView({
    super.key,
    required this.vId,
    required this.vNo,
    required this.items,
    required this.order,
    required this.appBarBuilder,
    this.onItemTapped,
  });

  final int vId;
  final String vNo;
  final List<OrderItem> items;
  final Order order;
  final CustomAppBarBuilder appBarBuilder;
  final ValueChanged<OrderItem>? onItemTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: appBarBuilder('Order# $vNo', false),
      body: FutureBuilder(
        future: ref.read(ordersProvider).getOrderDetails(vId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "${settings.selectedLocale!.translate('OrderedOn')} "
                          "${DateFormat('dd/MM/yyyy hh:mm aa').format(snapshot.data!.orderDate!)}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Gap(12),
                    Text(
                      settings.selectedLocale!.translate(
                        'DeliveryAddress',
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(4),
                    AddressItem(
                      address: snapshot.data!.deliveryAddress!,
                      showIsDefault: false,
                      showActions: false,
                    ),
                    const Gap(12),
                    OrderTimeline(
                      statuses: snapshot.data!.orderStatus,
                    ),
                    DefaultCard(
                      child: ListView.separated(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () => onItemTapped?.call(items[index]),
                          behavior: HitTestBehavior.opaque,
                          child: OrdersProductItem(item: items[index]),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                    DefaultCard(
                      margin: const EdgeInsets.only(top: 0.0),
                      child: Column(
                        children: [
                          _labelAndValue(
                            context,
                            "${settings.selectedLocale!.translate('SubTotal')}"
                                " (${items.length} "
                                "${settings.selectedLocale!.translate('items')})",

                            settings.priceText(order.amount),
                          ),
                          _labelAndValue(
                            context,
                            settings.selectedLocale!.translate(
                              'DeliveryCharges',
                            ),
                            settings.priceText(order.delCharge),
                          ),
                          _labelAndValue(
                            context,
                            settings.selectedLocale!.translate(
                              'Total',
                            ),
                            settings.priceText(
                              (order.delCharge ?? 0) + (order.amount ?? 0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }

  Row _labelAndValue(
      BuildContext context,
      String label,
      String value, {
        FontWeight fontWeight = FontWeight.w400,
      }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: fontWeight,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
