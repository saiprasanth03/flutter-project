import 'package:flutter/material.dart';
import '../models/market_product.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap, this.compact = false});
  final MarketProduct product;
  final VoidCallback onTap;
  final bool compact;
  Color get _trendColor => switch (product.trend) { PriceTrend.up => const Color(0xFFB64D3B), PriceTrend.down => AppTheme.green, PriceTrend.stable => AppTheme.muted };
  Color get _iconColor => switch (product.category) { 'Vegetables' => const Color(0xFF5C8C54), 'Grains' => const Color(0xFFB1843D), 'Pulses' => const Color(0xFF936F49), _ => const Color(0xFF6978A5) };

  @override
  Widget build(BuildContext context) => Card(child: InkWell(
    borderRadius: BorderRadius.circular(18), onTap: onTap,
    child: Padding(padding: EdgeInsets.all(compact ? 16 : 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(width: 46, height: 46, decoration: BoxDecoration(color: _iconColor.withOpacity(.12), borderRadius: BorderRadius.circular(14)), child: Icon(product.icon, color: _iconColor, size: 23)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.ink)), const SizedBox(height: 3), Text(product.category, style: const TextStyle(fontSize: 12, color: AppTheme.muted))])), Icon(Icons.arrow_outward, size: 17, color: Colors.grey.shade400)]),
      SizedBox(height: compact ? 18 : 24),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(child: RichText(text: TextSpan(style: const TextStyle(color: AppTheme.ink), children: [const TextSpan(text: '₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), TextSpan(text: product.price.toStringAsFixed(0), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -.8)), TextSpan(text: ' / ${product.unit}', style: const TextStyle(fontSize: 13, color: AppTheme.muted, fontWeight: FontWeight.w500))]))), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: _trendColor.withOpacity(.1), borderRadius: BorderRadius.circular(20)), child: Text(product.trendLabel, style: TextStyle(color: _trendColor, fontSize: 12, fontWeight: FontWeight.w700)))]),
      SizedBox(height: compact ? 14 : 18),
      Row(children: [Icon(Icons.schedule, size: 14, color: Colors.grey.shade500), const SizedBox(width: 5), Text('Updated ${product.lastUpdated}', style: const TextStyle(color: AppTheme.muted, fontSize: 12)), const Spacer(), if (!compact) Flexible(child: Text(product.market, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.muted, fontSize: 11)))])
    ]))));
}
