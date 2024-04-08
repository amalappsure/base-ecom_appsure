import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class UsersReviewResp {
  final bool status;
  final String statusCode;
  final String message;
  final UsersReview result;

  const UsersReviewResp({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.result,
  });

  @override
  String toString() {
    return 'ExistingReview(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory UsersReviewResp.fromJson(Map<String, dynamic> json) {
    return UsersReviewResp(
      status: json['status'] as bool,
      statusCode: json['statusCode'] as String,
      message: json['message'] as String,
      result: UsersReview.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'statusCode': statusCode,
    'message': message,
    'result': result.toJson(),
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UsersReviewResp) return false;
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
class UsersReview {
  final int id;
  final int orderId;
  final int userId;
  final int itemId;
  final String? title;
  final String? userComments;
  final int? userRatings;

  const UsersReview({
    this.id = 0,
    this.orderId = 0,
    this.userId = 0,
    this.itemId = 0,
    this.title,
    this.userComments,
    this.userRatings,
  });

  factory UsersReview.fromJson(Map<String, dynamic> json) => UsersReview(
    id: json['id'] as int? ?? 0,
    orderId: json['orderID'] as int? ?? 0,
    userId: json['userID'] as int? ?? 0,
    itemId: json['itemID'] as int? ?? 0,
    title: json['title'] as String?,
    userComments: json['userComments'] as String?,
    userRatings: json['userRatings'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderID': orderId,
    'userID': userId,
    'itemID': itemId,
    'title': title,
    'userComments': userComments,
    'userRatings': userRatings,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UsersReview) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      userId.hashCode ^
      itemId.hashCode ^
      title.hashCode ^
      userComments.hashCode ^
      userRatings.hashCode;
}
