import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const FarmerMarketApp());

class FarmerMarketApp extends StatelessWidget {
  const FarmerMarketApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Farmer Market Price Board',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      );
}
