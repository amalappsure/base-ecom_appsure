part of 'reset_password_view.dart';

class VerifyPhoneView extends ConsumerStatefulWidget {
  const VerifyPhoneView({super.key});

  @override
  ConsumerState<VerifyPhoneView> createState() => _VerifyPhoneBSState();
}

class _VerifyPhoneBSState extends ConsumerState<VerifyPhoneView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _editingController;

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
    final submitting = ref.watch(resetPasswordProvider) is VerifyingOTP;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate('VerifyMobileNumber'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            Text(
              settings.selectedLocale!.translate(
                'AtextWithOneTimePasswordMobileNumber',
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              focusNode: _focusNode,
              label: settings.selectedLocale!.translate('EnterOTP'),
              controller: _editingController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('EnterOTP'),
                isRequired: true,
                isNumeric: true,
                maxLength: 6,
                minLength: 6,
              ).error,
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

    ref.read(resetPasswordProvider.notifier).verifyOTP(
      _editingController.text,
    );
  }
}
