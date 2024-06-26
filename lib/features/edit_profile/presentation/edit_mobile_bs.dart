import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rules/rules.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/edit_profile/providers/edit_profile_provider.dart';
import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/foundation/show_snack_bar.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/widgets/text_field_with_title.dart';

import '../../auth/providers/auth_provider.dart';
import 'otp_varify_editPhone.dart';

class EditMobileBS extends ConsumerStatefulWidget {
  const EditMobileBS({super.key});

  @override
  ConsumerState<EditMobileBS> createState() => _EditMobileBSState();
}

class _EditMobileBSState extends ConsumerState<EditMobileBS> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _editingControllers;

  String alreadyExistContent = '';
  bool submitting = false;
  bool userExist = true;

  @override
  void initState() {
    _editingControllers = List.generate(2, (index) {
      if (index == 0) {
        return TextEditingController()
          ..text = HiveRepo.instance.user?.mobile ?? '';
      }
      return TextEditingController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(settingsProvider);
    alreadyExistContent = settings.selectedLocale!.translate('AlreadyExists',);
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
                'ChangeMobileNumber',
              ),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(18.0),
            TextFieldWithTitleBase.widget(
              label: settings.selectedLocale!.translate(
                'OldMobileNumber',
              ),
              hint: settings.selectedLocale!
                  .translate('MobileNumber')
                  .replaceAll(' *', ''),
              controller: _editingControllers[0],
              maxLines: 1,
              readOnly: HiveRepo.instance.user?.username != null,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 8,
              counter: const SizedBox.shrink(),
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!
                    .translate('MobileNumber')
                    .replaceAll(' *', ''),
                isRequired: true,
                maxLength: 8,
                customErrors: {
                  'isRequired': settings.selectedLocale!.translate(
                    'EnterYourMobileNumber',
                  ),
                  'minLength': settings.selectedLocale!.translate(
                    'MobileNumberMin8Digits',
                  ),
                },
              ).error,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              label: settings.selectedLocale!.translate(
                'NewMobileNumber',
              ),
              hint: settings.selectedLocale!
                  .translate('MobileNumber')
                  .replaceAll(' *', ''),
              controller: _editingControllers[1],
              maxLines: 1,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 8,
              counter: const SizedBox.shrink(),
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!
                    .translate('MobileNumber')
                    .replaceAll(' *', ''),
                isRequired: true,
                maxLength: 8,
                customErrors: {
                  'isRequired': settings.selectedLocale!.translate(
                    'EnterYourMobileNumber',
                  ),
                  'minLength': settings.selectedLocale!.translate(
                    'MobileNumberMin8Digits',
                  ),
                },
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
                onPressed: (){
                  _submit(context,_editingControllers[0].text, _editingControllers[1].text);
                },
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

  Future<T?> _showModalBottomSheet<T>(
      BuildContext context,
      Widget widget,
      ) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => widget,
    );
  }

  Future<void> _submit(BuildContext context, String mobilePrimary,  String mobileNew) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      submitting = true;
    });

    try {
      userExist = await ref.read(editProfileProvider).userMobileExists(
        _editingControllers[1].text,
      );
      if(userExist){
        setState(() {
          submitting = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alreadyExistContent)
          )
        );
      }else{
        final otpRef = await ref.read(authProvider).generateOTP(
          mobile: mobilePrimary,
          otpType: OTPType.forgotPassword,
        );
        if(otpRef is String){
          Navigator.pop(context);
          _showModalBottomSheet(
            context,
            OTPVerifyPhoneView(otpKey: otpRef,mobilePrimary: mobilePrimary, mobileNew: mobileNew,),
          );
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: AppException(e).toString(),
      );
    }
    // ignore: use_build_context_synchronously
    setState(() {
      submitting = false;
    });
  }
}
