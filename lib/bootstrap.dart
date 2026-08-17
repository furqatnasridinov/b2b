import 'dart:async';
import 'dart:developer';

import 'package:b2b_seller/core/injection/injection.dart';
import 'package:b2b_seller/core/services/local_data_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
) async {

  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // show splash while initing dependencies
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };


  //Bloc.observer = const AppBlocObserver();

  // Force Portrait Mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal Portrait
    DeviceOrientation.portraitDown, // Upside-Down Portrait
  ]);

  //await all initializations
  await initializations();

  //remove flutter splash screen after initializations
  FlutterNativeSplash.remove();

  runApp(await builder());
}

//init async methods
Future<void> initializations() async {
  // init env 
  await dotenv.load();

  //initialize shared preferences
  await LocalDataStorage.init();
  //firebase initialization
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

   // initializes dependencies
  await initDependencies();
  // ... 
}
