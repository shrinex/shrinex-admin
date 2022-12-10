/*
 * Created by Archer on 2022/12/10.
 * Copyright © 2022 Archer. All rights reserved.
 * Github: https://github.com/shrinex
 * Home: http://anyoptional.com
 */

import 'package:viewmodel_driven/viewmodel_driven.dart';

abstract class HomePageViewModelType extends ViewModel {}

abstract class HomePageViewModelInputs extends ViewModelInputs {}

abstract class HomePageViewModelOutputs extends ViewModelOutputs {}

class HomePageViewModel
    implements
        HomePageViewModelType,
        HomePageViewModelInputs,
        HomePageViewModelOutputs {
  @override
  HomePageViewModelInputs get inputs => this;

  @override
  HomePageViewModelOutputs get outputs => this;

  @override
  void dispose() {}
}
