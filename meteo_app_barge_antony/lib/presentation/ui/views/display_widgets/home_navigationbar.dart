import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class HomeNavigationBar extends StatefulWidget {
  TabsRouter tabsRouter;

  HomeNavigationBar(this.tabsRouter, {super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final TabsRouter tabsRouter = widget.tabsRouter;
    
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
  }
}