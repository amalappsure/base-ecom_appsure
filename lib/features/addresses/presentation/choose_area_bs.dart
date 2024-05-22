import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/addresses/providers/address_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/models/misc_values.dart';
import 'package:base_ecom_appsure/widgets/custom_drop_down.dart';

class ChooseAreaBS extends ConsumerStatefulWidget {
  const ChooseAreaBS({super.key});

  @override
  ConsumerState<ChooseAreaBS> createState() => _AreaBSState();
}

class _AreaBSState extends ConsumerState<ChooseAreaBS> {
  MiscValue? area;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => ref.read(addressProvider).getAreas(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              settings.selectedLocale!.translate('PleaseSelectArea'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(18),
            ref.watch(areasProvider).when(
              onLoading: () => const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 48.0,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  Gap(18),
                ],
              ),
              onSuccess: (data) {
                return Column(
                  children: [
                    DropdownWithTitle(
                      items: data,
                      label: settings.selectedLocale!.translate(
                        'Area',
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            area = value;
                          });
                        }
                      },
                      value: area,
                      validator: (value) {
                        return Rule(
                          value?.toString(),
                          name: settings.selectedLocale!.translate('Area'),
                          isRequired: true,
                        ).error;
                      },
                    ),
                    const Gap(18),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(settingsProvider).area = area;
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        settings.selectedLocale!.translate('Submit'),
                      ),
                    ),
                  ],
                );
              },
              onError: (error) => const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}
