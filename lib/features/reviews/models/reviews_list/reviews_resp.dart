import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'reviews_lists.dart';

@immutable
class ReviewsResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final ReviewsLists? result;

  const ReviewsResp({
    this.status,
    this.statusCode,
    this.message,
    this.result,
  });

  @override
  String toString() {
    return 'ReviewsList(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory ReviewsResp.fromJson(Map<String, dynamic> json) => ReviewsResp(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    result: json['result'] == null
        ? null
        : ReviewsLists.fromJson(json['result'] as Map<String, dynamic>),
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
    if (other is! ReviewsResp) return false;
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
