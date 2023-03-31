import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routing/routes.gr.dart';
import '../view_models/home_navigationbar.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      appBarBuilder: (_, tabsRouter) => AppBar(
        title: const Text('Weather App - BARGE Antony'),
        centerTitle: true,
        leading: const AutoLeadingButton(),
      ), 
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