import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrderDeliveryOption {
  final bool? appliedDelOption;

  final double? rate;
  final bool? sunday;
  final bool? monday;
  final bool? tuesday;
  final bool? wednesday;
  final bool? thursday;
  final bool? friday;
  final bool? saturday;

  final bool? isDefault;

  final bool? active;

  const OrderDeliveryOption({
    this.appliedDelOption,
    this.rate,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.isDefault,
    this.active,
  });

  @override
  String toString() {
    return 'OrderDeliveryOption( appliedDelOption: $appliedDelOption, rate: $rate, sunday: $sunday, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, isDefault: $isDefault, active: $active)';
  }

  factory OrderDeliveryOption.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryOption(
      appliedDelOption: json['appliedDelOption'] as bool?,
      rate: (json['rate'] as num? ?? 0).toDouble(),
      sunday: json['sunday'] as bool?,
      monday: json['monday'] as bool?,
      tuesday: json['tuesday'] as bool?,
      wednesday: json['wednesday'] as bool?,
      thursday: json['thursday'] as bool?,
      friday: json['friday'] as bool?,
      saturday: json['saturday'] as bool?,
      isDefault: json['isDefault'] as bool?,
      active: json['active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'appliedDelOption': appliedDelOption,
    'rate': rate,
    'sunday': sunday,
    'monday': monday,
    'tuesday': tuesday,
    'wednesday': wednesday,
    'thursday': thursday,
    'friday': friday,
    'saturday': saturday,
    'isDefault': isDefault,
    'active': active,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderDeliveryOption) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      appliedDelOption.hashCode ^
      rate.hashCode ^
      sunday.hashCode ^
      monday.hashCode ^
      tuesday.hashCode ^
      wednesday.hashCode ^
      thursday.hashCode ^
      friday.hashCode ^
      saturday.hashCode ^
      isDefault.hashCode ^
      active.hashCode;
}
