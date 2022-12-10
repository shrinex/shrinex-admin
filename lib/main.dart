/*
 * Created by Archer on 2022/12/10.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrinex_admin/routes/routes.dart';
import 'package:shrinex_core/shrinex_core.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  var store = KeyValueStore.using(
    await SharedPreferences.getInstance(),
  );
  runApp(const ShrinexAdminApp());
}

class ShrinexAdminApp extends StatelessWidget {
  const ShrinexAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: shrinexAdminRouter,
    );
  }
}
