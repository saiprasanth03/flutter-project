import 'package:flutter/material.dart';
import '../models/market_product.dart';

const marketLocations = ['Local Market', 'Main Market', 'Farmers Market'];
const productCategories = ['All', 'Vegetables', 'Grains', 'Pulses', 'Cash Crops'];

const marketProducts = <MarketProduct>[
  MarketProduct(name: 'Tomato', category: 'Vegetables', price: 30, unit: 'kg', market: 'Local Market', trend: PriceTrend.up, changePercent: 5, lastUpdated: '10:30 AM', icon: Icons.circle, description: 'Fresh, locally sourced tomatoes. A staple for everyday cooking.'),
  MarketProduct(name: 'Onion', category: 'Vegetables', price: 28, unit: 'kg', market: 'Main Market', trend: PriceTrend.down, changePercent: 2, lastUpdated: '10:15 AM', icon: Icons.layers, description: 'Farm-fresh onions, suitable for daily household use.'),
  MarketProduct(name: 'Potato', category: 'Vegetables', price: 24, unit: 'kg', market: 'Farmers Market', trend: PriceTrend.stable, changePercent: 0, lastUpdated: '10:20 AM', icon: Icons.spa, description: 'Locally harvested potatoes from nearby farms.'),
  MarketProduct(name: 'Rice', category: 'Grains', price: 52, unit: 'kg', market: 'Main Market', trend: PriceTrend.up, changePercent: 3, lastUpdated: '09:45 AM', icon: Icons.grain, description: 'A sample rate for staple rice grain.'),
  MarketProduct(name: 'Maize', category: 'Grains', price: 32, unit: 'kg', market: 'Local Market', trend: PriceTrend.down, changePercent: 1, lastUpdated: '09:50 AM', icon: Icons.grass, description: 'Locally traded maize grain.'),
  MarketProduct(name: 'Groundnut', category: 'Pulses', price: 86, unit: 'kg', market: 'Farmers Market', trend: PriceTrend.up, changePercent: 4, lastUpdated: '10:05 AM', icon: Icons.energy_savings_leaf, description: 'Groundnut sample price from the farmers market.'),
  MarketProduct(name: 'Chilli', category: 'Vegetables', price: 64, unit: 'kg', market: 'Local Market', trend: PriceTrend.up, changePercent: 6, lastUpdated: '10:30 AM', icon: Icons.local_fire_department, description: 'Fresh chillies, shown here with a demonstration rate.'),
  MarketProduct(name: 'Cotton', category: 'Cash Crops', price: 72, unit: 'kg', market: 'Main Market', trend: PriceTrend.stable, changePercent: 0, lastUpdated: '09:35 AM', icon: Icons.cloud, description: 'Indicative sample rate for raw cotton.'),
];
