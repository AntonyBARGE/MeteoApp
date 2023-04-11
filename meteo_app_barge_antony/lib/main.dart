import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'application/injections/injection.dart' as injections;
import 'presentation/routing/routes.dart';
import 'presentation/ui/styles/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injections.init(injections.currentWeatherSL);
  await injections.init(injections.choosenWeatherSL);
  initializeDateFormatting();
  runApp(const MyApp());
}

final _appRouter = AppRouter();

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
      
      theme: UI.LIGHT_THEME,
      darkTheme: UI.DARK_THEME,
      themeMode: ThemeMode.system,
    );
  }
}
