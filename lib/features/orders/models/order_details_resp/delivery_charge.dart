import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class DeliveryCharge {
  final double? exchangeRate;
  final double? quantity;
  final double? amount;
  final double? fcAmount;
  final bool? sunday;
  final bool? monday;
  final bool? tuesday;
  final bool? wednesday;
  final bool? thursday;
  final bool? friday;
  final bool? saturday;
  final dynamic fromTime;
  final dynamic toTime;
  final dynamic date;

  const DeliveryCharge({
    this.exchangeRate,
    this.quantity,
    this.amount,
    this.fcAmount,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.fromTime,
    this.toTime,
    this.date,
  });

  @override
  String toString() {
    return 'DeliveryCharge(exchangeRate: $exchangeRate, quantity: $quantity, amount: $amount, fcAmount: $fcAmount, sunday: $sunday, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, fromTime: $fromTime, toTime: $toTime, date: $date)';
  }

  factory DeliveryCharge.fromJson(Map<String, dynamic> json) {
    return DeliveryCharge(
      exchangeRate: (json['exchangeRate'] as num? ?? 0).toDouble(),
      quantity: (json['quantity'] as num? ?? 0).toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      fcAmount: (json['fcAmount'] as num?)?.toDouble(),
      sunday: json['sunday'] as bool?,
      monday: json['monday'] as bool?,
      tuesday: json['tuesday'] as bool?,
      wednesday: json['wednesday'] as bool?,
      thursday: json['thursday'] as bool?,
      friday: json['friday'] as bool?,
      saturday: json['saturday'] as bool?,
      fromTime: json['fromTime'] as dynamic,
      toTime: json['toTime'] as dynamic,
      date: json['date'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
    'exchangeRate': exchangeRate,
    'quantity': quantity,
    'amount': amount,
    'fcAmount': fcAmount,
    'sunday': sunday,
    'monday': monday,
    'tuesday': tuesday,
    'wednesday': wednesday,
    'thursday': thursday,
    'friday': friday,
    'saturday': saturday,
    'fromTime': fromTime,
    'toTime': toTime,
    'date': date,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DeliveryCharge) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      exchangeRate.hashCode ^
      quantity.hashCode ^
      amount.hashCode ^
      fcAmount.hashCode ^
      sunday.hashCode ^
      monday.hashCode ^
      tuesday.hashCode ^
      wednesday.hashCode ^
      thursday.hashCode ^
      friday.hashCode ^
      saturday.hashCode ^
      fromTime.hashCode ^
      toTime.hashCode ^
      date.hashCode;
}
