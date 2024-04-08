import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'order.dart';
import 'order_item.dart';

@immutable
class OrdersListResult {
  final List<Order> orders;
  final List<OrderItem> items;

  const OrdersListResult({
    required this.orders,
    required this.items,
  });

  @override
  String toString() => 'Result(table: $orders, table1: $items)';

  factory OrdersListResult.fromJson(Map<String, dynamic> json) =>
      OrdersListResult(
        orders: (json['table'] as List<dynamic>?)
            ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList() ??
            [],
        items: (json['table1'] as List<dynamic>?)
            ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
    'table': orders.map((e) => e.toJson()).toList(),
    'table1': items.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrdersListResult) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => orders.hashCode ^ items.hashCode;
}
