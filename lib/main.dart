import 'dart:async';

import 'package:flutter/material.dart';

import 'permission.dart';
import 'bg_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    handleLocationPermission(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Demo for running background service in Flutter app 🚀'),
        ),
      ),
    );
  }
}
