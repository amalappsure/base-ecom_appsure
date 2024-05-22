import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/orders/models/order_details_resp/order_status.dart';
import 'package:intl/intl.dart';

class OrderTimeline extends ConsumerWidget {
  const OrderTimeline({
    super.key,
    required this.statuses,
  });

  final List<OrderStatus> statuses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    if (statuses.first.statusEnum == OrderStatuses.cancelRequested) {
      return Text(
        settings.selectedLocale!.translate('OrderCancellationRequest'),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
        ),
      );
    } else if (statuses.first.statusEnum == OrderStatuses.cancelled) {
      return Text(
        settings.selectedLocale!.translate('OrderCancelledSuccessfully'),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
        ),
      );
    }

    final orderPlaced = statuses.firstWhereOrNull(
            (element) => element.statusEnum == OrderStatuses.ordered) !=
        null;
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: OrderStatuses.ideals.map(
                (e) {
              final filled =
                  OrderStatuses.ideals.indexOf(e) <= _currentStatusIndex ||
                      (orderPlaced && e == OrderStatuses.ordered);

              final activeColor = Theme.of(context).colorScheme.primary;
              final inactiveColor =
              Theme.of(context).colorScheme.tertiary.withOpacity(0.3);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  e == OrderStatuses.ideals.first
                      ? const SizedBox.shrink()
                      : _line(
                    context,
                    filled: filled,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled ? activeColor : inactiveColor,
                        ),
                        child: Icon(
                          e.icon,
                          size: 24,
                          color: filled ? Colors.white : null,
                        ),
                      ),
                      const Gap(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (_date(e) != null)
                            Text(
                              _date(e)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary),
                            ),
                        ],
                      )
                    ],
                  ),
                  e == OrderStatuses.ideals.last
                      ? const SizedBox.shrink()
                      : _line(
                    context,
                    filled: filled,
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  String? _date(OrderStatuses status) {
    final s = statuses.firstWhereOrNull(
          (element) => element.statusEnum == status,
    );
    if (s != null) {
      return DateFormat("yyyy MMMM dd, hh:mm aa").format(s.date!);
    }

    return null;
  }

  int get _currentStatusIndex => OrderStatuses.ideals.indexWhere(
        (element) => element.id == statuses.first.statusId,
  );

  Widget _line(BuildContext context, {bool filled = false}) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 17.5),
    color: filled
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
    width: 5.0,
    height: 30.h,
  );
}
