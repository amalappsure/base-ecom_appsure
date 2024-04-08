import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum OrderStatuses {
  ordered(
    name: 'Order',
    arabicName: 'بداية الطلب',
    icon: Iconsax.shopping_cart,
    statusKey: 'Order Placed',
    id: 3200,
  ),
  packed(
    name: 'Packed',
    arabicName: 'تم التجهيز',
    icon: Iconsax.box,
    statusKey: 'Order Packed',
    id: 3201,
  ),
  shipped(
    name: 'Shipped',
    arabicName: 'خرج للتوصيل',
    icon: Iconsax.truck,
    statusKey: 'Order Shipped',
    id: 3202,
  ),
  delivered(
    name: 'Delivered',
    arabicName: 'تم التوصيل',
    icon: Iconsax.box_tick,
    statusKey: 'Order Delivered',
    id: 3203,
  ),
  cancelled(
    name: 'Cancelled',
    arabicName: 'تم الغاء الأمر او الطلب',
    statusKey: 'Order Cancelled',
    id: 3204,
  ),
  cancelRequested(
    name: "Request for Cancellation",
    arabicName: 'طلب الإلغاء',
    statusKey: 'Request for Cancellation',
    id: 3816,
  ),
  paymentIncomplete(
    name: 'Payment Incomplete',
    arabicName: 'طلب الإلغاء',
    statusKey: 'Payment Incomplete',
    id: 4960,
  );
  // cancelled();

  const OrderStatuses({
    required this.name,
    required this.arabicName,
    required this.statusKey,
    this.icon,
    required this.id,
  });

  final String name;
  final String arabicName;
  final String statusKey;
  final IconData? icon;
  final int id;

  static const ideals = [
    OrderStatuses.ordered,
    OrderStatuses.packed,
    OrderStatuses.shipped,
    OrderStatuses.delivered,
  ];

  factory OrderStatuses.fromId(int id) {
    return values.firstWhere((element) => element.id == id);
  }
}

@immutable
class OrderStatus {
  final int? id;
  final DateTime? date;
  final String? remarks;
  final String? statusKey;
  final int statusId;
  final String? status;

  const OrderStatus({
    this.id,
    this.date,
    this.remarks,
    this.statusKey,
    required this.statusId,
    this.status,
  });

  OrderStatuses get statusEnum => OrderStatuses.fromId(statusId);

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    id: json['id'] as int?,
    date: json['date'] == null
        ? null
        : DateTime.parse(json['date'] as String),
    remarks: json['remarks'] as String?,
    statusKey: json['statusKey'] as String?,
    statusId: json['statusID'] as int,
    status: json['status'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date?.toIso8601String(),
    'remarks': remarks,
    'statusKey': statusKey,
    'statusID': statusId,
    'status': status,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderStatus) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      date.hashCode ^
      remarks.hashCode ^
      statusKey.hashCode ^
      statusId.hashCode ^
      status.hashCode;
}
