import 'package:flutter/foundation.dart';

import 'package:base_ecom_appsure/features/checkout/models/time_slot.dart';
import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/item_delivery_option.dart';

@immutable
class CheckoutOptions {
  final List<ItemDeliveryOption> deliveryOptions;
  final List<PaymentMethod> paymentMethods;
  final List<TimeSlot> timeSlots;

  const CheckoutOptions({
    this.deliveryOptions = const [],
    this.paymentMethods = const [],
    this.timeSlots = const [],
  });

  factory CheckoutOptions.fromJson(
      Map<String, dynamic> map, {
        required String deliveryOptionsKey,
        String? timeSlotsKey,
      }) {
    return CheckoutOptions(
      deliveryOptions: (map['result'][deliveryOptionsKey] as List<dynamic>?)
          ?.map(
              (e) => ItemDeliveryOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      paymentMethods: (map['result']['table'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      timeSlots: timeSlotsKey == null
          ? []
          : (map['result'][timeSlotsKey] as List<dynamic>?)
          ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}
