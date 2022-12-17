/*
 * Created by Archer on 2022/12/11.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:shrinex_io/shrinex_io.dart';

/// Predefined [Service]s
abstract class Services {
  /// A production grade [Service]
  static final prod = Service.using(
    restClient: DioRestClient.using(
      restOptions: RestOptions(
        baseUrl: 'http://api.anyoptional.com',
      ),
    ),
  );

  /// A [Service] that is used in local environment
  static final local = Service.using(
    restClient: DioRestClient.using(
      restOptions: RestOptions(
        baseUrl: 'http://localhost:8088',
      ),
    ),
  );
}
