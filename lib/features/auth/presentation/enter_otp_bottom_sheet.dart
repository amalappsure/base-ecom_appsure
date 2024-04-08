import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/foundation/string_exts.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

class EnterOTPBottoSheet extends ConsumerStatefulWidget {
  const EnterOTPBottoSheet({
    super.key,
  });

  @override
  ConsumerState<EnterOTPBottoSheet> createState() => _EnterOTPBottoSheetState();
}

class _EnterOTPBottoSheetState extends ConsumerState<EnterOTPBottoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool validated = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => FocusScope.of(context).requestFocus(_focusNode),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return PopScope(
      canPop: validated,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0).copyWith(
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    settings.selectedLocale!.translate('Verify mobile number'),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _close();
                    },
                    icon: const Icon(Icons.close_rounded),
                  )
                ],
              ),
              const Gap(12.0),
              Text(
                settings.selectedLocale!.translate(
                  'AtextWithOneTimePasswordMobileNumber',
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Gap(12.0),
              TextFieldWithTitleBase.widget(
                controller: _controller,
                focusNode: _focusNode,
                label: settings.selectedLocale!.translate('EnterOTP'),
                hint: settings.selectedLocale!.translate('EnterOTP'),
                validator: (value) => Rule(
                  value,
                  name: settings.selectedLocale!.translate('EnterOTP'),
                  isRequired: true,
                  isNumeric: true,
                  minLength: 6,
                  maxLength: 6,
                ).error,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              const Gap(18.0),
              // if (_submitting)
              //   const SizedBox.square(
              //     dimension: 48.0,
              //     child: Center(
              //       child: CircularProgressIndicator.adaptive(),
              //     ),
              //   )
              // else
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  settings.selectedLocale!.translate('CreateYourAccount'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _close();
  }

  Future<void> _close() async {
    validated = true;
    await Future.delayed(
      const Duration(milliseconds: 5),
          () => Navigator.of(context).pop(_controller.text.nullIfEmpty),
    );
  }
}
