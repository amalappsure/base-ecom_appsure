import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddOrRemoveButton extends StatelessWidget {
  const AddOrRemoveButton({
    super.key,
    this.onRemoveClicked,
    this.onAddClicked,
    required this.count,
  });

  final VoidCallback? onRemoveClicked;
  final VoidCallback? onAddClicked;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AddOrRemoveButtons(
            onPressed: onRemoveClicked,
            icon: Iconsax.minus,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Text(
              count,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black),
            ),
          ),
          _AddOrRemoveButtons(
            onPressed: onAddClicked,
            icon: Iconsax.add,
          ),
        ],
      ),
    );
  }
}

class _AddOrRemoveButtons extends StatelessWidget {
  const _AddOrRemoveButtons({
    required this.icon,
    this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: SizedBox.square(
        dimension: 32.0,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            // shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
          child: Icon(
            icon,
            size: 18.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
