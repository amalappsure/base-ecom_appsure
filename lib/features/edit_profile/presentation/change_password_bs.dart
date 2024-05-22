import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/edit_profile/providers/edit_profile_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class ChangePasswordBS extends ConsumerStatefulWidget {
  const ChangePasswordBS({super.key});

  @override
  ConsumerState<ChangePasswordBS> createState() => _ChangePasswordBSState();
}

class _ChangePasswordBSState extends ConsumerState<ChangePasswordBS> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _editingControllers;

  bool submitting = false;

  final visibilities = <String, bool>{
    "old": true,
    "new": true,
    "confirm": true,
  };

  @override
  void initState() {
    _editingControllers = List.generate(3, (index) {
      return TextEditingController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(settingsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate(
                'ChangePassword',
              ),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(18.0),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[0],
              label: settings.selectedLocale!.translate('OldPassword'),
              hint: settings.selectedLocale!.translate('Password'),
              validator: (value) {
                final error = Rule(
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
                ).error;

                if (error != null) {
                  return error;
                }

                if (HiveRepo.instance.user?.password !=
                    _editingControllers[0].text) {
                  return settings.selectedLocale!.translate(
                    'PasswordNotMatch',
                  );
                }

                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: visibilities['old']!,
              textInputAction: TextInputAction.next,
              suffixIcon: eye('old'),
            ),
            const Gap(18.0),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[1],
              label: settings.selectedLocale!.translate('NewPassword'),
              hint: settings.selectedLocale!.translate('Password'),
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
              keyboardType: TextInputType.visiblePassword,
              obscureText: visibilities['new']!,
              textInputAction: TextInputAction.next,
              suffixIcon: eye('new'),
            ),
            const Gap(18.0),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[2],
              label: settings.selectedLocale!.translate('ConfirmPassword'),
              hint: settings.selectedLocale!.translate('Password'),
              validator: (value) {
                if (_editingControllers[1].text !=
                    _editingControllers[2].text) {
                  return settings.selectedLocale!.translate(
                    'PasswordNotMatch',
                  );
                }
                return Rule(
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
                ).error;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: visibilities['confirm']!,
              textInputAction: TextInputAction.done,
              suffixIcon: eye('confirm'),
            ),
            const Gap(18.0),
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
                  settings.selectedLocale!.translate(
                    'Submit',
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget eye(String key) {
    return GestureDetector(
      onTap: () => setState(() {
        visibilities[key] = !(visibilities[key]!);
      }),
      behavior: HitTestBehavior.opaque,
      child: Icon(
        visibilities[key]! ? Iconsax.eye : Iconsax.eye_slash,
        size: 18,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      submitting = true;
    });

    try {
      await ref.read(editProfileProvider).changePassword(
        _editingControllers[2].text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: AppException(e).toString(),
      );
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    setState(() {
      submitting = false;
    });
  }
}
