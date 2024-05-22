import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timer_builder/timer_builder.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

class CountDowner extends ConsumerWidget {
  const CountDowner({
    super.key,
    required this.endDate,
    this.small = false,
  });

  final DateTime endDate;
  final bool small;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        Duration duration = endDate.difference(
          DateTime.now(),
        );

        int days = duration.inDays;
        int hours = duration.inHours % 24;
        int minutes = (duration.inMinutes % 60);
        int seconds = (duration.inSeconds % 60);

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimeContainer(
              value: '$days'.padLeft(2, '0'),
              small: small,
            ),
            TimeContainer(
              value: '$hours'.padLeft(2, '0'),
              small: small,
            ),
            TimeContainer(
              value: '$minutes'.padLeft(2, '0'),
              small: small,
            ),
            TimeContainer(
              value: '$seconds'.padLeft(2, '0'),
              small: small,
            ),
            TimeContainer(
              value: settings.selectedLocale!.translate(
                'Days',
              ),
              small: small,
            ),
          ],
        );
      },
    );
  }
}

class TimeContainer extends StatelessWidget {
  const TimeContainer({
    super.key,
    required this.value,
    this.small = false,
  });

  final String value;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: small ? 2.0 : 3.0),
          padding: EdgeInsets.symmetric(
            vertical: small ? 0.0 : 10.0,
            horizontal: small ? 4.0 : 6.0,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(small ? 4 : 8),
          ),
          child: Text(
            value.padLeft(2, '0'),
            style: small
                ? Theme.of(context).textTheme.labelSmall
                : Theme.of(context).textTheme.titleLarge,
          ),
        )
    );
  }
}
