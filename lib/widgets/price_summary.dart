import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriceSummary extends StatelessWidget {
  const PriceSummary({super.key, required this.productCount, required this.categoryCount, required this.lastUpdated});
  final int productCount;
  final int categoryCount;
  final String lastUpdated;
  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryItem(icon: Icons.inventory_2_outlined, label: 'Products listed', value: '$productCount', tint: AppTheme.green),
      _SummaryItem(icon: Icons.category_outlined, label: 'Categories', value: '$categoryCount', tint: const Color(0xFF9A6B2F)),
      _SummaryItem(icon: Icons.update, label: 'Last updated', value: lastUpdated, tint: const Color(0xFF6477A0)),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final horizontal = constraints.maxWidth >= 600;
      return Wrap(spacing: 12, runSpacing: 12, children: items.map((item) => SizedBox(width: horizontal ? (constraints.maxWidth - 24) / 3 : constraints.maxWidth, child: _SummaryTile(item: item))).toList());
    });
  }
}

class _SummaryItem {
  const _SummaryItem({required this.icon, required this.label, required this.value, required this.tint});
  final IconData icon; final String label; final String value; final Color tint;
}
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({required this.item});
  final _SummaryItem item;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: item.tint.withOpacity(.11), borderRadius: BorderRadius.circular(12)), child: Icon(item.icon, size: 20, color: item.tint)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppTheme.muted)), const SizedBox(height: 4), Text(item.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.ink))]))])));
}
