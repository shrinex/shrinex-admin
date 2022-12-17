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
  static const _environmentStorageKey =
      "com.anyoptional.app-environment.current";
  static const _bearerTokenStorageKey =
      "com.anyoptional.app-environment.bearer-token";
  static const _currentUserStorageKey =
      "com.anyoptional.app-environment.current-user";

  /// The currently logged in user.
  User? currentUser;

  /// Restores the last saved environment from user defaults.
  Environment.fromStorage({
    required Service apiService,
    required KeyValueStore userDefaults,
  }) {
    final env = json.decode(userDefaults.getString(
          _environmentStorageKey,
        ) ??
        "{}") as Map<String, dynamic>;

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
        notifyListeners();
      }
    }

    // Init Globals
    Globals.initialize(
      apiService: apiService,
      userDefaults: userDefaults,
    );

    // Save to disk
    _synchronize(
      currentUser: currentUser,
      userDefaults: userDefaults,
      bearerToken: apiService.bearerToken,
    );
  }

  void update({required User currentUser}) {
    this.currentUser = currentUser;
    notifyListeners();
  }

  /// Invoke when an access token has been acquired and you want to log the user in
  void login() {
    // TODO
  }

  /// Invoke when you want to end the user's session
  void logout() {
    currentUser = null;
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
    data[_currentUserStorageKey] = currentUser?.toJson();
    data[_bearerTokenStorageKey] = bearerToken?.rawValue;
    userDefaults.setString(_environmentStorageKey, json.encode(data));
  }

  /// Clears all key data for the current environment
  static void _clearOut({required KeyValueStore userDefaults}) {
    userDefaults.remove(_environmentStorageKey);
  }
}
