import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class UserDetails {
  final String? name;
  final String? mobile;
  final dynamic countryCode;
  final String? email;
  final dynamic preferredLanguage;
  final dynamic addresses;
  final dynamic preferredLangId;
  final dynamic preferredLanguages;
  final dynamic newPassword;
  final dynamic confirmPassword;
  final dynamic message;
  final dynamic sessionId;
  final dynamic smsFor;
  final bool? isRememberMe;
  final dynamic externalLogin;
  final dynamic externalLoginId;
  final bool? isSocialMediaLogin;
  final int? id;
  final int? menuId;
  final int? companyId;

  const UserDetails({
    this.name,
    this.mobile,
    this.countryCode,
    this.email,
    this.preferredLanguage,
    this.addresses,
    this.preferredLangId,
    this.preferredLanguages,
    this.newPassword,
    this.confirmPassword,
    this.message,
    this.sessionId,
    this.smsFor,
    this.isRememberMe,
    this.externalLogin,
    this.externalLoginId,
    this.isSocialMediaLogin,
    this.id,
    this.menuId,
    this.companyId,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    name: json['name'] as String?,
    mobile: json['mobile'] as String?,
    countryCode: json['countryCode'] as dynamic,
    email: json['email'] as String?,
    preferredLanguage: json['preferredLanguage'] as dynamic,
    addresses: json['addresses'] as dynamic,
    preferredLangId: json['preferredLangID'] as dynamic,
    preferredLanguages: json['preferredLanguages'] as dynamic,
    newPassword: json['newPassword'] as dynamic,
    confirmPassword: json['confirmPassword'] as dynamic,
    message: json['message'] as dynamic,
    sessionId: json['sessionID'] as dynamic,
    smsFor: json['smsFor'] as dynamic,
    isRememberMe: json['isRememberMe'] as bool?,
    externalLogin: json['externalLogin'] as dynamic,
    externalLoginId: json['externalLoginID'] as dynamic,
    isSocialMediaLogin: json['isSocialMediaLogin'] as bool?,
    id: json['id'] as int?,
    menuId: json['menuID'] as int?,
    companyId: json['companyID'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'mobile': mobile,
    'countryCode': countryCode,
    'email': email,
    'preferredLanguage': preferredLanguage,
    'addresses': addresses,
    'preferredLangID': preferredLangId,
    'preferredLanguages': preferredLanguages,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
    'message': message,
    'sessionID': sessionId,
    'smsFor': smsFor,
    'isRememberMe': isRememberMe,
    'externalLogin': externalLogin,
    'externalLoginID': externalLoginId,
    'isSocialMediaLogin': isSocialMediaLogin,
    'id': id,
    'menuID': menuId,
    'companyID': companyId,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserDetails) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      name.hashCode ^
      mobile.hashCode ^
      countryCode.hashCode ^
      email.hashCode ^
      preferredLanguage.hashCode ^
      addresses.hashCode ^
      preferredLangId.hashCode ^
      preferredLanguages.hashCode ^
      newPassword.hashCode ^
      confirmPassword.hashCode ^
      message.hashCode ^
      sessionId.hashCode ^
      smsFor.hashCode ^
      isRememberMe.hashCode ^
      externalLogin.hashCode ^
      externalLoginId.hashCode ^
      isSocialMediaLogin.hashCode ^
      id.hashCode ^
      menuId.hashCode ^
      companyId.hashCode;
}
