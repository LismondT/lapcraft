import 'package:flutter/material.dart';
import 'package:lapcraft/core/core.dart';
import 'package:lapcraft/dependencies_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await serviceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Lapcraft',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange, brightness: Brightness.light),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router);
  }
}
