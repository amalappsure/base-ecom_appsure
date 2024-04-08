import 'package:base_ecom_appsure/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:flutter/material.dart';

part 'reset_password_state.dart';

final resetPasswordProvider =
StateNotifierProvider<ResetPasswordProvider, ResetPasswordState>(
      (ref) => ResetPasswordProvider(ref),
);

class ResetPasswordProvider extends StateNotifier<ResetPasswordState> {
  ResetPasswordProvider(Ref ref)
      : _ref = ref,
        super(Initial());

  final Ref _ref;
  late String _otpRef;
  late String _mobile;
  late String _userId;

  Future<void> requestOTP(String mobile) async {
    _mobile = mobile;
    state = RequestingOTP();

    bool exists;

    try {
      exists = await _ref.read(authProvider).userNameExists(mobile);
    } catch (e) {
      state = OTPRequestFailed(
        error: AppException(e),
      );
      return;
    }
    if (!exists) {
      state = OTPRequestFailed(
        error: AppException('User not found'),
      );
      return;
    }

    try {
      final otpRef = await _ref.read(authProvider).generateOTP(
        mobile: mobile,
        otpType: OTPType.forgotPassword,
      );

      _otpRef = otpRef;
      state = OTPSent(otpRef: otpRef);
    } catch (e) {
      state = OTPRequestFailed(
        error: AppException(e),
      );
    }
  }

  Future<void> verifyOTP(String otp) async {
    state = VerifyingOTP();
    try {
      _userId = await _ref
          .read(authProvider)
          .validateOTP(otp: otp, otpRef: _otpRef, mobile: _mobile);

      state = OTPVerified();
    } catch (e) {
      state = VerifyOTPFailed(error: AppException(e));
    }
  }

  Future<void> updatePassword(String password) async {
    state = ResettingPassword();
    try {
      await _ref.read(authProvider).forgotPasswordPasswordUpdate(
        userId: _userId,
        newPassword: password,
        otpRef: _otpRef,
      );
      state = PasswordResetSuccess();
    } catch (e) {
      state = ResetPasswordError(error: AppException(e));
    }
  }
}
