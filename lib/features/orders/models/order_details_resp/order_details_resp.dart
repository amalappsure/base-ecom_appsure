import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'result.dart';

@immutable
class OrderDetailsResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final OrderDetails? result;

  const OrderDetailsResp({
    this.status,
    this.statusCode,
    this.message,
    this.result,
  });

  @override
  String toString() {
    return 'OrderDetailsResp(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory OrderDetailsResp.fromJson(Map<String, dynamic> json) {
    return OrderDetailsResp(
      status: json['status'] as bool?,
      statusCode: json['statusCode'] as String?,
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : OrderDetails.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': result?.toJson(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OrderDetailsResp) return false;
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
