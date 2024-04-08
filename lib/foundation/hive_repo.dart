import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:base_ecom_appsure/features/auth/models/login_resp.dart';

const String _user = 'user';
const String _authToken = 'authToken';
const String _refreshToken = 'refreshToken';
const String _defaultLanguage = 'defaultLanguage';

class HiveRepo {
  static HiveRepo? _instance;
  static late Box _box;

  HiveRepo._(Box box) {
    _box = box;
  }

  static HiveRepo get instance => _instance!;

  static Future<void> initialize(String appName) async {
    Directory? directory;
    try {
      directory = await getApplicationDocumentsDirectory();
    } catch (e) {
      //
    }
    Hive.init(directory?.path);
    _instance ??= HiveRepo._(await Hive.openBox(
      'appsure-ecom-$appName',
    ));
  }

  setTokens({String? accessToken, String? refreshToken}) {
    setAccessToken(accessToken);
    setRefreshToken(refreshToken);
  }

  Future<void> setAccessToken(String? value) async =>
      _box.put(_authToken, value);

  String? getAccessToken() => _box.get(_authToken) as String?;

  Future<void> setRefreshToken(String? value) => _box.put(_refreshToken, value);

  String? getRefreshToken() => _box.get(_refreshToken) as String?;

  set user(User? user) => _box.put(_user, jsonEncode(user));

  User? get user {
    try {
      final user = User.fromJson(
        jsonDecode(_box.get(_user)),
      );
      if (user.username == null) {
        return null;
      } else {
        return user;
      }
    } catch (e) {
      return null;
    }
  }

  String get userName => user?.username ?? 'default';

  bool get isLoggedIn => user != null;

  Future<void> logout() async {
    await _box.delete(_user);
    await _box.delete(_authToken);
    await _box.delete(_refreshToken);
  }

  String? get defaultLanguage => _box.get(_defaultLanguage);

  set defaultLanguage(String? value) => _box.put(_defaultLanguage, value);

  Future<void> storeData(String key, String data) async =>
      await _box.put(key, data);

  String? readData(key) => _box.get(key) as String?;
}
