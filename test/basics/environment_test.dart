/*
 * Created by Archer on 2022/12/18.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shrinex_admin/api/models/User.dart';
import 'package:shrinex_admin/basics/environment.dart';
import 'package:shrinex_admin/basics/globals.dart';
import 'package:shrinex_admin/basics/services.dart';

import '../mocks/types.mocks.dart';

void main() {
  group("Environment", () {
    test("fromStorage() init Globals", () {
      final userDefaults = MockKeyValueStore();
      final _ = Environment.fromStorage(
        apiService: Services.local,
        userDefaults: userDefaults,
      );

      when(userDefaults.getString(any)).thenReturn(null);

      expect(Globals.apiService, isNotNull);
      expect(Globals.userDefaults, isNotNull);
    });

    test("fromStorage() by default keeps clean", () {
      final userDefaults = MockKeyValueStore();
      final env = Environment.fromStorage(
        apiService: Services.local,
        userDefaults: userDefaults,
      );

      when(userDefaults.getString(any)).thenReturn(null);

      expect(env.loggedIn, false);
      expect(env.currentUser, null);
      expect(Globals.apiService.bearerToken, null);
    });

    test("fromStorage() restores correctly", () {
      final userDefaults = MockKeyValueStore();
      final envJson = _stubEnvJson();

      when(userDefaults.getString(Environment.environmentStorageKey))
          .thenReturn(envJson);

      final env = Environment.fromStorage(
        apiService: Services.local,
        userDefaults: userDefaults,
      );

      expect(env.loggedIn, true);
      expect(env.currentUser!.nickname, "Archer");
      expect(env.currentUser!.avatar, "http://example.png");
      expect(Globals.apiService.bearerToken!.rawValue, "dead-bearer-token");
    });

    test("logout() clears all user session", () {
      final userDefaults = MockKeyValueStore();
      final envJson = _stubEnvJson();

      when(userDefaults.getString(Environment.environmentStorageKey))
          .thenReturn(envJson);

      final env = Environment.fromStorage(
        apiService: Services.local,
        userDefaults: userDefaults,
      );

      env.logout();

      expect(env.loggedIn, false);
      expect(env.currentUser, null);
      expect(Globals.apiService.bearerToken, null);
      verify(userDefaults.remove(Environment.environmentStorageKey)).called(1);
    });
  });
}

String _stubEnvJson() {
  final currentUser = User.fromJson(<String, dynamic>{
    "avatar": "http://example.png",
    "nickname": "Archer",
  });
  final data = <String, dynamic>{};
  data[Environment.currentUserStorageKey] = currentUser.toJson();
  data[Environment.bearerTokenStorageKey] = "dead-bearer-token";
  return json.encode(data);
}
