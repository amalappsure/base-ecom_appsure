import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/products/models/payment_methods.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';

class PaymentMethodsChooser extends StatelessWidget {
  const PaymentMethodsChooser({
    super.key,
    required this.paymentMetods,
    this.onChanged,
    this.groupValue,
  });

  final List<PaymentMethod> paymentMetods;
  final PaymentMethod? groupValue;
  final ValueChanged<PaymentMethod?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: paymentMetods.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => PaymentMethodWidget(
        method: paymentMetods[index],
        onChanged: onChanged,
        groupValue: groupValue,
      ),
      separatorBuilder: (context, index) => const Gap(8),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({
    super.key,
    required this.method,
    this.onChanged,
    this.groupValue,
  });

  final PaymentMethod method;
  final PaymentMethod? groupValue;
  final ValueChanged<PaymentMethod?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(method),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: method == groupValue
              ? Border.all(
            color: Theme.of(context).colorScheme.primary,
          )
              : Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          boxShadow: const [shadow1],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (groupValue != null) ...[
              Radio.adaptive(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.comfortable,
                value: method,
                groupValue: groupValue,
                onChanged: onChanged,
              ),
              const Gap(8),
            ],
            CachedNetworkImage(
              width: 50.0.w,
              imageUrl: method.iconPath ?? '',
            ),
            const Gap(12),
            Text(
              method.description ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
