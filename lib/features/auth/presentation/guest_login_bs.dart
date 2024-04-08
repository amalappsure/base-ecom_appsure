part of 'login.dart';

class GuestLoginBS extends ConsumerStatefulWidget {
  const GuestLoginBS({super.key});

  @override
  ConsumerState<GuestLoginBS> createState() => _GuestLoginBSState();
}

class _GuestLoginBSState extends ConsumerState<GuestLoginBS> {
  final _formKey = GlobalKey<FormState>();

  late List<TextEditingController> _editingControllers;
  CountryCode countryCode = countryCodes.first;
  bool submitting = false;

  String mobile = '';
  String confirm = '';

  @override
  void initState() {
    _editingControllers = List.generate(
      3,
          (index) => TextEditingController(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: 16.0 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              settings.selectedLocale!.translate('GuestLogin'),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(24),
            PhoneFieldWithTitle(
              isRequired: true,
              label: settings.selectedLocale!.translate(
                'GuestMobileNumber',
              ),
              initialValue: countryCode,
              hint: settings.selectedLocale!.translate('EnterMobileNumber'),
              editingController: _editingControllers[0],
              onChanged: (value) {},
              onNumberChanged: (value) => mobile = value,
            ),
            const Gap(18),
            PhoneFieldWithTitle(
              label: settings.selectedLocale!.translate(
                'ConfirmMobileNumber',
              ),
              isRequired: true,
              initialValue: countryCode,
              hint: settings.selectedLocale!.translate('EnterMobileNumber'),
              editingController: _editingControllers[1],
              onChanged: (value) {},
              validator: (value) {
                if (mobile != confirm) {
                  return settings.selectedLocale!.translate(
                    'ConfirmYourMobileNumber',
                  );
                }
                return null;
              },
              onNumberChanged: (value) => confirm = value,
            ),
            const Gap(18),
            TextFieldWithTitleBase.widget(
              controller: _editingControllers[2],
              hint: settings.selectedLocale!.translate('EnterEmailId'),
              label: settings.selectedLocale!.translate('EmailId'),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Rule(
                value,
                name: settings.selectedLocale!.translate('EmailId'),
                isEmail: true,
              ).error,
            ),
            const Gap(24),
            if (submitting)
              SizedBox.square(
                dimension: 48.0,
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  settings.selectedLocale!.translate('Login'),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      submitting = true;
    });

    try {
      await ref.read(authProvider).registerGuestUser(
        mobile: _editingControllers[0].text,
        name: _editingControllers[2].text,
        email: _editingControllers[2].text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on AppException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(
        context,
        isError: true,
        message: e.toString(),
      );
    }
    setState(() {
      submitting = false;
    });
  }
}
