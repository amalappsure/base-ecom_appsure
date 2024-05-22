import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.all(12),
    this.isExpanded = false,
    this.hintStyle,
  });

  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String? hint;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final EdgeInsets contentPadding;
  final bool isExpanded;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items
          .map((e) => DropdownMenuItem<T>(
        value: e,
        child: Text(e.toString()),
      ))
          .toList(),
      onChanged: onChanged,
      value: value,
      validator: validator,
      isExpanded: isExpanded,
      hint: Text(
        hint ?? '',
        style: hintStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF898D90),
            ),
      ),
      decoration: InputDecoration(
        enabled: enabled,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF898D90),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF898D90),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 191, 192, 194),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFFdC3545),
          ),
        ),
        contentPadding: contentPadding,
      ),
    );
  }
}

class DropdownWithTitle<T> extends StatelessWidget {
  const DropdownWithTitle({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.enabled = true,
    this.isRequired = false,
  });

  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  final String label;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  final bool isRequired;

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
        CustomDropdownButton(
          items: items,
          onChanged: onChanged,
          value: value,
          hint: label,
          validator: validator,
          enabled: enabled,
        ),
      ],
    );
  }
}
