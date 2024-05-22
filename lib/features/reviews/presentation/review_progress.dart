import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviewProgress extends StatelessWidget {
  const ReviewProgress({
    super.key,
    required this.rating,
    required this.count,
    this.width = 0.0,
  });

  final String rating;
  final int count;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: rating,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 0.8),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 1),
                ),
                const WidgetSpan(
                  child: Icon(Icons.star, size: 15),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 6),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            alignment: Alignment.centerLeft,
            height: 8.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
              border: Border.all(
                width: 0.5,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: FractionallySizedBox(
              widthFactor: width,
              child: Container(
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          const Gap(4),
          Text(
            count.toString(),
            style:
            Theme.of(context).textTheme.bodyMedium?.copyWith(height: 0.8),
          )
        ],
      ),
    );
  }

  Color get _color {
    switch (rating) {
      case '1':
        return const Color(0xFFE53935);
      case '2':
        return const Color(0xFFFFA500);
      case '3':
        return const Color(0xFFFFA500);
      case '4':
        return const Color(0xFF008000);
      case '5':
        return const Color(0xFF008000);
      default:
        return Colors.grey;
    }
  }
}
