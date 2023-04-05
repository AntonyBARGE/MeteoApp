import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routing/routes.gr.dart';
import '../styles/constants.dart';
import 'display_widgets/home_navigationbar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    Constants constants = Constants();
    return AutoTabsScaffold(
      backgroundColor: constants.themeCustomColors.tertiary,
      routes: const [
        CurrentWeatherRoute(),
        SomewhereWeatherRoute()
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return HomeNavigationBar(tabsRouter);
      },
    );
  }
}