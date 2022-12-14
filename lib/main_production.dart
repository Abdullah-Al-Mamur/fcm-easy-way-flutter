// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_cloud_messeging/app/app.dart';
import 'package:firebase_cloud_messeging/bootstrap.dart';
import 'package:flutter/material.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(() => const App());
}
