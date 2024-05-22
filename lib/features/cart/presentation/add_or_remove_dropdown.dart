import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import 'package:base_ecom_appsure/widgets/custom_drop_down.dart';

class AddOrRemoveDropdown extends StatefulWidget {
  const AddOrRemoveDropdown({
    super.key,
    required this.onAdded,
    required this.maxValue,
    required this.count,
  });

  final ValueChanged<int?> onAdded;
  final int maxValue;
  final int count;

  @override
  State<AddOrRemoveDropdown> createState() => _AddOrRemoveDropdownState();
}

class _AddOrRemoveDropdownState extends State<AddOrRemoveDropdown> {
  int? value = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CustomDropdownButton<int>(
            items: List.generate(
              widget.maxValue,
                  (index) => index + 1,
            ),
            isExpanded: true,
            value: value,
            onChanged: (value) => setState(() => this.value = value),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
          ),
        ),
        const Gap(4),
        Stack(
          children: [
            IconButton(
              onPressed: () => widget.onAdded(value),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(Iconsax.shopping_cart),
            ),
            if (widget.count > 0)
              Positioned(
                top: 0.0,
                right: 4.0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.all(3.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      widget.count.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ],
        )
      ],
    );
  }
}
