import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'text_field.dart';

abstract class TextFieldWithTitleBase extends StatelessWidget {
  const TextFieldWithTitleBase({
    super.key,
    this.label,
    this.bottomHint,
    this.hint,
    this.textInputAction,
    this.keyboardType,
    this.controller,
    this.inputFormatters,
    this.enabled,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.obscuringCharacter = '•',
    this.textCapitalization = TextCapitalization.none,
    this.prefixIcon,
    this.contentPadding,
    this.readOnly = false,
    this.initialValue,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.fillColor,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.suffixIcon,
    this.isRequired = false,
    this.focusNode,
    this.counter,
  });

  const factory TextFieldWithTitleBase.widget({
    String? label,
    String? bottomHint,
    String? hint,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    bool obscureText,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String obscuringCharacter,
    TextCapitalization textCapitalization,
    Widget? prefixIcon,
    EdgeInsets? contentPadding,
    bool readOnly,
    String? initialValue,
    VoidCallback? onTap,
    TextAlign textAlign,
    Color? fillColor,
    int? minLines,
    int? maxLines,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    Widget? suffixIcon,
    bool isRequired,
    FocusNode? focusNode,
    Widget? counter,
  }) = _TextFieldWithTitle;

  final String? label;
  final String? bottomHint;
  final String? hint;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String obscuringCharacter;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon;
  final EdgeInsets? contentPadding;
  final bool readOnly;
  final String? initialValue;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final Color? fillColor;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Widget? suffixIcon;
  final bool isRequired;
  final FocusNode? focusNode;
  final Widget? counter;

  TextStyle? labelStyle(BuildContext context);
  TextStyle? bottomHintStyle(BuildContext context);
  CustomTextFieldBase textFieldBuilder();
}

class _TextFieldWithTitle extends TextFieldWithTitleBase {
  const _TextFieldWithTitle({
    super.label,
    super.hint,
    super.textInputAction,
    super.keyboardType,
    super.controller,
    super.inputFormatters,
    super.enabled,
    super.obscureText,
    super.onChanged,
    super.validator,
    super.obscuringCharacter,
    super.bottomHint,
    super.textCapitalization,
    super.prefixIcon,
    super.contentPadding,
    super.readOnly,
    super.initialValue,
    super.onTap,
    super.textAlign,
    super.fillColor,
    super.minLines,
    super.maxLines,
    super.maxLength,
    super.maxLengthEnforcement,
    super.suffixIcon,
    super.isRequired,
    super.focusNode,
    super.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: label!, style: labelStyle(context)),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: labelStyle(
                      context,
                      color: Colors.red.shade600,
                    ),
                  )
              ],
            ),
          ),
          const Gap(4)
        ],
        textFieldBuilder(),
        if (bottomHint != null) ...[
          const Gap(6),
          Text(
            bottomHint!,
            style: bottomHintStyle(context),
          )
        ],
      ],
    );
  }

  @override
  TextStyle? bottomHintStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF898D90),
      );

  @override
  TextStyle? labelStyle(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: color ?? Theme.of(context).colorScheme.onPrimary,
      );

  @override
  CustomTextFieldBase textFieldBuilder() => CustomTextFieldBase.widget(
    minLines: minLines,
    maxLines: maxLines,
    maxLength: maxLength,
    maxLengthEnforcement: maxLengthEnforcement,
    textInputAction: textInputAction,
    keyboardType: keyboardType,
    controller: controller,
    inputFormatters: inputFormatters,
    enabled: enabled,
    obscureText: obscureText,
    obscuringCharacter: obscuringCharacter,
    onChanged: onChanged,
    validator: validator,
    textCapitalization: textCapitalization,
    readOnly: readOnly,
    initialValue: initialValue,
    onTap: onTap,
    textAlign: textAlign,
    contentPadding: contentPadding,
    hint: hint ?? label,
    prefixIcon: prefixIcon,
    fillColor: fillColor,
    suffixIcon: suffixIcon,
    focusNode: focusNode,
    counter: counter,
  );
}
