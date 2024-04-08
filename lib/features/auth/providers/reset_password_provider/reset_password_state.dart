part of 'reset_password_provider.dart';

@immutable
abstract class ResetPasswordState {
  const ResetPasswordState();
}

class Initial extends ResetPasswordState {}

class RequestingOTP extends ResetPasswordState {}

class OTPRequestFailed extends ResetPasswordState {
  const OTPRequestFailed({required this.error});
  final AppException error;
}

class OTPSent extends ResetPasswordState {
  const OTPSent({required this.otpRef});
  final String otpRef;
}

class VerifyingOTP extends ResetPasswordState {}

class VerifyOTPFailed extends ResetPasswordState {
  const VerifyOTPFailed({required this.error});
  final AppException error;
}

class OTPVerified extends ResetPasswordState {}

class ResettingPassword extends ResetPasswordState {}

class PasswordResetSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  const ResetPasswordError({required this.error});
  final AppException error;
}
