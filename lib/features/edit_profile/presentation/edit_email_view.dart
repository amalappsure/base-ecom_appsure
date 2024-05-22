import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/edit_profile/providers/edit_profile_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class EditEmailView extends ConsumerStatefulWidget {
  const EditEmailView({super.key});

  @override
  ConsumerState<EditEmailView> createState() => _EditEmailViewState();
}

class _EditEmailViewState extends ConsumerState<EditEmailView> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _editingControllers;

  bool submitting = false;

  @override
  void initState() {
    _editingControllers = List.generate(4, (index) {
      switch (index) {
        case 0:
          return TextEditingController()
            ..text = HiveRepo.instance.user?.email ?? '';
        default:
          return TextEditingController();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[0],
              label: settings.selectedLocale!.translate('OldEmail'),
              hint: settings.selectedLocale!.translate('Email'),
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('Email'),
                isRequired: true,
                isEmail: true,
              ).error,
              readOnly: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[1],
              label: settings.selectedLocale!.translate('NewEmail'),
              hint: settings.selectedLocale!.translate('Email'),
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('Email'),
                isRequired: true,
                isEmail: true,
                customErrors: {
                  'isRequired': settings.selectedLocale!.translate(
                    'EnterEmail',
                  ),
                  'isEmail': settings.selectedLocale!.translate(
                    'EnterValidEmail',
                  ),
                },
              ).error,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[2],
              label: settings.selectedLocale!.translate('ReEnterNewEmail'),
              hint: settings.selectedLocale!.translate('Email'),
              validator: (value) {
                if (_editingControllers[1].text !=
                    _editingControllers[2].text) {
                  return settings.selectedLocale!.translate('EmailNotMatch');
                }
                return Rule(
                  value,
                  name: settings.selectedLocale!.translate('Email'),
                  isRequired: true,
                  isEmail: true,
                  customErrors: {
                    'isRequired': settings.selectedLocale!.translate(
                      'ReEnterNewEmail\r\n',
                    ),
                    'isEmail': settings.selectedLocale!.translate(
                      'EnterValidEmail',
                    ),
                  },
                ).error;
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[3],
              label: settings.selectedLocale!.translate('Password'),
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('Password'),
                isRequired: true,
                minLength: 8,
                customErrors: {
                  'isRequired': settings.selectedLocale!.translate(
                    'EnterPassword',
                  ),
                  'minLength': settings.selectedLocale!.translate(
                    'PasswordMustHave6Char',
                  ),
                },
              ).error,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      submitting = true;
    });

    try {
      await ref.read(editProfileProvider).updateEmail(
        newEmail: _editingControllers[2].text,
        password: _editingControllers[3].text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: AppException(e).toString(),
      );
    }

    setState(() {
      submitting = false;
    });
  }
}
