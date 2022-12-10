/*
 * Created by Archer on 2022/12/10.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:flutter/material.dart';
import 'package:shrinex_admin/viewmodels/home_page_view_model.dart';
import 'package:viewmodel_driven/viewmodel_driven.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with ViewModelProviderStateMixin<HomePage, HomePageViewModel> {
  @override
  HomePageViewModel createViewModel() => HomePageViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
    );
  }
}
