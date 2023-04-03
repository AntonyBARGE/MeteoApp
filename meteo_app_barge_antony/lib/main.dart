import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:meteo_app_barge_antony/presentation/ui/styles/constants.dart';
import 'application/injections/injection.dart' as injections;
import 'presentation/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injections.init();
  initializeDateFormatting();
  runApp(const MyApp());
}

final _appRouter = AppRouter();
final Constants constants = Constants();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      
      theme: constants.lightTheme,
      darkTheme: constants.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
