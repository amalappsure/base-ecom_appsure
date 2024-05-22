import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/edit_profile/providers/edit_profile_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

class EditNameBS extends ConsumerStatefulWidget {
  const EditNameBS({super.key});

  @override
  ConsumerState<EditNameBS> createState() => _EditNameBSState();
}

class _EditNameBSState extends ConsumerState<EditNameBS> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _editingController;

  bool submitting = false;

  @override
  void initState() {
    _editingController = TextEditingController()
      ..text = HiveRepo.instance.user?.name ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(settingsProvider);
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
              settings.selectedLocale!.translate(
                'ChangeYourName',
              ),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(18.0),
            TextFieldWithTitleBase.widget(
              controller: _editingController,
              label: settings.selectedLocale!.translate(
                'NewName',
              ),
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate(
                  'NewName',
                ),
                isRequired: true,
                isAlphaSpace: true,
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
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      submitting = true;
    });

    try {
      await ref.read(editProfileProvider).updateName(
        _editingController.text,
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: AppException(e).toString(),
      );
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    setState(() {
      submitting = false;
    });
  }
}
