import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/company_info/models/company_info.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';

final companyInfoProvider = StateNotifierProvider.autoDispose<
    CompanyInfoProvider, RemoteData<CompanyInfo>>(
      (ref) => CompanyInfoProvider(ref),
);

class CompanyInfoProvider extends StateNotifier<RemoteData<CompanyInfo>> {
  CompanyInfoProvider(this.ref)
      : client = ref.read(restClientProvider),
        super(RemoteData());

  final Ref ref;
  final RestClient client;

  Future<dynamic> getInfo(InfoType infoType) async {
    if (!state.isLoading) {
      state = RemoteData();
    }
    try {
      final response = await client.getContentByID({
        "ID": infoType.id,
        "Language": ref.read(settingsProvider).selectedLocale!.name,
      });
      state = RemoteData(data: response.info);
    } catch (e) {
      state = RemoteData(error: AppException(e));
    }
  }
}
