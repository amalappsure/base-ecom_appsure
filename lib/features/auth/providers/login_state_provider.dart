import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:base_ecom_appsure/features/auth/models/login_resp.dart';

@immutable
class LoginState {
  const LoginState();
}

class LoggedIn extends LoginState {
  const LoggedIn({required this.user});
  final User user;
}

class LoggedOut extends LoginState {
  const LoggedOut();
}

class LoginRequired extends LoggedOut {
  const LoginRequired(this.number);
  final int number;
}

final loginStateProvider = StateProvider<LoginState>(
      (ref) => const LoggedOut(),
);
