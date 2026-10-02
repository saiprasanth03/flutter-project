import 'package:flutter/material.dart';

enum PriceTrend { up, down, stable }

class MarketProduct {
  const MarketProduct({required this.name, required this.category, required this.price, required this.unit, required this.market, required this.trend, required this.changePercent, required this.lastUpdated, required this.icon, required this.description});
  final String name;
  final String category;
  final double price;
  final String unit;
  final String market;
  final PriceTrend trend;
  final int changePercent;
  final String lastUpdated;
  final IconData icon;
  final String description;

  String get trendLabel => switch (trend) {
        PriceTrend.up => '↑ $changePercent%',
        PriceTrend.down => '↓ $changePercent%',
        PriceTrend.stable => '→ 0%',
      };
}
