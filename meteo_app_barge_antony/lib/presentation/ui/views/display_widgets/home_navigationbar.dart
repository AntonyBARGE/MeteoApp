import 'package:auto_route/auto_route.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../styles/constants.dart';

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
    final Constants constants = Constants();
    final TextStyle labelStyle = constants.navbarLabelStyle;
    final Color iconColor = constants.themeCustomColors.tertiary.darken(10);
    
    return CircleNavBar(
      onTap: (int index) {
        setState(() {
          tabsRouter.setActiveIndex(index);
        });
      },
      activeIndex: tabsRouter.activeIndex,
      activeIcons: <Widget>[
        Icon(Icons.sunny, size: 45, color: iconColor),
        Icon(Icons.location_on, size: 45, color: iconColor,),
      ],
      inactiveIcons: <Widget>[
        Text('Météo du jour', style: labelStyle,),
        Text('Trouve ta météo', style: labelStyle),
      ],
      circleWidth: 80,
      color: constants.themeCustomColors.tertiary.darken(5),
      height: 80,
      circleGradient: constants.navbarLinearGradientBlue,
    );
  }
}