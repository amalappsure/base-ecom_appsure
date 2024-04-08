import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:base_ecom_appsure/features/addresses/models/address.dart';

import 'delivery_charge.dart';
import 'order_status.dart';

@immutable
class OrderDetails {
  // final UserDetails? userDetails;
  // final PaymentDetails? paymentDetails;
  final Address? deliveryAddress;
  // final Address? paymentAddress;
  final DeliveryCharge? deliveryCharge;
  // final List<OrderItem> orderItems;
  final List<OrderStatus> orderStatus;
  // final dynamic purchaseOrder;
  // final dynamic batchSerials;
  final DateTime? orderDate;

  const OrderDetails(
      {
        // this.userDetails,
        // this.paymentDetails,
        this.deliveryAddress,
        // this.paymentAddress,
        this.deliveryCharge,
        // this.orderItems = const [],
        this.orderStatus = const [],
        // this.purchaseOrder,
        // this.batchSerials,
        this.orderDate});

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    // userDetails: json['userDetails'] == null
    //     ? null
    //     : UserDetails.fromJson(json['userDetails'] as Map<String, dynamic>),
    // paymentDetails: json['paymentDetails'] == null
    //     ? null
    //     : PaymentDetails.fromJson(
    //         json['paymentDetails'] as Map<String, dynamic>),
    deliveryAddress: json['deliveryAddress'] == null
        ? null
        : Address.fromJson(json['deliveryAddress'] as Map<String, dynamic>),
    // paymentAddress: json['paymentAddress'] == null
    //     ? null
    //     : Address.fromJson(json['paymentAddress'] as Map<String, dynamic>),
    deliveryCharge: json['deliveryCharge'] == null
        ? null
        : DeliveryCharge.fromJson(
        json['deliveryCharge'] as Map<String, dynamic>),
    // orderItems: (json['orderItems'] as List<dynamic>?)
    //         ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
    //         .toList() ??
    //     [],
    orderStatus: (json['orderStatus'] as List<dynamic>?)
        ?.map((e) => OrderStatus.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
    // purchaseOrder: json['purchaseOrder'] as dynamic,
    // batchSerials: json['batchSerials'] as dynamic,
    orderDate: json['paymentDetails']['paymentDate'] == null
        ? null
        : DateTime.parse(json['paymentDetails']['paymentDate'] as String),
  );

  Map<String, dynamic> toJson() => {
    // 'userDetails': userDetails?.toJson(),
    // 'paymentDetails': paymentDetails?.toJson(),
    'deliveryAddress': deliveryAddress?.toJson(),
    // 'paymentAddress': paymentAddress?.toJson(),
    'deliveryCharge': deliveryCharge?.toJson(),
    // 'orderItems': orderItems.map((e) => e.toJson()).toList(),
    'orderStatus': orderStatus.map((e) => e.toJson()).toList(),
    // 'purchaseOrder': purchaseOrder,
    // 'batchSerials': batchSerials,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderDetails) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      // userDetails.hashCode ^
  // paymentDetails.hashCode ^
  deliveryAddress.hashCode ^
  // paymentAddress.hashCode ^
  deliveryCharge.hashCode ^
  // orderItems.hashCode ^
  orderStatus.hashCode;
// purchaseOrder.hashCode ^
// batchSerials.hashCode;
}
