import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/country_code.dart';
import 'package:base_ecom_appsure/widgets/phone_field.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';
import 'dart:async';
import '../../providers/reset_password_provider/reset_password_provider.dart';

part 'new_password_bs.dart';
part 'reset_password_bs.dart';
part 'verify_phone.dart';

class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({
    super.key,
    required this.scaffolContext,
  });

  final BuildContext scaffolContext;

  @override
  ConsumerState<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends ConsumerState<ResetPasswordView> {
  final _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    ref.listen(
      resetPasswordProvider,
          (previous, next) {
        if (next is OTPSent) {
          _animateTo(1);
        } else if (next is OTPVerified) {
          _animateTo(2);
        } else if (next is OTPRequestFailed) {
          showSnackBar(
            context,
            message: next.error.toString(),
            isError: true,
          );
        } else if (next is VerifyOTPFailed) {
          showSnackBar(
            context,
            message: next.error.toString(),
            isError: true,
          );
        } else if (next is ResetPasswordError) {
          showSnackBar(
            context,
            message: next.error.toString(),
            isError: true,
          );
        } else if (next is PasswordResetSuccess) {
          Navigator.of(context).pop(true);
        }
      },
    );
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: const [
        EnterPhoneView(),
        VerifyPhoneView(),
        NewPasswordView(),
      ],
    );
  }

  void _animateTo(int page) => _pageController.animateToPage(
    page,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );
}
