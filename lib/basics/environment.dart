/*
 * Created by Archer on 2022/12/11.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shrinex_admin/api/models/User.dart';
import 'package:shrinex_admin/basics/globals.dart';
import 'package:shrinex_core/shrinex_core.dart';
import 'package:shrinex_io/shrinex_io.dart';

class Environment extends ChangeNotifier {
  @visibleForTesting
  static const environmentStorageKey =
      "com.anyoptional.environment.current-env";
  @visibleForTesting
  static const bearerTokenStorageKey =
      "com.anyoptional.environment.bearer-token";
  @visibleForTesting
  static const currentUserStorageKey =
      "com.anyoptional.environment.current-user";

  /// The currently logged in user.
  User? get currentUser => _currentUser;
  User? _currentUser;

  /// Restores the last saved environment from user defaults.
  Environment.fromStorage({
    required Service apiService,
    required KeyValueStore userDefaults,
  }) {
    final env = json.decode(userDefaults.getString(
          environmentStorageKey,
        ) ??
        "{}") as Map<String, dynamic>;

    // Try restoring the bearer token
    final token = env[bearerTokenStorageKey] as String?;
    if (token != null && token.isNotEmpty) {
      // Rebuild api service
      apiService = apiService.login(BearerToken(token));
      // Try restore the current user
      final potentialUser = env[currentUserStorageKey] as Map<String, dynamic>?;
      if (potentialUser != null) {
        _currentUser = User.fromJson(potentialUser);
        notifyListeners();
      }
    }

    // Init Globals
    Globals.initialize(
      apiService: apiService,
      userDefaults: userDefaults,
    );
  }

  /// Whether a user has logged in.
  bool get loggedIn => _currentUser != null;

  void update({required User currentUser}) {
    _currentUser = currentUser;
    notifyListeners();
  }

  /// Invoke when an access token has been acquired and you want to log the user in
  void login() {
    // TODO
  }

  /// Invoke when you want to end the user's session
  void logout() {
    _currentUser = null;
    _clearOut(
      userDefaults: Globals.userDefaults,
    );
    Globals.replace(
      apiService: Globals.apiService.logout(),
    );
    notifyListeners();
  }

  /// Saves some key data for the current environment
  static void _synchronize(
      {User? currentUser,
      BearerToken? bearerToken,
      required KeyValueStore userDefaults}) {
    final data = <String, dynamic>{};
    data[currentUserStorageKey] = currentUser?.toJson();
    data[bearerTokenStorageKey] = bearerToken?.rawValue;
    userDefaults.setString(environmentStorageKey, json.encode(data));
  }

  /// Clears all key data for the current environment
  static void _clearOut({required KeyValueStore userDefaults}) {
    userDefaults.remove(environmentStorageKey);
  }
}
