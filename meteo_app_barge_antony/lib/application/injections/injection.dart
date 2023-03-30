import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// service locator
final serviceLocator = GetIt.instance;

Future<void> init() async {

}

void getInjections() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
}