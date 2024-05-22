import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class CustomTextFieldBase extends StatelessWidget {
  const CustomTextFieldBase({
    super.key,
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
    this.borderColor,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.focusNode,
    this.counter,
    this.autofocus = false,
  });

  const factory CustomTextFieldBase.widget({
    Key? key,
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
    Color? borderColor,
    int? minLines,
    int? maxLines,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    Widget? suffixIcon,
    ValueChanged<String>? onFieldSubmitted,
    FocusNode? focusNode,
    Widget? counter,
    bool autofocus,
  }) = _CustomTextField;

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
  final Color? borderColor;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final Widget? counter;
  final bool autofocus;

  Color? cursorColor(BuildContext context);
  TextStyle? style(BuildContext context);
  TextStyle? hintStyle(BuildContext context);
  InputBorder? border(BuildContext context);
  InputBorder? enabledBorder(BuildContext context);
  InputBorder? errorBorder(BuildContext context);
  InputBorder? disabledBorder(BuildContext context);
  EdgeInsetsGeometry? _contentPadding(BuildContext context);
}

class _CustomTextField extends CustomTextFieldBase {
  const _CustomTextField({
    super.key,
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
    super.textCapitalization,
    super.prefixIcon,
    super.contentPadding,
    super.readOnly,
    super.initialValue,
    super.onTap,
    super.textAlign = TextAlign.start,
    super.fillColor,
    super.borderColor,
    super.minLines,
    super.maxLines,
    super.maxLength,
    super.maxLengthEnforcement,
    super.suffixIcon,
    super.onFieldSubmitted,
    super.focusNode,
    super.counter,
    super.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: cursorColor(context),
      inputFormatters: inputFormatters,
      enabled: enabled,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      onChanged: onChanged,
      validator: validator,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      style:
      Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      initialValue: initialValue,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      onTap: onTap,
      textAlign: textAlign,
      minLines: minLines,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hint,
        fillColor: fillColor,
        filled: fillColor != null,
        hintStyle: hintStyle(context),
        border: border(context),
        enabledBorder: enabledBorder(context),
        errorBorder: errorBorder(context),
        disabledBorder: disabledBorder(context),
        contentPadding: contentPadding ?? _contentPadding(context),
        counter: counter,
      ),
    );
  }

  @override
  EdgeInsetsGeometry _contentPadding(BuildContext context) =>
      const EdgeInsets.all(8);

  @override
  InputBorder border(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: borderColor ?? const Color(0xFF898D90),
    ),
  );

  @override
  Color cursorColor(context) => Theme.of(context).colorScheme.primary;

  @override
  InputBorder disabledBorder(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 191, 192, 194),
    ),
  );

  @override
  InputBorder enabledBorder(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: borderColor ?? const Color(0xFF898D90),
    ),
  );

  @override
  InputBorder errorBorder(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Color(0xFFdC3545),
    ),
  );

  @override
  TextStyle? hintStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF898D90),
      );

  @override
  TextStyle style(BuildContext context) => throw UnimplementedError();
}
