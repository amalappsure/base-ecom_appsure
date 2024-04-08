import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class Unit {
  final int? id;
  final int? itemId;
  final int? unitId;
  final double? factor;
  final dynamic costPrice;
  final double? sellingPrice;
  final double? promotionPrice;
  final dynamic barcode;
  final bool? active;
  final dynamic units;
  final String? unit;
  final bool isDefault;

  const Unit({
    this.id,
    this.itemId,
    this.unitId,
    this.factor,
    this.costPrice,
    this.sellingPrice,
    this.promotionPrice,
    this.barcode,
    this.active,
    this.units,
    this.unit,
    this.isDefault = false,
  });

  @override
  String toString() {
    return 'Unit(id: $id, itemId: $itemId, unitId: $unitId, factor: $factor, costPrice: $costPrice, sellingPrice: $sellingPrice, promotionPrice: $promotionPrice, barcode: $barcode, active: $active, units: $units, unit: $unit, isDefault: $isDefault)';
  }

  double? get currentPrice => promotionPrice ?? sellingPrice;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json['id'] as int?,
    itemId: json['itemID'] as int?,
    unitId: json['unitID'] as int?,
    factor: json['factor'] as double?,
    costPrice: json['costPrice'] as dynamic,
    sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
    promotionPrice: (json['promotionPrice'] as num?)?.toDouble(),
    barcode: json['barcode'] as dynamic,
    active: json['active'] as bool?,
    units: json['units'] as dynamic,
    unit: json['unit'] as String?,
    isDefault: json['isDefault'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemID': itemId,
    'unitID': unitId,
    'factor': factor,
    'costPrice': costPrice,
    'sellingPrice': sellingPrice,
    'promotionPrice': promotionPrice,
    'barcode': barcode,
    'active': active,
    'units': units,
    'unit': unit,
    'isDefault': isDefault,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Unit) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      itemId.hashCode ^
      unitId.hashCode ^
      factor.hashCode ^
      costPrice.hashCode ^
      sellingPrice.hashCode ^
      promotionPrice.hashCode ^
      barcode.hashCode ^
      active.hashCode ^
      units.hashCode ^
      unit.hashCode ^
      isDefault.hashCode;
}
