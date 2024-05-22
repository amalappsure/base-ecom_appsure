import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/cart/providers/cart_provider.dart';
import 'package:base_ecom_appsure/widgets/default_card.dart';
import 'package:base_ecom_appsure/widgets/text_field.dart';

class PromoCodeCard extends ConsumerStatefulWidget {
  const PromoCodeCard({
    super.key,
    required this.controller,
    required this.applyPromoCode,
  });

  final TextEditingController controller;
  final ValueChanged<String> applyPromoCode;

  @override
  ConsumerState<PromoCodeCard> createState() => _PromoCodeCardState();
}

class _PromoCodeCardState extends ConsumerState<PromoCodeCard> {
  bool _validating = false;
  bool? _invalidCode;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final cart = ref.watch(cartProvider);
    return DefaultCard(
      margin: EdgeInsets.zero,
      border: Border.all(
        color: Theme.of(context).dividerColor.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: CustomTextFieldBase.widget(
                    controller: widget.controller,
                    hint: settings.selectedLocale!.translate(
                      'EnterPromoCode',
                    ),
                    onFieldSubmitted: (value) => widget.applyPromoCode(
                      value,
                    ),
                    onChanged: (value) {
                      _invalidCode = null;
                      _formKey.currentState?.validate();
                    },
                    maxLines: 1,
                    validator: (value) {
                      if (_invalidCode == true) {
                        return settings.selectedLocale!.translate(
                          'PromoCodeValidationMsg',
                        );
                      }
                      if ((value ?? '').isEmpty) {
                        return settings.selectedLocale!.translate(
                          'PleaseEnterTheCode',
                        );
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const Gap(8),
                Expanded(
                  flex: 3,
                  child: _validating
                      ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                      : ElevatedButton(
                    onPressed: () => _validatePromoCode(
                      widget.controller.text,
                    ),
                    child: Text(
                      settings.selectedLocale!.translate('Apply'),
                    ),
                  ),
                ),
              ],
            ),
            if (cart.promoCode != null) ...[
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.check_circle,
                              color: Color(0xFF00AD61),
                              size: 16,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4)),
                          TextSpan(
                            text: settings.selectedLocale!.translate(
                              'CouponAppliedSuccessfully',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: const Color(0xFF00AD61)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                  TextButton(
                    onPressed: () => cart.clearPromoCode(),
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      settings.selectedLocale!.translate('Remove'),
                    ),
                  )
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _validatePromoCode(String code) async {
    if (code.isEmpty) return;
    setState(() {
      _validating = true;
    });

    _invalidCode = null;
    _formKey.currentState?.validate();

    try {
      final response = await ref.read(cartProvider.notifier).validatePromoCode(
        code,
      );
      if (!response) {
        _invalidCode = true;
        _formKey.currentState?.validate();
      }
    } catch (e) {
      _invalidCode = true;
      _formKey.currentState?.validate();
    } finally {
      setState(() {
        _validating = false;
      });
    }
  }
}
