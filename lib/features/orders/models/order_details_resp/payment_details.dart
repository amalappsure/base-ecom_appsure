import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class PaymentDetails {
  final int? vid;
  final dynamic addressId;
  final String? vNo;
  final double? amount;
  final String? result;
  final DateTime? paymentDate;
  final String? authResult;
  final String? authRawResp;
  final dynamic authErrorCode;
  final dynamic authErrorMsg;
  final String? authCode;
  final String? transactionId;
  final dynamic paymentError;
  final dynamic localIp;
  final dynamic remoteIp;
  final String? paymentId;
  final String? reference;
  final bool? isCancel;
  final dynamic exception;
  final dynamic paymentType;
  final String? trackingId;
  final dynamic paymentTypeIcon;
  final String? estimatedDelivery;
  final double? discount;
  final double? promoCodeDisc;
  final int? id;
  final int? menuId;
  final int? companyId;

  const PaymentDetails({
    this.vid,
    this.addressId,
    this.vNo,
    this.amount,
    this.result,
    this.paymentDate,
    this.authResult,
    this.authRawResp,
    this.authErrorCode,
    this.authErrorMsg,
    this.authCode,
    this.transactionId,
    this.paymentError,
    this.localIp,
    this.remoteIp,
    this.paymentId,
    this.reference,
    this.isCancel,
    this.exception,
    this.paymentType,
    this.trackingId,
    this.paymentTypeIcon,
    this.estimatedDelivery,
    this.discount,
    this.promoCodeDisc,
    this.id,
    this.menuId,
    this.companyId,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      vid: json['vid'] as int?,
      addressId: json['addressID'] as dynamic,
      vNo: json['vNo'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      result: json['result'] as String?,
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      authResult: json['authResult'] as String?,
      authRawResp: json['authRawResp'] as String?,
      authErrorCode: json['authErrorCode'] as dynamic,
      authErrorMsg: json['authErrorMsg'] as dynamic,
      authCode: json['authCode'] as String?,
      transactionId: json['transactionID'] as String?,
      paymentError: json['paymentError'] as dynamic,
      localIp: json['localIP'] as dynamic,
      remoteIp: json['remoteIP'] as dynamic,
      paymentId: json['paymentID'] as String?,
      reference: json['reference'] as String?,
      isCancel: json['isCancel'] as bool?,
      exception: json['exception'] as dynamic,
      paymentType: json['paymentType'] as dynamic,
      trackingId: json['trackingID'] as String?,
      paymentTypeIcon: json['paymentTypeIcon'] as dynamic,
      estimatedDelivery: json['estimatedDelivery'] as String?,
      discount: (json['discount'] as num? ?? 0).toDouble(),
      promoCodeDisc: (json['promoCodeDisc'] as num? ?? 0).toDouble(),
      id: json['id'] as int?,
      menuId: json['menuID'] as int?,
      companyId: json['companyID'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'vid': vid,
    'addressID': addressId,
    'vNo': vNo,
    'amount': amount,
    'result': result,
    'paymentDate': paymentDate?.toIso8601String(),
    'authResult': authResult,
    'authRawResp': authRawResp,
    'authErrorCode': authErrorCode,
    'authErrorMsg': authErrorMsg,
    'authCode': authCode,
    'transactionID': transactionId,
    'paymentError': paymentError,
    'localIP': localIp,
    'remoteIP': remoteIp,
    'paymentID': paymentId,
    'reference': reference,
    'isCancel': isCancel,
    'exception': exception,
    'paymentType': paymentType,
    'trackingID': trackingId,
    'paymentTypeIcon': paymentTypeIcon,
    'estimatedDelivery': estimatedDelivery,
    'discount': discount,
    'promoCodeDisc': promoCodeDisc,
    'id': id,
    'menuID': menuId,
    'companyID': companyId,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PaymentDetails) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      vid.hashCode ^
      addressId.hashCode ^
      vNo.hashCode ^
      amount.hashCode ^
      result.hashCode ^
      paymentDate.hashCode ^
      authResult.hashCode ^
      authRawResp.hashCode ^
      authErrorCode.hashCode ^
      authErrorMsg.hashCode ^
      authCode.hashCode ^
      transactionId.hashCode ^
      paymentError.hashCode ^
      localIp.hashCode ^
      remoteIp.hashCode ^
      paymentId.hashCode ^
      reference.hashCode ^
      isCancel.hashCode ^
      exception.hashCode ^
      paymentType.hashCode ^
      trackingId.hashCode ^
      paymentTypeIcon.hashCode ^
      estimatedDelivery.hashCode ^
      discount.hashCode ^
      promoCodeDisc.hashCode ^
      id.hashCode ^
      menuId.hashCode ^
      companyId.hashCode;
}
