import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routing/routes.gr.dart';

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
        backgroundColor: const Color(0xffa1c6fd),
        title: const Text('Weather App - BARGE Antony'),
        centerTitle: true,
        leading: const AutoLeadingButton(),
      ), 
      routes: const [
        CurrentWeatherRoute(),
        SomewhereWeatherRoute()
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              tabsRouter.setActiveIndex(index);
            });
          },
          selectedIndex: tabsRouter.activeIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.sunny),
              label: 'Météo du jour',
            ),
            NavigationDestination(
              icon: Icon(Icons.location_on),
              label: 'Trouve ta météo',
            ),
          ],
        );
      },
    );
  }
}