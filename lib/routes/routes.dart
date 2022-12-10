/*
 * Created by Archer on 2022/12/10.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shrinex_admin/pages/home_page.dart';

/// Can be used in Web environment.
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

final rootNavKey = GlobalKey<NavigatorState>(debugLabel: "rootNavKey");

GoRouter shrinexAdminRouter = GoRouter(navigatorKey: rootNavKey, routes: [
  GoRoute(path: "/", builder: (context, state) => const HomePage()),
]);
