/*
 * Created by Archer on 2022/12/11.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:shrinex_admin/api/models/User.dart';
import 'package:shrinex_core/shrinex_core.dart';
import 'package:shrinex_io/shrinex_io.dart';

class Environment {
  /// The currently logged in user.
  final User? currentUser;

  /// A type that exposes endpoints for fetching ShrineX data.
  final Service apiService;

  /// The amount of time to debounce signals by. Default value is `0.3`.
  final double debounceInterval;

  /// A user defaults key-value store.
  final KeyValueStore userDefaults;

  /// Returns the current environment kind.
  Kind get kind => apiService.serverOptions.kind;

  Environment({
    this.currentUser,
    required this.apiService,
    required this.userDefaults,
    this.debounceInterval = 0.3,
  });
}
