import 'package:auto_route/auto_route.dart';

import 'routes.gr.dart';


@AutoRouterConfig()      
class AppRouter extends $AppRouter {      
    
  @override      
  final List<AutoRoute> routes = [
    AutoRoute(
      path: '/',
      page: HomeRoute.page,
      children: [
        AutoRoute(
          page: CurrentWeatherRoute.page,
        ),
        AutoRoute(
          page: SomewhereWeatherRoute.page,
        ),
      ],
    )
  ];
 }