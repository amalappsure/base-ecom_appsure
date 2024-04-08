import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/country_code.dart';
import 'package:base_ecom_appsure/widgets/phone_field.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

import 'package:base_ecom_appsure/features/auth/providers/auth_provider.dart';

import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';

part 'guest_login_bs.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({
    super.key,
    required this.onCreateNewAccount,
    required this.parentContext,
    required this.onResetPassword,
  });

  final VoidCallback onCreateNewAccount;
  final VoidCallback onResetPassword;
  final BuildContext parentContext;

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _editingControllers;

  bool submitting = false;

  @override
  void initState() {
    _editingControllers = List.generate(
      2,
          (index) => TextEditingController(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            settings.selectedLocale!.translate('Login'),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const Gap(24),
          TextFieldWithTitleBase.widget(
            controller: _editingControllers[0],
            label: settings.selectedLocale!.translate('Username'),
            validator: (value) => Rule(
              value,
              name: settings.selectedLocale!.translate('Username'),
              isRequired: true,
              customErrors: {
                'isRequired': settings.selectedLocale!.translate(
                  'EnterEmailMobileNumber',
                )
              },
            ).error,
            textInputAction: TextInputAction.next,
          ),
          const Gap(18),
          TextFieldWithTitleBase.widget(
            controller: _editingControllers[1],
            label: settings.selectedLocale!.translate('Password'),
            validator: (value) => Rule(
              value,
              name: settings.selectedLocale!.translate('Password'),
              isRequired: true,
              minLength: 8,
              customErrors: {
                'isRequired': settings.selectedLocale!.translate(
                  'PasswordMustHave6Char',
                ),
                'minLength': settings.selectedLocale!.translate(
                  'PasswordMustHave6Char',
                ),
              },
            ).error,
            textInputAction: TextInputAction.done,
            obscureText: true,
          ),
          const Gap(24),
          if (submitting)
            const SizedBox.square(
              dimension: 48.0,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          else
            ElevatedButton(
              onPressed: _login,
              child: Text(
                settings.selectedLocale!.translate('Login'),
              ),
            ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (ref.read(appConfigProvider).enableGuestLogin)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showModalBottomSheet(
                      context,
                      const GuestLoginBS(),
                    );
                  },
                  child: Text(
                    settings.selectedLocale!.translate('ContinueAsGuest'),
                  ),
                )
              else
                const SizedBox.shrink(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onResetPassword();
                },
                child: Text(
                  settings.selectedLocale!.translate('Resetpassword'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onCreateNewAccount();
                },
                child: Text(
                  settings.selectedLocale!.translate('CreateNewAccount'),
                ),
              ),
              const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      submitting = true;
    });
    try {
      final userNameExists = await ref.read(authProvider).userNameExists(
        _editingControllers[0].text,
      );

      if (!userNameExists) {
        throw AppException(
          ref
              .read(settingsProvider)
              .selectedLocale!
              .translate("InvalidUsernamePassword"),
        );
      }

      await ref.read(authProvider).userLogin(
        username: _editingControllers[0].text,
        password: _editingControllers[1].text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on AppException catch (e) {
      String message;
      if (e.toString() == 'Invalid User') {
        message = ref
            .read(settingsProvider)
            .selectedLocale!
            .translate("InvalidUsernamePassword");
      } else {
        message = e.toString();
      }
      // ignore: use_build_context_synchronously
      showSnackBar(
        widget.parentContext,
        isError: true,
        message: message,
      );
      // ignore: use_build_context_synchronously
      // Navigator.pop(context);
    }
    setState(() {
      submitting = false;
    });
  }

  Future<T?> _showModalBottomSheet<T>(
      BuildContext context,
      Widget widget,
      ) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => widget,
    );
  }
}
