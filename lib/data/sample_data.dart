import 'package:flutter/material.dart';
import '../models/commodity.dart';
import '../models/market.dart';

const sampleMarkets = <Market>[
  Market(id: 'guntur', name: 'Guntur', region: 'Andhra Pradesh', priceFactor: 1.00, changeAdjustment: 0),
  Market(id: 'vijayawada', name: 'Vijayawada', region: 'Andhra Pradesh', priceFactor: 1.03, changeAdjustment: .4),
  Market(id: 'visakhapatnam', name: 'Visakhapatnam', region: 'Andhra Pradesh', priceFactor: .98, changeAdjustment: -.3),
  Market(id: 'hyderabad', name: 'Hyderabad', region: 'Telangana', priceFactor: 1.05, changeAdjustment: .6),
  Market(id: 'warangal', name: 'Warangal', region: 'Telangana', priceFactor: .97, changeAdjustment: -.5),
  Market(id: 'kurnool', name: 'Kurnool', region: 'Andhra Pradesh', priceFactor: 1.01, changeAdjustment: .2),
];

const commodityCategories = <String>[
  'All', 'Cereals', 'Vegetables', 'Fruits', 'Pulses', 'Spices', 'Cash Crops',
];

class _CommoditySeed {
  const _CommoditySeed(this.id, this.name, this.category, this.baseModal, this.change, this.icon, this.description);
  final String id;
  final String name;
  final String category;
  final double baseModal;
  final double change;
  final IconData icon;
  final String description;
}

const _seeds = <_CommoditySeed>[
  _CommoditySeed('rice', 'Rice', 'Cereals', 2250, 2.3, Icons.grain, 'Common paddy rice sample rate per quintal.'),
  _CommoditySeed('wheat', 'Wheat', 'Cereals', 2480, 1.2, Icons.grass, 'Wheat grain sample rate per quintal.'),
  _CommoditySeed('maize', 'Maize', 'Cereals', 2050, -1.4, Icons.agriculture, 'Maize grain sample rate per quintal.'),
  _CommoditySeed('tomato', 'Tomato', 'Vegetables', 1500, -8.5, Icons.circle, 'Fresh tomato sample rate per quintal.'),
  _CommoditySeed('onion', 'Onion', 'Vegetables', 2200, 4.1, Icons.layers, 'Onion sample rate per quintal.'),
  _CommoditySeed('potato', 'Potato', 'Vegetables', 1400, 1.8, Icons.spa, 'Potato sample rate per quintal.'),
  _CommoditySeed('banana', 'Banana', 'Fruits', 1600, 3.2, Icons.energy_savings_leaf, 'Banana sample rate per quintal.'),
  _CommoditySeed('mango', 'Mango', 'Fruits', 3900, 7.4, Icons.eco, 'Seasonal mango sample rate per quintal.'),
  _CommoditySeed('groundnut', 'Groundnut', 'Pulses', 6100, 2.0, Icons.grass, 'Groundnut sample rate per quintal.'),
  _CommoditySeed('toor-dal', 'Toor Dal', 'Pulses', 7200, 1.5, Icons.circle_outlined, 'Toor dal sample rate per quintal.'),
  _CommoditySeed('chilli', 'Chilli', 'Spices', 14500, 6.0, Icons.local_fire_department, 'Dry chilli sample rate per quintal.'),
  _CommoditySeed('turmeric', 'Turmeric', 'Spices', 9800, -2.2, Icons.spa, 'Turmeric sample rate per quintal.'),
  _CommoditySeed('cotton', 'Cotton', 'Cash Crops', 6800, 3.5, Icons.cloud_outlined, 'Raw cotton sample rate per quintal.'),
  _CommoditySeed('soybean', 'Soybean', 'Cash Crops', 4650, -1.0, Icons.grass, 'Soybean sample rate per quintal.'),
  _CommoditySeed('sugarcane', 'Sugarcane', 'Cash Crops', 340, 0.8, Icons.spa, 'Sugarcane sample rate per quintal.'),
];

final List<Commodity> sampleCommodities = List<Commodity>.unmodifiable(_seeds.map(_buildCommodity));

Commodity _buildCommodity(_CommoditySeed seed) {
  final prices = <String, CommodityPrice>{};
  for (final market in sampleMarkets) {
    final modal = _roundToTen(seed.baseModal * market.priceFactor);
    final change = seed.change + market.changeAdjustment;
    final previous = _roundToTen(modal / (1 + change / 100));
    prices[market.name] = CommodityPrice(
      minimum: _roundToTen(modal * .94),
      maximum: _roundToTen(modal * 1.08),
      modal: modal,
      previous: previous,
      unit: 'quintal',
      history: List<double>.unmodifiable([
        _roundToTen(previous * .94),
        _roundToTen(previous * .98),
        _roundToTen(previous * 1.02),
        _roundToTen(modal * .97),
        modal,
      ]),
    );
  }
  return Commodity(
    id: seed.id,
    name: seed.name,
    category: seed.category,
    description: seed.description,
    icon: seed.icon,
    marketPrices: Map<String, CommodityPrice>.unmodifiable(prices),
  );
}

double _roundToTen(double value) => (value / 10).round() * 10.0;
