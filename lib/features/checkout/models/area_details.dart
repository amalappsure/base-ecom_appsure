import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class AreaDetailsResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final AreaDetails? details;

  const AreaDetailsResp({
    this.status,
    this.statusCode,
    this.message,
    this.details,
  });

  @override
  String toString() {
    return 'AreaDetails(status: $status, statusCode: $statusCode, message: $message, result: $details)';
  }

  factory AreaDetailsResp.fromJson(Map<String, dynamic> json) =>
      AreaDetailsResp(
        status: json['status'] as bool?,
        statusCode: json['statusCode'] as String?,
        message: json['message'] as String?,
        details: json['result'] == null
            ? null
            : AreaDetails.fromJson(json['result'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': details?.toJson(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AreaDetailsResp) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      status.hashCode ^
      statusCode.hashCode ^
      message.hashCode ^
      details.hashCode;
}

@immutable
class AreaDetails {
  final int? id;
  final int? areaId;
  final dynamic area;
  final double deliveryCharge;
  final double basketSize;
  final bool? active;
  final int? rowState;
  final dynamic normalDeliveryCharge;
  final double fastDeliveryCharge;

  const AreaDetails({
    this.id,
    this.areaId,
    this.area,
    this.deliveryCharge = 0.0,
    this.basketSize = 0.0,
    this.active,
    this.rowState,
    this.normalDeliveryCharge,
    this.fastDeliveryCharge = 0.0,
  });

  @override
  String toString() {
    return 'Result(id: $id, areaId: $areaId, area: $area, deliveryCharge: $deliveryCharge, basketSize: $basketSize, active: $active, rowState: $rowState, normalDeliveryCharge: $normalDeliveryCharge, fastDeliveryCharge: $fastDeliveryCharge)';
  }

  factory AreaDetails.fromJson(Map<String, dynamic> json) => AreaDetails(
    id: json['id'] as int?,
    areaId: json['areaID'] as int?,
    area: json['area'] as dynamic,
    deliveryCharge: (json['deliveryCharge'] as num? ?? 0).toDouble(),
    basketSize: (json['basketSize'] as num? ?? 0).toDouble(),
    active: json['active'] as bool?,
    rowState: json['rowState'] as int?,
    normalDeliveryCharge: json['normalDeliveryCharge'] as dynamic,
    fastDeliveryCharge:
    (json['fastDeliveryCharge'] as num? ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'areaID': areaId,
    'area': area,
    'deliveryCharge': deliveryCharge,
    'basketSize': basketSize,
    'active': active,
    'rowState': rowState,
    'normalDeliveryCharge': normalDeliveryCharge,
    'fastDeliveryCharge': fastDeliveryCharge,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AreaDetails) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      areaId.hashCode ^
      area.hashCode ^
      deliveryCharge.hashCode ^
      basketSize.hashCode ^
      active.hashCode ^
      rowState.hashCode ^
      normalDeliveryCharge.hashCode ^
      fastDeliveryCharge.hashCode;
}
