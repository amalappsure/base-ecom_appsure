import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/auth/presentation/enter_otp_bottom_sheet.dart';
import 'package:base_ecom_appsure/features/auth/providers/auth_provider.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/country_code.dart';
import 'package:base_ecom_appsure/themes/padding.dart';
import 'package:base_ecom_appsure/widgets/phone_field.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class RegistrationView extends ConsumerStatefulWidget {
  const RegistrationView({super.key});

  @override
  ConsumerState<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends ConsumerState<RegistrationView> {
  final _formKey = GlobalKey<FormState>();

  late List<TextEditingController> _editingControllers;
  final _confirmMobileController = TextEditingController();
  CountryCode countryCode = countryCodes.first;
  bool registering = false;

  @override
  void initState() {
    _editingControllers = List.generate(
      4,
          (index) => TextEditingController(),
    );
    super.initState();
  }

  AppConfig get _appConfig => ref.read(appConfigProvider);

  AuthProvider get _authProvider => ref.read(authProvider);

  AppSettingsprovider get _settingsProvider => ref.read(settingsProvider);

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return SingleChildScrollView(
      padding: pagePadding(context),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate('Register'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[0],
              isRequired: true,
              label: settings.selectedLocale!.translate('YourName').replaceAll(
                ' *',
                '',
              ),
              validator: (value) => Rule(value,
                  name:
                  settings.selectedLocale!.translate('YourName').replaceAll(
                    ' *',
                    '',
                  ),
                  isRequired: true,
                  customErrors: {
                    'isRequired': settings.selectedLocale!.translate(
                      'EnterYourName',
                    )
                  }
                // isRequired: true,
              ).error,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            const Gap(18),
            PhoneFieldWithTitle(
              isRequired: true,
              label: settings.selectedLocale!.translate('GuestMobileNumber'),
              hint: settings.selectedLocale!.translate('GuestMobileNumber'),
              initialValue: countryCode,
              editingController: _editingControllers[1],
              onChanged: (value) {},
            ),
            const Gap(8),
            PhoneFieldWithTitle(
              editingController: _confirmMobileController,
              label: settings.selectedLocale!.translate('VerifyMobileNumber'),
              isRequired: true,
              initialValue: countryCode,
              onChanged: (value) {},
              validator: (value) {
                if (_editingControllers[1].text !=
                    _confirmMobileController.text) {
                  return settings.selectedLocale!.translate(
                    'MismatchMobile',
                  );
                }
                return null;
              },
            ),
            const Gap(8),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[2],
              label: settings.selectedLocale!.translate('Email'),
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('Email'),
                isEmail: true,
              ).error,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[3],
              isRequired: true,
              label: settings.selectedLocale!.translate('Password'),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return settings.selectedLocale!.translate(
                    'EnterPassword',
                  );
                }
                if ((value?.length ?? 0) < 8) {
                  return settings.selectedLocale!.translate(
                    'PasswordShort',
                  );
                }

                if (!_appConfig.enableComplexPassword) {
                  return null;
                }

                if (RegExp(r'^(?=.*[a-z])$').hasMatch(value!)) {
                  return settings.selectedLocale!.translate(
                    'PasswordAtleastOneLowercase',
                  );
                }
                if (RegExp(r'^(?=.*[A-Z])$').hasMatch(value)) {
                  return settings.selectedLocale!.translate(
                    'PasswordAtleastOneUppercase',
                  );
                }
                if (RegExp(r'^(?=.*[!@#$%^&*])$').hasMatch(value)) {
                  return settings.selectedLocale!.translate(
                    'PasswordAtleastOneSpecialChar',
                  );
                }

                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              bottomHint: settings.selectedLocale!.translate(
                'PasswordMustHave6Char',
              ),
            ),
            const Gap(24),
            if (registering)
              SizedBox.square(
                dimension: 48.0,
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submit(settings),
                      child: Text(
                        settings.selectedLocale!.translate('Submit'),
                      ),
                    ),
                  ),
                  const Gap(6),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _formKey.currentState!.reset(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        settings.selectedLocale!.translate('Reset'),
                      ),
                    ),
                  ),
                ],
              ),
            const Gap(12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                settings.selectedLocale!.translate('AlreadyAccount'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(AppSettingsprovider settings) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      registering = true;
    });

    final mobile = _editingControllers[1].text;
    final email = _editingControllers[2].text;

    final mobileExists = await _authProvider.userNameExists(
      mobile,
    );

    bool emailExists = false;

    if (!_appConfig.disableEmailValidationInRegistration && email.isNotEmpty) {
      emailExists = await _authProvider.userNameExists(
        email,
      );
    }

    if (mobileExists || emailExists) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: _settingsProvider.selectedLocale!.translate(
          'UsernameAlreadyExistPleaseLogin',
        ),
      );
      setState(() {
        registering = false;
      });
      return;
    }

    OtpModel? otp;

    if (!_appConfig.registerwithoutOTP) {
      otp = await _validateWithOtp(mobile, email);

      if (otp.value is! String) {
        setState(() {
          registering = false;
        });

        return;
      }
    }

    await _register(otp);

    setState(() {
      registering = false;
    });
  }

  Future<OtpModel> _validateWithOtp(String mobile, String email) async {
    final otpRef = await _authProvider.generateOTP(
      otpType: OTPType.registration,
      mobile: mobile,
      email: email,
    );

    // ignore: use_build_context_synchronously
    final result = await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => const EnterOTPBottoSheet(),
    );

    return OtpModel(
      ref: otpRef,
      value: result,
    );
  }

  Future<void> _register(OtpModel? otp) async {
    final name = _editingControllers[0].text;
    final mobile = _editingControllers[1].text;
    final email = _editingControllers[2].text;
    final password = _editingControllers[3].text;

    try {
      await _authProvider.registerUser(
        name: name,
        mobile: mobile,
        email: email,
        password: password,
        otpId: otp?.ref,
        otpValue: otp?.value,
      );

      await _authProvider.userLogin(
        username: mobile,
        password: password,
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: e.toString(),
      );
    }
  }
}

class OtpModel {
  final String ref;
  final dynamic value;

  OtpModel({
    required this.ref,
    required this.value,
  });
}
