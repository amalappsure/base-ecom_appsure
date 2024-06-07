import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/auth/models/login_resp.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../../app_config/config.dart';
import '../models/OTP_Response.dart';
import 'login_state_provider.dart';

enum OTPType {
  registration("Registration", "0"),
  forgotPassword("Password Reset", "1");

  const OTPType(this.name, this.id);

  final String name;
  final String id;
}

final authProvider = StateProvider((ref) => AuthProvider(ref));

class AuthProvider{
  AuthProvider(this._ref) : _restClient = _ref.read(restClientProvider);

  final Ref _ref;
  final RestClient _restClient;



  AppSettingsprovider get _settingsProvider => _ref.read(settingsProvider);

  String get _language => _settingsProvider.selectedLocale!.name;

  AppConfig get appConfig => _ref.read(appConfigProvider);

  bool get isLoggedIn => _ref.read(loginStateProvider) is LoggedIn;

  Future<bool> userNameExists(String username) async {
    final response = await _restClient.userNameExists({
      'Language': _language,
      'Username': username,
    });
    return response['result'] as bool? ?? false;
  }

  Future<String> generateOTP({
    required String mobile,
    String email = '',
    required OTPType otpType,
  }) async {
    final response = await _restClient.generateOTP({
      "Language": _language,
      "String1": otpType.name,
      "String2": otpType.name,
      "String3": mobile,
      "String4": email.nullIfEmpty,
      "TypeObject1": mobile,
      "TypeObject3": otpType.id,
      "TypeObject2": {
        "SMSFor": otpType.name,
        "OtpTypes": otpType.name,
        "OtpTypeID": otpType.id,
        "Language": _language,
        "Mobile": mobile,
        "Username": mobile,
      },
    });

    return response['result'] as String;
  }

  Future<String> validateOTP({
    required String otp,
    required String otpRef,
    required String mobile,
  }) async {
    final response = await _restClient.putOTP({
      "String5": otpRef,
      "Int1": int.parse(otp),
      "TypeObject2": {
        "OtpValue": otp,
        "Language": _language,
        "Mobile": mobile,
      },
    });

    print('response $response');
    return response['result'] as String;
  }

  Future<bool> validateOTPForChangeMobile({
    required String otp,
    required String otpRef,
    required String mobile,
  }) async {
    final config = GetIt.I.get<Config>();

    final map = {
      "String5": otpRef,
      "Int1": int.parse(otp),
      "TypeObject2": {
        "OtpValue": int.parse(otp),
        "Language": _language,
        "Mobile": mobile,
      },
    };

    final response = await http.post(
      Uri.parse("${config.baseUrl}/PutOTPMobile"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(map),
    );

    if (response.statusCode == 200) {
      final otpResponse = jsonDecode(response.body);
      return otpResponse['status'];
    } else {
      throw Exception('Failed to send OTP');
    }
  }


  Future<void> registerUser({
    required String name,
    required String mobile,
    required String email,
    required String password,
    bool isSocialMediaLogin = false,
    String? otpId,
    String? countryCode,
    String? otpValue,
    int? preferredLangID,
    // String? externalLogin,
    // String? externalLoginID,
  }) async {
    final map = {
      "Language": _language,
      "Username": mobile,
      "String5": otpId,
      "TypeObject1": {
        if (otpValue != null)
          "OTPModel": {
            "OtpValue": otpValue,
          },
        "Language": _language,
        "Username": mobile,
        "Name": name,
        "CountryCode": "+965",
        "Mobile": mobile,
        "Email": email,
        "Password": password,
        "PreferredLangID": preferredLangID ?? 0,
      },
    };
    try {
      await _restClient.registerUser(map);
    } catch (e) {
      throw AppException(e);
    }
  }

  Future<void> registerGuestUser({
    required String name,
    required String mobile,
    String? email,
    int? id,
    String? countryCode,
    String? password,
    String? otpValue,
    String? preferredLangID,
    String? newID,
    String? nameToDisplay,
  }) async {
    if (!appConfig.enableGuestLogin) return;
    try {
      final map = {
        "Language": _language,
        "Name": name,
        "Username": mobile,
        "Mobile": mobile,
      };
      if (email != null) {
        map.putIfAbsent("Email", () => email);
      }
      if (id != null) {
        map.putIfAbsent("ID", () => id.toString());
      }
      if (password != null) {
        map.putIfAbsent("Password", () => password.toString());
      }
      if (countryCode != null) {
        map.putIfAbsent("CountryCode", () => countryCode.toString());
      }
      if (otpValue != null) {
        map.putIfAbsent("OtpValue", () => otpValue.toString());
      }
      if (preferredLangID != null) {
        map.putIfAbsent("PreferredLangID", () => preferredLangID.toString());
      }
      if (newID != null) {
        map.putIfAbsent("NewID", () => newID.toString());
      }
      if (nameToDisplay != null) {
        map.putIfAbsent("NameToDisplay", () => nameToDisplay.toString());
      }

      final response = await _restClient.registerGuestUser(
        {"typeobject1": map},
      );

      final userId = int.parse((response['result'] as String).split(',').first);

      HiveRepo.instance.user = User(
        username: mobile,
        mobile: mobile,
        email: email,
        name: 'Guest',
        id: userId,
      );

      try {
        HiveRepo.instance.setTokens(
          accessToken: (response['result'] as String).split(',')[3],
          refreshToken: (response['result'] as String).split(',')[2],
        );
      } catch (e) {
        //
      }

      final details = await _restClient.getSecurityDetails({
        "TypeObject2": {
          "ID": userId,
          "Username": mobile,
        },
      });

      HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
        mobile: details.result?.mobile,
      );

      _ref.read(loginStateProvider.notifier).state = LoggedIn(
        user: HiveRepo.instance.user!,
      );
    } catch (e) {
      throw AppException(e);
    }
  }

