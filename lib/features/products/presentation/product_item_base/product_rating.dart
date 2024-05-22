import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ProductRating extends ConsumerWidget {
  const ProductRating({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled =
        ref.read(settingsProvider).appConfig.enableRatingsAndReviews;
    if (!enabled || rating <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Gap(2),
          const Icon(
            Icons.star,
            size: 12,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Color get _color {
    if (rating >= 4) return const Color(0xFF008000);
    if (rating >= 2) return const Color(0xFFFFA500);
    return const Color(0xFFE53935);
  }
}
