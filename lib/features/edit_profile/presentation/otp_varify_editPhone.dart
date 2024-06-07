

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import '../../../widgets/text_field_with_title.dart';
import '../../app_settings/providers/settings_provider.dart';
import '../../auth/models/OTP_Response.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/reset_password_provider/reset_password_provider.dart';
import '../providers/edit_profile_provider.dart';


class OTPVerifyPhoneView extends ConsumerStatefulWidget {
  final String otpKey;
  final String mobilePrimary;
  final String mobileNew;

  const OTPVerifyPhoneView({super.key,required this.otpKey, required this.mobilePrimary,  required this.mobileNew});

  @override
  ConsumerState<OTPVerifyPhoneView> createState() => _OTPVerifyPhoneBSState();
}

class _OTPVerifyPhoneBSState extends ConsumerState<OTPVerifyPhoneView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _editingController;

  final _focusNode = FocusNode();

  static const maxSeconds = 3 * 60;
  int remainingSeconds = maxSeconds;
  Timer? timer;
  bool? response;
  bool submitting = false;
  String otpMessage = '';

  @override
  void initState() {
    _editingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => FocusScope.of(context).requestFocus(_focusNode),
    );
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }


  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    otpMessage = settings.selectedLocale!.translate('InvalidOTP');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate('VerifyMobileNumber'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            Text(
              settings.selectedLocale!.translate(
                'AtextWithOneTimePasswordMobileNumber',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              focusNode: _focusNode,
              label: settings.selectedLocale!.translate('EnterOTP'),
              controller: _editingController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('EnterOTP'),
                isRequired: true,
                isNumeric: true,
                maxLength: 6,
                minLength: 6,
              ).error,
            ),
            const Gap(5),
            Center(
              child: Text(
                formatDuration(remainingSeconds),
                style: TextStyle(fontSize: 15),
              ),
            ),
            const Gap(18),
            if (submitting)
              const SizedBox.square(
                dimension: 48.0,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  settings.selectedLocale!.translate('Continue'),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {

    setState(() {
      submitting = true;
    });
    if (!_formKey.currentState!.validate()) return;
    response  = await ref.read(authProvider).validateOTPForChangeMobile(otp: _editingController.text, otpRef: widget.otpKey, mobile: widget.mobilePrimary);

    if(response == true){
      await ref.read(editProfileProvider).updateMobile(
            widget.mobileNew,
          );
      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(otpMessage)
          )
      );
    }
    setState(() {
      submitting = false;
    });
  }
}
