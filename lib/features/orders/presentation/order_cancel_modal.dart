import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/orders/providers/orders_provider.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class OrderCancelModal extends ConsumerStatefulWidget {
  const OrderCancelModal({
    super.key,
    required this.voucherId,
  });

  final int voucherId;

  @override
  ConsumerState<OrderCancelModal> createState() => _OrderCancelModalState();
}

class _OrderCancelModalState extends ConsumerState<OrderCancelModal> {
  bool submitting = false;
  final _key = GlobalKey<FormState>();
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.selectedLocale!.translate('Reason'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(18.0),
            TextFieldWithTitleBase.widget(
              hint: settings.selectedLocale!.translate('Reason'),
              minLines: 3,
              textCapitalization: TextCapitalization.sentences  ,
              maxLines: 3,
              controller: _controller,
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('Reason'),
                isRequired: true,
              ).error,
            ),
            const Gap(18.0),
            if (submitting)
              const SizedBox.square(
                dimension: 48.0,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  settings.selectedLocale!.translate(
                    'Submit',
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate()) {
      return;
    }
    setState(() {
      submitting = true;
    });
    try {
      await ref.read(ordersProvider).requestCancellation(
        widget.voucherId,
        _controller.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(e);
    }
    setState(() {
      submitting = false;
    });
  }
}
