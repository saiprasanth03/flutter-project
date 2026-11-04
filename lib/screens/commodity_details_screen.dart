import 'package:flutter/material.dart';
import '../models/commodity.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/price_history_chart.dart';

class CommodityDetailsScreen extends StatefulWidget {
  const CommodityDetailsScreen({super.key, required this.commodity, required this.marketName, required this.isFavorite, required this.onFavoriteTap});
  final Commodity commodity;
  final String marketName;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  State<CommodityDetailsScreen> createState() => _CommodityDetailsScreenState();
}

class _CommodityDetailsScreenState extends State<CommodityDetailsScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoriteTap();
  }

  @override
  Widget build(BuildContext context) {
    final commodity = widget.commodity;
    final marketName = widget.marketName;
    final price = commodity.priceFor(marketName);
    final up = price.isIncreasing;
    final down = price.isDecreasing;
    final trendColor = up ? AppColors.positive : (down ? AppColors.negative : AppColors.muted);
    final changeText = '${price.changePercent > 0 ? '+' : ''}${price.changePercent.toStringAsFixed(1)}%';
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1024 ? 40.0 : (width >= 600 ? 28.0 : 18.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commodity details'),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favourites' : 'Add to favourites',
            onPressed: _toggleFavorite,
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? AppColors.negative : AppColors.muted),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(width < 600 ? 18 : 26),
                  child: Row(children: [
                    Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFFEAF2E8), borderRadius: BorderRadius.circular(17)), child: Icon(commodity.icon, size: 29, color: AppColors.forest)),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(commodity.name, style: TextStyle(fontSize: width < 600 ? 23 : 30, fontWeight: FontWeight.w800, color: AppColors.ink)),
                      const SizedBox(height: 5),
                      Text('${commodity.category}  ·  $marketName', style: const TextStyle(color: AppColors.muted)),
                    ])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: trendColor.withOpacity(.1), borderRadius: BorderRadius.circular(24)), child: Text(changeText, style: TextStyle(color: trendColor, fontWeight: FontWeight.w800))),
                  ]),
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(builder: (context, constraints) {
                final columns = constraints.maxWidth < 600 ? 2 : 4;
                const gap = 12.0;
                final tileWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
                final facts = [
                  _PriceFact(label: 'Minimum price', value: formatRupees(price.minimum)),
                  _PriceFact(label: 'Maximum price', value: formatRupees(price.maximum)),
                  _PriceFact(label: 'Modal price', value: formatRupees(price.modal)),
                  _PriceFact(label: 'Previous price', value: formatRupees(price.previous)),
                ];
                return Wrap(spacing: gap, runSpacing: gap, children: facts.map((fact) => SizedBox(width: tileWidth, child: fact)).toList());
              }),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(width < 600 ? 18 : 24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      const Expanded(child: Text('Price history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink))),
                      Row(children: [Icon(up ? Icons.trending_up : (down ? Icons.trending_down : Icons.trending_flat), size: 18, color: trendColor), const SizedBox(width: 5), Text(up ? 'Increased' : (down ? 'Decreased' : 'Stable'), style: TextStyle(color: trendColor, fontWeight: FontWeight.w700))]),
                    ]),
                    const SizedBox(height: 4),
                    Text('Demonstration price movement · ₹ per ${price.unit}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(height: 16),
                    PriceHistoryChart(values: price.history, isPositive: !down),
                    const SizedBox(height: 8),
                    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('5 sessions ago', style: TextStyle(fontSize: 11, color: AppColors.muted)), Text('Previous', style: TextStyle(fontSize: 11, color: AppColors.muted)), Text('Recent', style: TextStyle(fontSize: 11, color: AppColors.muted))]),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF4DE), borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.info_outline, size: 18, color: AppColors.amber), SizedBox(width: 9), Expanded(child: Text('These are local demonstration values, not live government market prices.', style: TextStyle(fontSize: 12, color: Color(0xFF705426))))])),
            ]),
          ),
        ),
      ),
    );
  }
}

class _PriceFact extends StatelessWidget {
  const _PriceFact({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)), const SizedBox(height: 8), Text('$value / qtl', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink))])));
}
