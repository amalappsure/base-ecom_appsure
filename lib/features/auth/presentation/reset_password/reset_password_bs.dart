part of 'reset_password_view.dart';

class EnterPhoneView extends ConsumerStatefulWidget {
  const EnterPhoneView({super.key});

  @override
  ConsumerState<EnterPhoneView> createState() => _ResetPasswordBSState();
}

class _ResetPasswordBSState extends ConsumerState<EnterPhoneView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _editingController;
  CountryCode countryCode = countryCodes.first;
  String mobile = '';

  final _focusNode = FocusNode();

  @override
  void initState() {
    _editingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => FocusScope.of(context).requestFocus(_focusNode),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final submitting = ref.watch(resetPasswordProvider) is RequestingOTP;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate('ForgotPassword'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            Text(
              settings.selectedLocale!.translate(
                'OtpRegistrationMobile',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(18),
            PhoneFieldWithTitle(
              focusNode: _focusNode,
              isRequired: true,
              label: settings.selectedLocale!.translate(
                'GuestMobileNumber',
              ),
              initialValue: countryCode,
              hint: settings.selectedLocale!.translate('GuestMobileNumber'),
              editingController: _editingController,
              onChanged: (value) {},
              onNumberChanged: (value) => mobile = value,
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
    ref.read(resetPasswordProvider.notifier).requestOTP(mobile);
  }
}
