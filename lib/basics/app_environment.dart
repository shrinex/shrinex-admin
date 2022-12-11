/*
 * Created by Archer on 2022/12/11.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shrinex_admin/api/models/User.dart';
import 'package:shrinex_admin/basics/environment.dart';
import 'package:shrinex_core/shrinex_core.dart';
import 'package:shrinex_io/shrinex_io.dart';

///  A global stack that captures the current state of
///  global objects that the app wants access to.
class AppEnvironment extends ChangeNotifier {
  static const _environmentStorageKey =
      "com.anyoptional.app-environment.current";
  static const _bearerTokenStorageKey =
      "com.anyoptional.app-environment.bearer-token";
  static const _currentUserStorageKey =
      "com.anyoptional.app-environment.current-user";

  /// A global stack of environments.
  final _stack = <Environment>[];

  /// The most recent environment on the stack.
  Environment get current => _stack.last;

  /// Restores the last saved environment from user defaults.
  AppEnvironment.fromStorage({
    required Service apiService,
    required KeyValueStore userDefaults,
  }) {
    final env = json.decode(userDefaults.getString(
          _environmentStorageKey,
        ) ??
        "{}") as Map<String, dynamic>;

    User? currentUser;

    // Try restoring the bearer token
    final token = env[_bearerTokenStorageKey] as String?;
    if (token != null && token.isNotEmpty) {
      // Rebuild api service
      apiService = apiService.login(BearerToken(token));
      // Try restore the current user
      final potentialUser =
          env[_currentUserStorageKey] as Map<String, dynamic>?;
      if (potentialUser != null) {
        currentUser = User.fromJson(potentialUser);
      }
    }
    _pushEnvironment(
      Environment(
        apiService: apiService,
        currentUser: currentUser,
        userDefaults: userDefaults,
      ),
    );
  }

  /// Pushes a new environment onto the stack that changes only a subset of the current global dependencies.
  void pushEnvironment({
    User? currentUser,
    Service? apiService,
    double? debounceInterval,
    KeyValueStore? userDefaults,
  }) {
    final serviceToUse = apiService ?? current.apiService;
    final currentUserToUse = currentUser ?? current.currentUser;
    final userDefaultsToUse = userDefaults ?? current.userDefaults;
    final debounceIntervalToUse = debounceInterval ?? current.debounceInterval;
    _pushEnvironment(
      Environment(
        apiService: serviceToUse,
        currentUser: currentUserToUse,
        userDefaults: userDefaultsToUse,
        debounceInterval: debounceIntervalToUse,
      ),
    );
  }

  /// Pop an environment off the stack.
  Environment? popEnvironment() {
    if (_stack.isEmpty) {
      return null;
    }
    final last = _stack.removeLast();
    _clearEnvironment(last, last.userDefaults);
    notifyListeners();
    return last;
  }

  /// Replace the current environment with a new environment.
  void replaceCurrentEnvironment(Environment env) {
    _pushEnvironment(env);
    _stack.removeAt(_stack.length - 2);
    notifyListeners();
  }

  /// Push a new environment onto the stack.
  void _pushEnvironment(Environment env) {
    _saveEnvironment(env, env.userDefaults);
    _stack.add(env);
    notifyListeners();
  }

  /// Saves some key data for the current environment
  static void _saveEnvironment(Environment env, KeyValueStore userDefaults) {
    final data = <String, dynamic>{};
    data[_currentUserStorageKey] = env.currentUser?.toJson();
    data[_bearerTokenStorageKey] = env.apiService.bearerToken?.rawValue;
    userDefaults.setString(_environmentStorageKey, json.encode(data));
  }

  /// Clears all key data for the current environment
  static void _clearEnvironment(Environment env, KeyValueStore userDefaults) {
    userDefaults.remove(_environmentStorageKey);
  }
}
