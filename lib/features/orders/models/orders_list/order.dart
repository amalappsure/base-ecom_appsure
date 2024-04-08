import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class Order {
  final int vid;
  final String vNo;
  final DateTime? date;
  final bool? isCancel;
  final double? amount;
  final int? count;
  final dynamic deliveryOption;
  final double? delCharge;

  const Order({
    required this.vid,
    required this.vNo,
    this.date,
    this.isCancel,
    this.amount,
    this.count,
    this.deliveryOption,
    this.delCharge,
  });

  @override
  String toString() {
    return 'Table(vid: $vid, vNo: $vNo, date: $date, isCancel: $isCancel, amount: $amount, count: $count, deliveryOption: $deliveryOption, delCharge: $delCharge)';
  }

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    vid: json['vid'] as int,
    vNo: json['vNo'] as String,
    date: json['date'] == null
        ? null
        : DateTime.parse(json['date'] as String),
    isCancel: json['isCancel'] as bool?,
    amount: (json['amount'] as num?)?.toDouble(),
    count: (json['count'] as num? ?? 0).toInt(),
    deliveryOption: json['deliveryOption'] as dynamic,
    delCharge: (json['delCharge'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'vid': vid,
    'vNo': vNo,
    'date': date?.toIso8601String(),
    'isCancel': isCancel,
    'amount': amount,
    'count': count,
    'deliveryOption': deliveryOption,
    'delCharge': delCharge,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Order) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      vid.hashCode ^
      vNo.hashCode ^
      date.hashCode ^
      isCancel.hashCode ^
      amount.hashCode ^
      count.hashCode ^
      deliveryOption.hashCode ^
      delCharge.hashCode;
}
