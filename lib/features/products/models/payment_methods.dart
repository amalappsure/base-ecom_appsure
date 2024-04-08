import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class PaymentMethods {
  final bool? status;
  final String? statusCode;
  final String? message;
  final List<PaymentMethod> result;

  const PaymentMethods({
    this.status,
    this.statusCode,
    this.message,
    this.result = const [],
  });

  @override
  String toString() {
    return 'PaymentMethods(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    return PaymentMethods(
      status: json['status'] as bool?,
      statusCode: json['statusCode'] as String?,
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': result.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PaymentMethods) return false;
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

@immutable
class PaymentMethod {
  final int? id;
  final String? keyword;
  final String? description;
  final String? iconPath;
  final bool? resultDefault;
  final bool? active;
  final dynamic discountDescription;
  final dynamic orderNo;

  const PaymentMethod({
    this.id,
    this.keyword,
    this.description,
    this.iconPath,
    this.resultDefault,
    this.active,
    this.discountDescription,
    this.orderNo,
  });

  @override
  String toString() {
    return 'Result(id: $id, keyword: $keyword, description: $description, iconPath: $iconPath, resultDefault: $resultDefault, active: $active, discountDescription: $discountDescription, orderNo: $orderNo)';
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json['id'] as int?,
    keyword: json['keyword'] as String?,
    description: json['description'] as String?,
    iconPath: json['iconPath'] as String?,
    resultDefault: json['default'] as bool?,
    active: json['active'] as bool?,
    discountDescription: json['discountDescription'] as dynamic,
    orderNo: json['orderNo'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'keyword': keyword,
    'description': description,
    'iconPath': iconPath,
    'default': resultDefault,
    'active': active,
    'discountDescription': discountDescription,
    'orderNo': orderNo,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PaymentMethod) return false;

    return id == other.id;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      keyword.hashCode ^
      description.hashCode ^
      iconPath.hashCode ^
      resultDefault.hashCode ^
      active.hashCode ^
      discountDescription.hashCode ^
      orderNo.hashCode;
}
