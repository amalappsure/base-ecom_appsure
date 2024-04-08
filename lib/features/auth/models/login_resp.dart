// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'package:base_ecom_appsure/foundation/string_exts.dart';

@immutable
class LoginResp {
  final bool? status;
  final String? statusCode;
  final String? message;
  final User? result;

  const LoginResp({
    this.status,
    this.statusCode,
    this.message,
    this.result,
  });

  @override
  String toString() {
    return 'LoginResp(status: $status, statusCode: $statusCode, message: $message, result: $result)';
  }

  factory LoginResp.fromJson(Map<String, dynamic> json) => LoginResp(
    status: json['status'] as bool?,
    statusCode: json['statusCode'] as String?,
    message: json['message'] as String?,
    result: json['result'] == null
        ? null
        : User.fromJson(json['result'] as Map<String, dynamic>),
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
    if (other is! LoginResp) return false;
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
class OtpModel {
  final int? id;
  final int? userId;
  final dynamic otpTypeId;
  final int? otpValue;
  final String? otpTime;
  final String? otpExpiryTime;
  final bool? processed;
  final dynamic remarks;
  final dynamic otpTypes;
  final dynamic email;
  final dynamic menuId;
  final dynamic companyId;
  final dynamic dataSet;
  final dynamic dataTable;
  final dynamic username;
  final dynamic localIp;
  final dynamic internetIp;
  final dynamic language;
  final dynamic connectionString;

  const OtpModel({
    this.id,
    this.userId,
    this.otpTypeId,
    this.otpValue,
    this.otpTime,
    this.otpExpiryTime,
    this.processed,
    this.remarks,
    this.otpTypes,
    this.email,
    this.menuId,
    this.companyId,
    this.dataSet,
    this.dataTable,
    this.username,
    this.localIp,
    this.internetIp,
    this.language,
    this.connectionString,
  });

  @override
  String toString() {
    return 'OtpModel(id: $id, userId: $userId, otpTypeId: $otpTypeId, otpValue: $otpValue, otpTime: $otpTime, otpExpiryTime: $otpExpiryTime, processed: $processed, remarks: $remarks, otpTypes: $otpTypes, email: $email, menuId: $menuId, companyId: $companyId, dataSet: $dataSet, dataTable: $dataTable, username: $username, localIp: $localIp, internetIp: $internetIp, language: $language, connectionString: $connectionString)';
  }

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
    id: json['id'] as int?,
    userId: json['userID'] as int?,
    otpTypeId: json['otpTypeID'] as dynamic,
    otpValue: json['otpValue'] as int?,
    otpTime: json['otpTime'] as String?,
    otpExpiryTime: json['otpExpiryTime'] as String?,
    processed: json['processed'] as bool?,
    remarks: json['remarks'] as dynamic,
    otpTypes: json['otpTypes'] as dynamic,
    email: json['email'] as dynamic,
    menuId: json['menuID'] as dynamic,
    companyId: json['companyID'] as dynamic,
    dataSet: json['dataSet'] as dynamic,
    dataTable: json['dataTable'] as dynamic,
    username: json['username'] as dynamic,
    localIp: json['localIP'] as dynamic,
    internetIp: json['internetIP'] as dynamic,
    language: json['language'] as dynamic,
    connectionString: json['connectionString'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userID': userId,
    'otpTypeID': otpTypeId,
    'otpValue': otpValue,
    'otpTime': otpTime,
    'otpExpiryTime': otpExpiryTime,
    'processed': processed,
    'remarks': remarks,
    'otpTypes': otpTypes,
    'email': email,
    'menuID': menuId,
    'companyID': companyId,
    'dataSet': dataSet,
    'dataTable': dataTable,
    'username': username,
    'localIP': localIp,
    'internetIP': internetIp,
    'language': language,
    'connectionString': connectionString,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OtpModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      otpTypeId.hashCode ^
      otpValue.hashCode ^
      otpTime.hashCode ^
      otpExpiryTime.hashCode ^
      processed.hashCode ^
      remarks.hashCode ^
      otpTypes.hashCode ^
      email.hashCode ^
      menuId.hashCode ^
      companyId.hashCode ^
      dataSet.hashCode ^
      dataTable.hashCode ^
      username.hashCode ^
      localIp.hashCode ^
      internetIp.hashCode ^
      language.hashCode ^
      connectionString.hashCode;
}

@immutable
class User {
  final String? name;
  final String? mobile;
  final String? countryCode;
  final String? email;
  final String? preferredLanguage;
  final dynamic addresses;
  final dynamic preferredLangId;
  final dynamic preferredLanguages;
  final OtpModel? otpModel;
  final dynamic newPassword;
  final dynamic confirmPassword;
  final dynamic message;
  final String? sessionId;
  final dynamic smsFor;
  final bool? isRememberMe;
  final dynamic externalLogin;
  final dynamic externalLoginId;
  final bool? isSocialMediaLogin;
  final int id;
  final int? menuId;
  final int? companyId;
  final String? language;
  final String? username;
  final String? password;
  final String? accessToken;
  final String? refreshToken;

  const User({
    this.name,
    this.mobile,
    this.countryCode,
    this.email,
    this.preferredLanguage,
    this.addresses,
    this.preferredLangId,
    this.preferredLanguages,
    this.otpModel,
    this.newPassword,
    this.confirmPassword,
    this.message,
    this.sessionId,
    this.smsFor,
    this.isRememberMe,
    this.externalLogin,
    this.externalLoginId,
    this.isSocialMediaLogin,
    required this.id,
    this.menuId,
    this.companyId,
    this.language,
    this.username,
    this.password,
    this.accessToken,
    this.refreshToken,
  });

  String get displayName => name.nullIfEmpty ?? 'Guest';

  bool get isGuest => displayName == 'Guest';

  @override
  String toString() {
    return 'Result(name: $name, mobile: $mobile, countryCode: $countryCode, email: $email, preferredLanguage: $preferredLanguage, addresses: $addresses, preferredLangId: $preferredLangId, preferredLanguages: $preferredLanguages, otpModel: $otpModel, newPassword: $newPassword, confirmPassword: $confirmPassword, message: $message, sessionId: $sessionId, smsFor: $smsFor, isRememberMe: $isRememberMe, externalLogin: $externalLogin, externalLoginId: $externalLoginId, isSocialMediaLogin: $isSocialMediaLogin, id: $id, menuId: $menuId, companyId: $companyId, language: $language, username: $username, password: $password)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] as String?,
    mobile: json['mobile'] as dynamic,
    countryCode: json['countryCode'] as dynamic,
    email: json['email'] as String?,
    preferredLanguage: json['preferredLanguage'] as String?,
    addresses: json['addresses'] as dynamic,
    preferredLangId: json['preferredLangID'] as dynamic,
    preferredLanguages: json['preferredLanguages'] as dynamic,
    otpModel: json['otpModel'] == null
        ? null
        : OtpModel.fromJson(json['otpModel'] as Map<String, dynamic>),
    newPassword: json['newPassword'] as dynamic,
    confirmPassword: json['confirmPassword'] as dynamic,
    message: json['message'] as dynamic,
    sessionId: json['sessionID'] as String?,
    smsFor: json['smsFor'] as dynamic,
    isRememberMe: json['isRememberMe'] as bool?,
    externalLogin: json['externalLogin'] as dynamic,
    externalLoginId: json['externalLoginID'] as dynamic,
    isSocialMediaLogin: json['isSocialMediaLogin'] as bool?,
    id: json['id'] as int,
    menuId: json['menuID'] as int?,
    companyId: json['companyID'] as int?,
    language: json['language'] as String?,
    username: json['username'] as String?,
    password: json['password'] as String?,
    accessToken: json['token'] as String?,
    refreshToken: json['refreshToken'] as String?,
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
    'otpModel': otpModel?.toJson(),
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
    'language': language,
    'username': username,
    'password': password,
    'token': accessToken,
    'refreshToken': refreshToken,
  };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! User) return false;
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
      otpModel.hashCode ^
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
      companyId.hashCode ^
      language.hashCode ^
      username.hashCode ^
      password.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode;

  User copyWith({
    String? name,
    String? mobile,
    String? countryCode,
    String? email,
    String? preferredLanguage,
    String? sessionId,
    bool? isRememberMe,
    bool? isSocialMediaLogin,
    int? id,
    int? menuId,
    int? companyId,
    String? language,
    String? username,
    String? password,
    String? accessToken,
    String? refreshToken,
  }) {
    return User(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      sessionId: sessionId ?? this.sessionId,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      isSocialMediaLogin: isSocialMediaLogin ?? this.isSocialMediaLogin,
      id: id ?? this.id,
      menuId: menuId ?? this.menuId,
      companyId: companyId ?? this.companyId,
      language: language ?? this.language,
      username: username ?? this.username,
      password: password ?? this.password,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
