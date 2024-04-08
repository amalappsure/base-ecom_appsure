part of 'reset_password_view.dart';

class NewPasswordView extends ConsumerStatefulWidget {
  const NewPasswordView({super.key});

  @override
  ConsumerState<NewPasswordView> createState() => _NewPasswordBSState();
}

class _NewPasswordBSState extends ConsumerState<NewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _editingControllers;
  CountryCode countryCode = countryCodes.first;

  final _focusNode = FocusNode();

  AppSettingsprovider get settings => ref.read(settingsProvider);

  AppConfig get _appConfig => ref.read(appConfigProvider);

  @override
  void initState() {
    _editingControllers = List.generate(
      2,
          (index) => TextEditingController(),
    );
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => FocusScope.of(context).requestFocus(_focusNode),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsProvider);
    final submitting = ref.watch(resetPasswordProvider) is ResettingPassword;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate('PasswordReset'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            TextFieldWithTitleBase.widget(
              focusNode: _focusNode,
              isRequired: true,
              label: settings.selectedLocale!.translate(
                'NewPassword',
              ),
              hint: settings.selectedLocale!.translate('NewPassword'),
              controller: _editingControllers.first,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: validator,
              textInputAction: TextInputAction.next,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              isRequired: true,
              label: settings.selectedLocale!.translate(
                'ConfirmPassword',
              ),
              hint: settings.selectedLocale!.translate('ConfirmPassword'),
              controller: _editingControllers.last,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) {
                if (value != _editingControllers.first.text) {
                  return settings.selectedLocale!.translate(
                    'PasswordNotMatch',
                  );
                }
                return validator(value);
              },
              textInputAction: TextInputAction.done,
            ),
            const Gap(18),
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
                  settings.selectedLocale!.translate('Continue'),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(resetPasswordProvider.notifier).updatePassword(
      _editingControllers.first.text,
    );
  }

  String? validator(String? value) {
    if ((value?.length ?? 0) < 6) {
      return settings.selectedLocale!.translate(
        'PasswordMustHave6Char',
      );
    }

    if (!_appConfig.enableComplexPassword) {
      return null;
    }

    if (RegExp(r'^(?=.*[a-z])$').hasMatch(value!)) {
      return settings.selectedLocale!.translate(
        'PasswordAtleastOneLowercase',
      );
    }
    if (RegExp(r'^(?=.*[A-Z])$').hasMatch(value)) {
      return settings.selectedLocale!.translate(
        'PasswordAtleastOneUppercase',
      );
    }
    if (RegExp(r'^(?=.*[!@#$%^&*])$').hasMatch(value)) {
      return settings.selectedLocale!.translate(
        'PasswordAtleastOneSpecialChar',
      );
    }

    return null;
  }
}
