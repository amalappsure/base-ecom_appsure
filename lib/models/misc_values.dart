import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class MiscValues {
  final bool? status;
  final String? statusCode;
  final String? message;
  final List<MiscValue> result;

  const MiscValues({
    this.status,
    this.statusCode,
    this.message,
    this.result = const [],
  });

  @override
  String toString() {
    return 'MiscValue(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory MiscValues.fromJson(Map<String, dynamic> json) => MiscValues(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    result: (json['result'] as List<dynamic>?)
        ?.map((e) => MiscValue.fromJson(e as Map<String, dynamic>))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': result.map((e) => e.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! MiscValues) return false;
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

class MiscValue {
  final int id;

  final String value;

  const MiscValue({
    required this.id,
    required this.value,
  });

  @override
  String toString() => value;

  factory MiscValue.fromJson(Map<String, dynamic> json) => MiscValue(
    id: json['id'] as int,
    value: json['value'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'value': value,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! MiscValue) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
