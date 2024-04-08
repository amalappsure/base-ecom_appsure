import 'package:flutter/foundation.dart';

import 'product_details.dart';

@immutable
class ProductDetailsResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final ProductDetails? result;

  const ProductDetailsResp({
    this.status,
    this.statusCode,
    this.message,
    this.result,
  });

  @override
  String toString() {
    return 'ProductDetails(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory ProductDetailsResp.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResp(
      status: json['status'] as bool?,
      statusCode: json['statusCode'] as String?,
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : ProductDetails.fromJson(json['result'] as Map<String, dynamic>),
    );
  }
}
