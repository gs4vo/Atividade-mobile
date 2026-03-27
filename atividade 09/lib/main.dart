import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

import 'presentation/pages/home_page.dart';
import 'state/provider/product_provider.dart';

void main() {
  runApp(
    provider.ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fake Store App',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
