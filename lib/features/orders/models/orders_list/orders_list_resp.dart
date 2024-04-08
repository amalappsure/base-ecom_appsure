import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'orders_list_result.dart';

@immutable
class OrdersListResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final OrdersListResult? result;

  const OrdersListResp({
    this.status,
    this.statusCode,
    this.message,
    this.result,
  });

  @override
  String toString() {
    return 'OrdersList(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory OrdersListResp.fromJson(Map<String, dynamic> json) => OrdersListResp(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    result: json['result'] == null
        ? null
        : OrdersListResult.fromJson(json['result'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': result?.toJson(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrdersListResp) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      status.hashCode ^
      statusCode.hashCode ^
      message.hashCode ^
      result.hashCode;
}
