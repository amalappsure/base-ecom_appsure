import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/foundation/hive_repo.dart';
import 'package:base_ecom_appsure/features/addresses/models/address.dart';
import 'package:base_ecom_appsure/features/addresses/models/address_type.dart';
import 'package:base_ecom_appsure/models/app_exception.dart';
import 'package:base_ecom_appsure/models/misc_values.dart';
import 'package:base_ecom_appsure/models/remote_data.dart';
import 'package:base_ecom_appsure/rest/rest_client_provider.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';

final addressProvider = StateProvider.autoDispose<AddressProvider>(
      (ref) => AddressProvider(ref),
);

final areasProvider = StateProvider.autoDispose<RemoteData<List<MiscValue>>>(
      (ref) => RemoteData(),
);

final addressesProvider = StateProvider.autoDispose<RemoteData<List<Address>>>(
      (ref) => RemoteData(),
);

final addressTypes = [
  AddressType(
    id: 1,
    name: 'Home',
  ),
  AddressType(
    id: 4,
    name: 'Office',
  ),
];

class AddressProvider {
  AddressProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
    _ref.listen(settingsProvider, (previous, next) {
      getAreas();
    });
  }

  final Ref _ref;
  final RestClient _restClient;

  String get _language => _ref.read(settingsProvider).selectedLocale!.name;

  Future<void> getAreas() async {
    final map = <String, dynamic>{};
    final notifier = _ref.read(areasProvider.notifier);

    map.putIfAbsent("Username", () => HiveRepo.instance.userName);
    map.putIfAbsent("Language", () => _language);
    map.putIfAbsent("String1", () => "Area");

    try {
      final response = await _restClient.getMiscMasterValuesList(map);
      notifier.state = RemoteData(data: response.result);
    } catch (e) {
      notifier.state = RemoteData(error: AppException(e));
    }
  }

  Future<void> createAdress({
    int? id,
    required String fullName,
    required String phone,
    String? email,
    required int addressTypeID,
    required int areaId,
    String? block,
    String? jadah,
    String? street,
    required String address1, // building name / building no
    String? floor,
    String? houseNo, // Flat
    String? landmark,
    String? residenceAddress, // Remarks
    bool isDefault = false,
  }) async {
    final map = <String, dynamic>{};

    if (id != null) {
      map.putIfAbsent('ID', () => id);
    }

    map.putIfAbsent('CustomerID', () => HiveRepo.instance.user!.id);
    map.putIfAbsent('FullName', () => fullName);
    map.putIfAbsent('Phone', () => phone);

    if (email != null && email.isNotEmpty) {
      map.putIfAbsent('Email', () => email);
    }

    map.putIfAbsent('AddressTypeID', () => addressTypeID);
    map.putIfAbsent('AreaID', () => areaId);

    if (block != null && block.isNotEmpty) {
      map.putIfAbsent('Block', () => block);
    }

    if (jadah != null && jadah.isNotEmpty) {
      map.putIfAbsent('Jadah', () => jadah);
    }

    if (street != null && street.isNotEmpty) {
      map.putIfAbsent('Street', () => street);
    }

    map.putIfAbsent('Address1', () => address1);

    if (floor != null && floor.isNotEmpty) {
      map.putIfAbsent('Floor', () => floor);
    }

    if (houseNo != null && houseNo.isNotEmpty) {
      map.putIfAbsent('HouseNo', () => houseNo);
    }

    if (landmark != null && landmark.isNotEmpty) {
      map.putIfAbsent('Landmark', () => landmark);
    }

    if (residenceAddress != null && residenceAddress.isNotEmpty) {
      map.putIfAbsent('ResidenceAddress', () => residenceAddress);
    }

    map.putIfAbsent('DefaultAddress', () => isDefault);

    try {
      final response = await _restClient.putUserAddress({
        'TypeObject1': map,
      });

      if (isDefault && response['result'] is int) {
        makeDefault(response['result'] as int);
      }
    } catch (e) {
      //
    }
    getAddressList();
  }

  Future<void> getAddressList() async {
    final map = {
      "TypeObject2": HiveRepo.instance.user?.id,
      "Language": _language,
    };

    final notifier = _ref.read(addressesProvider.notifier);

    if (!notifier.state.isLoading) {
      notifier.state = RemoteData();
    }

    try {
      final response = await _restClient.getAddressList(map);
      notifier.state = RemoteData(data: response.addresses);
    } catch (e) {
      notifier.state = RemoteData(error: AppException(e));
    }
  }

  Future<void> deleteAddress(int id) async {
    final map = {
      "TypeObject1": id,
      "Username": HiveRepo.instance.user?.username,
    };

    try {
      await _restClient.deleteUserAddress(map);
    } catch (e) {
      //
    }

    getAddressList();
  }

  Future<void> makeDefault(int id) async {
    try {
      await _restClient.setDefaultAddress({
        "TypeObject1": {
          "CustomerID": HiveRepo.instance.user!.id,
          "ID": id,
        },
      });
    } catch (e) {
      //
    }

    getAddressList();
  }
}
