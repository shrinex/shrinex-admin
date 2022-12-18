/*
 * Created by Archer on 2022/12/11.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:shrinex_io/shrinex_io.dart';

/// TBD
class User {
  late String nickname;

  late String avatar;

  User();

  factory User.fromJson(Map<String, dynamic> raw) {
    final json = JSON.from(raw);
    final result = User();
    result.avatar = json["avatar"].stringValue;
    result.nickname = json["nickname"].stringValue;
    return result;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "avatar": avatar,
        "nickname": nickname,
      };
}
