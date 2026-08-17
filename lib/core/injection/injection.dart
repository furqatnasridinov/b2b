import 'package:b2b_seller/core/injection/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt sl = GetIt.instance;

@InjectableInit(
  //initializerName: 'init',
  //preferRelativeImports: false,
)
Future<void> initDependencies() async => sl.init();
