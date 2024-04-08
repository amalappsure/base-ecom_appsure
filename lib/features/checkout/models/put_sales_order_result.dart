// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class PutSalesOrderResp {
  const PutSalesOrderResp({
    this.status,
    this.statusCode,
    this.message,
    this.result,
  });

  final bool? status;
  final String? statusCode;
  final String? message;
  final PutSalesOrderResult? result;

  factory PutSalesOrderResp.fromJson(Map<String, dynamic> json) =>
      PutSalesOrderResp(
        status: json['status'] as bool?,
        statusCode: json['statusCode'] as String?,
        message: json['message'] as String?,
        result: json['result'] == null
            ? null
            : PutSalesOrderResult.fromJson(
          json['result'] as Map<String, dynamic>,
        ),
      );

  @override
  String toString() {
    return 'PutSalesOrderResp(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }
}

@immutable
class PutSalesOrderResult {
  final int? voucherID;
  final int? int2;
  final int? int3;
  final String? voucherNumber;
  final String? string2;
  final String? string3;
  final String? string4;
  final String? string5;
  final String? string6;

  const PutSalesOrderResult({
    this.voucherID,
    this.int2,
    this.int3,
    this.voucherNumber,
    this.string2,
    this.string3,
    this.string4,
    this.string5,
    this.string6,
  });

  @override
  String toString() {
    return 'PutSalesOrderResult(int1: $voucherID, int2: $int2, int3: $int3, string1: $voucherNumber, string2: $string2, string3: $string3, string4: $string4, string5: $string5, string6: $string6)';
  }

  factory PutSalesOrderResult.fromJson(Map<String, dynamic> json) {
    return PutSalesOrderResult(
      voucherID: json['int1'] as int?,
      int2: json['int2'] as int?,
      int3: json['int3'] as int?,
      voucherNumber: json['string1'] as String?,
      string2: json['string2'] as String?,
      string3: json['string3'] as String?,
      string4: json['string4'] as String?,
      string5: json['string5'] as String?,
      string6: json['string6'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'int1': voucherID,
    'int2': int2,
    'int3': int3,
    'string1': voucherNumber,
    'string2': string2,
    'string3': string3,
    'string4': string4,
    'string5': string5,
    'string6': string6,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PutSalesOrderResult) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      voucherID.hashCode ^
      int2.hashCode ^
      int3.hashCode ^
      voucherNumber.hashCode ^
      string2.hashCode ^
      string3.hashCode ^
      string4.hashCode ^
      string5.hashCode ^
      string6.hashCode;
}
