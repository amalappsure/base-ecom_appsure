import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/models/country_code.dart';

import 'text_field_with_title.dart';

class PhoneFieldWithTitle extends StatelessWidget {
  const PhoneFieldWithTitle({
    super.key,
    required this.editingController,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.hint,
    this.onNumberChanged,
    required this.label,
    this.isRequired = false,
    this.focusNode,
  });

  final TextEditingController editingController;
  final CountryCode initialValue;
  final ValueChanged<CountryCode> onChanged;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onNumberChanged;
  final String label;
  final bool isRequired;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            if (isRequired) ...[
              TextSpan(
                text: ' *',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.red.shade600,
                ),
              ),
            ],
          ]),
        ),
        const Gap(4),
        PhoneField(
          editingController: editingController,
          initialValue: initialValue,
          onChanged: onChanged,
          hint: hint,
          validator: validator,
          onNumberChanged: onNumberChanged,
          key: key,
          focusNode: focusNode,
        ),
      ],
    );
  }
}

class PhoneField extends ConsumerStatefulWidget {
  const PhoneField({
    super.key,
    required this.editingController,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.hint,
    this.onNumberChanged,
    this.focusNode,
  });

  final TextEditingController editingController;
  final CountryCode initialValue;
  final ValueChanged<CountryCode> onChanged;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onNumberChanged;
  final FocusNode? focusNode;

  @override
  ConsumerState<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends ConsumerState<PhoneField> {
  String value = '';
  late CountryCode countryCode;
  @override
  void initState() {
    countryCode = widget.initialValue;
    value = widget.editingController.text;
    super.initState();
  }

  AppSettingsprovider get settings => ref.read(settingsProvider);

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: TextFieldWithTitleBase.widget(
            enabled: false,
            controller: TextEditingController(text: "+${countryCode.code}"),
            validator: (value) {
              final error = _validator(value);
              if (error != null) return '';
              return null;
            },
            readOnly: true,
            // onTap: _showBS,
            textAlign: TextAlign.center,
            maxLength: 8,
            counter: const SizedBox.shrink(),
          ),
        ),
        const Gap(8),
        Expanded(
          flex: 8,
          child: TextFieldWithTitleBase.widget(
            focusNode: widget.focusNode,
            controller: widget.editingController,
            hint: widget.hint ??
                settings.selectedLocale!
                    .translate('MobileNumber')
                    .replaceAll(' *', ''),
            validator: _validator,
            onChanged: (value) {
              if (widget.onNumberChanged != null) {
                widget.onNumberChanged!(value);
              }
              this.value = value;
            },
            maxLength: 8,
            counter: const SizedBox.shrink(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  String? _validator(String? value) {
    final error = widget.validator?.call((value));
    if (error != null) {
      return error;
    }

    return Rule(
      this.value,
      name: settings.selectedLocale!
          .translate('MobileNumber')
          .replaceAll(' *', ''),
      isRequired: true,
      minLength: 8,
      maxLength: 10,
      customErrors: {
        'isRequired': settings.selectedLocale!.translate(
          'EnterYourMobileNumber',
        ),
        'minLength': settings.selectedLocale!.translate(
          'MobileNumberMin8Digits',
        ),
      },
    ).error;
  }

// Future<void> _showBS() async {
//   final result = await showModalBottomSheet<CountryCode>(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(12),
//         topRight: Radius.circular(12),
//       ),
//     ),
//     builder: (context) => CoutryCodeSelectorBS(selected: countryCode),
//   );

//   if (result != null) {
//     setState(() => countryCode = result);
//     widget.onChanged(countryCode);
//   }
// }
}