  Future<void> userLogin({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    LoginResp response;
    try {
      response = await _restClient.userLogin({
        "TypeObject2": {
          "Language": _language,
          "Username": username,
          "Password": password,
        }
      });

      if (response.result?.id == 0) {
        throw _settingsProvider.selectedLocale!.translate('InvalidUser');
      }

      HiveRepo.instance.setTokens(
        accessToken: response.result?.accessToken,
        refreshToken: response.result?.refreshToken,
      );

      response.result!.isRememberMe = rememberMe;
      HiveRepo.instance.user = response.result;
      print('rememberMe $rememberMe');
      print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn ${ HiveRepo.instance.user!.isRememberMe}');

      final details = await _restClient.getSecurityDetails({
        "TypeObject2": {
          "ID": response.result?.id,
          "Username": response.result?.username,
        },
      });

      HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
        mobile: details.result?.mobile,
      );

      print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm ${ HiveRepo.instance.user!.isRememberMe}');

      _ref.read(loginStateProvider.notifier).state = LoggedIn(
        user: HiveRepo.instance.user!,
      );
    } catch (e) {
      throw AppException(e);
    }
  }

  Future<void> refreshLocalUser() async {
    final user = HiveRepo.instance.user;
    final details = await _restClient.getSecurityDetails({
      "TypeObject2": {
        "ID": user?.id,
        "Username": user?.username,
      },
    });

    HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
      username: details.result?.username,
      name: details.result?.name,
      email: details.result?.email,
      mobile: details.result?.mobile,
    );

    Future.delayed(
      const Duration(seconds: 1),
          () => _ref.read(loginStateProvider.notifier).state = LoggedIn(
        user: HiveRepo.instance.user!,
      ),
    );
  }

  Future<void> forgotPasswordPasswordUpdate({
    required String userId,
    required String otpRef,
    required String newPassword,
  }) async {
    await _restClient.passwordUpdate({
      "String1": userId,
      "String2": otpRef,
      "Language": _language,
      "String3": newPassword,
      "String4": newPassword
    });
  }

// Future<void> getDefaultToken() async {
//   try {
//     final response = await _restClient.getTokens({
//       "key": "TfzGsUibDwQSPbE3Gs5NUQ==",
//       "Username": HiveRepo.instance.userName,
//       "Role": 'default',
//     });

//     HiveRepo.instance.setTokens(
//       response.result?.accessToken,
//       response.result?.refreshToken,
//     );
//   } catch (e) {
//     throw AppException(e);
//   }
// }
}
