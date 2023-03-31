import 'package:flutter/material.dart';
import 'application/injections/injection.dart' as injections;
import 'presentation/routing/routes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injections.init();
  runApp(const MyApp());
}

final _appRouter = AppRouter();
final FlexSchemeColor _schemeLight = FlexSchemeColor.from(
  primary: const Color(0xff6b9dfc),
  secondary: const Color(0xffa1c6fd),
  brightness: Brightness.light,
);
const FlexSubThemesData _subThemesData = FlexSubThemesData();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      // The Mandy red, light theme.
      theme: FlexThemeData.light(
        colors: _schemeLight,
        subThemesData: _subThemesData
      ),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(colors: _schemeLight.toDark(30, true)),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,
    );
  }
}
