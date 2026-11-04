import ''package:flutter/material.dart'';

class CommodityPrice {
  const CommodityPrice({required this.minimum, required this.maximum, required this.modal, required this.previous, required this.unit, required this.history});
  final double minimum;
  final double maximum;
  final double modal;
  final double previous;
  final String unit;
  final List<double> history;

  double get changePercent => previous == 0 ? 0 : ((modal - previous) / previous) * 100;
  bool get isIncreasing => changePercent > 0.05;
  bool get isDecreasing => changePercent < -0.05;
}

class Commodity {
  const Commodity({required this.id, required this.name, required this.category, required this.description, required this.icon, required this.marketPrices});
  final String id;
  final String name;
  final String category;
  final String description;
  final IconData icon;
  final Map<String, CommodityPrice> marketPrices;

  CommodityPrice priceFor(String marketName) => marketPrices[marketName]!;
}
