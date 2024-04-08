import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AccountTabButton extends StatelessWidget {
  const AccountTabButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.textColor,
    required this.iconColor,
    this.showArrow = true,
    this.icon,
    this.iconWidget,
    this.arrowWidget,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color iconColor;
  final bool showArrow;
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null || iconWidget != null) ...[
                if (icon != null)
                  Icon(
                    icon!,
                    color: iconColor,
                  ),
                if (iconWidget != null) iconWidget!,
                const Gap(16),
              ],
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
          if (showArrow)
            arrowWidget ??
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 12.0,
                  color: Colors.black,
                ),
        ],
      ),
    );
  }
}
