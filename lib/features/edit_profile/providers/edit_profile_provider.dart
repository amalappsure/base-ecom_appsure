import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

import '../../../rest/rest_client_provider.dart';
import '../../auth/providers/login_state_provider.dart';

final editProfileProvider = StateProvider<EditProfileProvider>(
      (ref) => EditProfileProvider(ref),
);

class EditProfileProvider {
  EditProfileProvider(this._ref) : _restClient = _ref.read(restClientProvider);
  final RestClient _restClient;
  final Ref _ref;

  String? get _language => _ref.read(settingsProvider).selectedLocale?.name;

  Future<dynamic> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    await _restClient.putEmail({
      "TypeObject2": {
        "Email": newEmail,
        "ID": HiveRepo.instance.user?.id,
        "Language": _language,
        "Password": password,
      }
    });

    HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
      email: newEmail,
    );

    _updateLocal();
  }

  Future<dynamic> updateName(String newName) async {
    await _restClient.putName({
      "TypeObject2": {
        "Name": newName,
        "ID": HiveRepo.instance.user?.id,
        "Language": _language,
      }
    });

    HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
      name: newName,
    );

    _updateLocal();
  }
  Future<bool> userMobileExists(String mobile) async {
    final response = await _restClient.ValidateMobile({
      'Language': _language,
      'Username': mobile,
    });
    return response['result'] as bool? ?? false;
  }

  Future<dynamic> updateMobile(String newMobile) async {
    await _restClient.putMobile({
      "TypeObject2": {
        "Mobile": newMobile,
        "ID": HiveRepo.instance.user?.id,
        "Language": _language,
      }
    });

    HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
      mobile: newMobile,
    );

    _updateLocal();
  }

  Future<dynamic> changePassword(String newPassword) async {
    await _restClient.putPassword({
      "TypeObject2": {
        "NewPassword": newPassword,
        "ID": HiveRepo.instance.user?.id,
        "Language": _language,
      }
    });

    HiveRepo.instance.user = HiveRepo.instance.user?.copyWith(
      password: newPassword,
    );

    _updateLocal();
  }

  void _updateLocal() {
    Future.delayed(
      const Duration(milliseconds: 500),
          () => _ref.read(loginStateProvider.notifier).state = LoggedIn(
        user: HiveRepo.instance.user!,
      ),
    );
  }
}
