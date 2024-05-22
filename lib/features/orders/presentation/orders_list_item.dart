import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/orders/models/orders_list/order.dart';
import 'package:base_ecom_appsure/features/orders/models/orders_list/order_item.dart';
import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';

typedef OnProductClicked = void Function(int itemId, int unitId);
typedef OnTrackClicked = void Function(List<OrderItem> items, Order order);

class OrdersListItem extends ConsumerStatefulWidget {
  const OrdersListItem({
    super.key,
    required this.order,
    required this.items,
    required this.onProductClicked,
    required this.onTrackClicked,
    required this.onCancelClicked,
  });

  final Order order;
  final List<OrderItem> items;
  final OnProductClicked onProductClicked;
  final OnTrackClicked onTrackClicked;
  final OnTrackClicked onCancelClicked;

  @override
  ConsumerState<OrdersListItem> createState() => _OrdersListItemState();
}

class _OrdersListItemState extends ConsumerState<OrdersListItem> {
  bool expanded = false;
  _popupMenu(BuildContext context, AppSettingsprovider settings) =>
      PopupMenuButton(
        child: const SizedBox(
          height: 24,
          width: 24,
          child: Icon(Icons.more_vert),
        ),
        onSelected: (value) {
          if (value == 'Track') {
            widget.onTrackClicked(widget.items, widget.order);
          } else {
            widget.onCancelClicked(widget.items, widget.order);
          }
        },
        itemBuilder: (context) => [
          if ((widget.order.isCancel ?? false) &&
              !ref.read(appConfigProvider).disableCancelRequest)
            'Cancel',
          'Track',
        ]
            .map((e) => PopupMenuItem(
            value: e,
            child: Text(
              settings.selectedLocale!.translate(e),
            )))
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: DefaultCard(
        shadow: shadow1,
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${settings.selectedLocale!.translate('OrderNo')} "
                      "${widget.order.vNo.toString()}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                _popupMenu(context, settings)
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _titleAndValue(
                  context,
                  settings.selectedLocale!.translate('OrderedOn'),
                  DateFormat('dd/MM/yyyy').format(widget.order.date!),
                  CrossAxisAlignment.start,
                ),
                _titleAndValue(
                  context,
                  settings.selectedLocale!.translate('DeliveryCharges'),
                  settings.priceText(widget.order.delCharge),
                  CrossAxisAlignment.center,
                ),
                _titleAndValue(
                  context,
                  "${settings.selectedLocale!.translate('OrderTotal')} (${widget.order.count} ${settings.selectedLocale!.translate('items')})",
                  settings.priceText(
                    (widget.order.amount ?? 0) + (widget.order.delCharge ?? 0),
                  ),
                  CrossAxisAlignment.end,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  settings.selectedLocale!.translate('items').capitalizeFirst!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Icon(
                  Iconsax.arrow_circle_down,
                  size: 18,
                )
              ],
            ),
            AnimatedCrossFade(
              firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
              secondCurve:
              const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
              sizeCurve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 200),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Container(height: 0.0),
              secondChild: ListView.separated(
                itemCount: widget.items.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 8.0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => widget.onProductClicked(
                    widget.items[index].itemId,
                    widget.items[index].unitId,
                  ),
                  behavior: HitTestBehavior.opaque,
                  child: OrdersProductItem(item: widget.items[index]),
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersProductItem extends ConsumerWidget {
  const OrdersProductItem({super.key, required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        CachedNetworkImage(
          height: size.height * 0.15,
          width: size.height * 0.15,
          imageUrl: item.itemImage ?? '',
        ),
        const Gap(6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.itemName ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Gap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('Unit'),
                    item.unit ?? '',
                    CrossAxisAlignment.start,
                  ),
                  const Spacer(),
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('Qty'),
                    item.quantity.toString(),
                    CrossAxisAlignment.end,
                  ),
                ],
              ),
              const Gap(6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('Rate'),
                    settings.priceText((item.rate ?? 0).toDouble()),
                    CrossAxisAlignment.start,
                  ),
                  const Spacer(),
                  _titleAndValue(
                    context,
                    settings.selectedLocale!.translate('Total'),
                    settings.priceText((item.amount ?? 0).toDouble()),
                    CrossAxisAlignment.end,
                  ),
                ],
              ),
              _titleAndValue(
                context,
                '',
                item.status ?? '',
                CrossAxisAlignment.start,
              ),
              const Gap(3),
              _titleAndValue(
                context,
                settings.selectedLocale!.translate('LastUpdatedOn'),
                DateFormat('dd/MM/yyyy HH:mm').format(item.statusDate!),
                CrossAxisAlignment.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Column _titleAndValue(
    BuildContext context,
    String title,
    String value,
    CrossAxisAlignment alignment,
    ) {
  return Column(
    crossAxisAlignment: alignment,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
      const Gap(2),
      Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}
