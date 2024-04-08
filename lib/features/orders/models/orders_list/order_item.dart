import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrderItem {
  final int itemId;
  final int unitId;
  final String? itemImage;
  final String? itemName;
  final String? unit;
  final int? quantity;

  final double? rate;
  final double? amount;

  final int? vid;
  final String? vNo;
  final DateTime? date;
  final String? status;
  final DateTime? statusDate;
  final bool? isCancel;
  final dynamic deliveryOption;
  final double? delCharge;
  final String? serialNo;
  final String? urlName;

  const OrderItem(
      {this.vid,
        this.vNo,
        this.date,
        this.quantity,
        this.rate,
        this.amount,
        this.itemImage,
        this.itemName,
        this.status,
        this.statusDate,
        this.isCancel,
        this.deliveryOption,
        this.delCharge,
        this.unit,
        this.serialNo,
        required this.itemId,
        this.urlName,
        required this.unitId});

  @override
  String toString() {
    return 'Table1(vid: $vid, vNo: $vNo, date: $date, quantity: $quantity, rate: $rate, amount: $amount, itemImage: $itemImage, itemName: $itemName, status: $status, statusDate: $statusDate, isCancel: $isCancel, deliveryOption: $deliveryOption, delCharge: $delCharge, unit: $unit, serialNo: $serialNo, itemId: $itemId, urlName: $urlName)';
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    vid: json['vid'] as int?,
    vNo: json['vNo'] as String?,
    date: json['date'] == null
        ? null
        : DateTime.parse(json['date'] as String),
    quantity: (json['quantity'] as num? ?? 0).toInt(),
    rate: (json['rate'] as num?)?.toDouble(),
    amount: (json['amount'] as num?)?.toDouble(),
    itemImage: json['itemImage'] as String?,
    itemName: json['itemName'] as String?,
    status: json['status'] as String?,
    statusDate: json['statusDate'] == null
        ? null
        : DateTime.parse(json['statusDate'] as String),
    isCancel: json['isCancel'] as bool?,
    deliveryOption: json['deliveryOption'] as dynamic,
    delCharge: (json['delCharge'] as num?)?.toDouble(),
    unit: json['unit'] as String?,
    serialNo: json['serialNo'] as String?,
    itemId: json['itemID'] as int,
    unitId: json['unitID'] as int,
    urlName: json['urlName'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'vid': vid,
    'vNo': vNo,
    'date': date?.toIso8601String(),
    'quantity': quantity,
    'rate': rate,
    'amount': amount,
    'itemImage': itemImage,
    'itemName': itemName,
    'status': status,
    'statusDate': statusDate?.toIso8601String(),
    'isCancel': isCancel,
    'deliveryOption': deliveryOption,
    'delCharge': delCharge,
    'unit': unit,
    'serialNo': serialNo,
    'itemID': itemId,
    'urlName': urlName,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderItem) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      vid.hashCode ^
      vNo.hashCode ^
      date.hashCode ^
      quantity.hashCode ^
      rate.hashCode ^
      amount.hashCode ^
      itemImage.hashCode ^
      itemName.hashCode ^
      status.hashCode ^
      statusDate.hashCode ^
      isCancel.hashCode ^
      deliveryOption.hashCode ^
      delCharge.hashCode ^
      unit.hashCode ^
      serialNo.hashCode ^
      itemId.hashCode ^
      urlName.hashCode;
}
