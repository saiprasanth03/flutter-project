import 'package:flutter/material.dart';
import '../data/market_data.dart';
import '../models/market_product.dart';
import '../theme/app_theme.dart';
import '../widgets/category_filter.dart';
import '../widgets/price_summary.dart';
import '../widgets/product_card.dart';
import '../widgets/responsive_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String _category = 'All';
  String _market = 'Local Market';

  List<MarketProduct> get _filteredProducts => marketProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_query.trim().toLowerCase());
        final matchesCategory = _category == 'All' || product.category == _category;
        final matchesMarket = product.market == _market;
        return matchesSearch && matchesCategory && matchesMarket;
      }).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: Padding(padding: const EdgeInsets.only(left: 16), child: Icon(Icons.agriculture, color: AppTheme.green, size: 26)),
          leadingWidth: 48,
          title: const Text('Farmer Market Price Board'),
          actions: [if (MediaQuery.sizeOf(context).width >= 600) const _SampleBadge(), const SizedBox(width: 16)],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isMobile = width < 600;
          final isDesktop = width >= 1024;
          final columns = isDesktop ? 3 : (isMobile ? 1 : 2);
          final padding = isDesktop ? const EdgeInsets.fromLTRB(40, 28, 40, 36) : (isMobile ? const EdgeInsets.fromLTRB(18, 16, 18, 28) : const EdgeInsets.fromLTRB(32, 24, 32, 32));
          final shown = _filteredProducts;
          final categories = shown.map((item) => item.category).toSet().length;

          return SingleChildScrollView(child: ContentWidth(padding: padding, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _WelcomeHeader(isMobile: isMobile),
            SizedBox(height: isMobile ? 20 : 26),
            _Filters(isMobile: isMobile, query: _query, category: _category, market: _market,
              onQueryChanged: (value) => setState(() => _query = value),
              onCategoryChanged: (value) => setState(() => _category = value),
              onMarketChanged: (value) => setState(() => _market = value)),
            const SizedBox(height: 20),
            PriceSummary(productCount: shown.length, categoryCount: categories, lastUpdated: '10:30 AM'),
            const SizedBox(height: 26),
            Row(children: [const Expanded(child: Text('Market prices', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppTheme.ink))), Text('${shown.length} items', style: const TextStyle(fontSize: 12, color: AppTheme.muted))]),
            const SizedBox(height: 12),
            if (shown.isEmpty)
              _EmptyState(onClear: () => setState(() { _query = ''; _category = 'All'; }))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shown.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 14, mainAxisSpacing: 14, mainAxisExtent: isMobile ? 203 : 211),
                itemBuilder: (context, index) => ProductCard(product: shown[index], compact: isMobile, onTap: () => _showDetails(shown[index])),
              ),
            const SizedBox(height: 22),
            const _SampleNotice(),
            const SizedBox(height: 12),
            const _SdgNote(),
          ])));
        }),
      );

  void _showDetails(MarketProduct product) {
    showDialog<void>(context: context, builder: (context) => AlertDialog(
      icon: Icon(product.icon, size: 30, color: AppTheme.green),
      title: Text(product.name),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(product.description, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 18),
        _DetailRow(label: 'Category', value: product.category),
        _DetailRow(label: 'Market', value: product.market),
        _DetailRow(label: 'Sample price', value: '₹${product.price.toStringAsFixed(0)} / ${product.unit}'),
        _DetailRow(label: 'Price trend', value: product.trendLabel),
        _DetailRow(label: 'Last updated', value: product.lastUpdated),
        const SizedBox(height: 8),
        const Text('Demonstration data only', style: TextStyle(fontSize: 12, color: AppTheme.muted, fontStyle: FontStyle.italic)),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ));
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.isMobile});
  final bool isMobile;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(isMobile ? 20 : 30),
    decoration: BoxDecoration(color: const Color(0xFFE8EFE2), borderRadius: BorderRadius.circular(22)),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(.75), borderRadius: BorderRadius.circular(30)), child: const Text('MARKET SNAPSHOT  ·  DEMO DATA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .7, color: AppTheme.green))),
        const SizedBox(height: 12),
        Text("Today's Market Prices", style: TextStyle(fontSize: isMobile ? 25 : 32, height: 1.12, fontWeight: FontWeight.w800, letterSpacing: -.6, color: AppTheme.ink)),
        const SizedBox(height: 8),
        const Text('A simple view of sample produce rates across local markets.', style: TextStyle(fontSize: 14, height: 1.45, color: AppTheme.muted)),
      ])),
      if (!isMobile) ...[const SizedBox(width: 16), Container(width: 76, height: 76, decoration: BoxDecoration(color: Colors.white.withOpacity(.7), shape: BoxShape.circle), child: const Icon(Icons.eco_outlined, color: AppTheme.green, size: 40))],
    ]),
  );
}

class _Filters extends StatelessWidget {
  const _Filters({required this.isMobile, required this.query, required this.category, required this.market, required this.onQueryChanged, required this.onCategoryChanged, required this.onMarketChanged});
  final bool isMobile;
  final String query;
  final String category;
  final String market;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onMarketChanged;

  @override
  Widget build(BuildContext context) {
    final search = TextField(onChanged: onQueryChanged, decoration: InputDecoration(hintText: 'Search products', prefixIcon: const Icon(Icons.search), suffixIcon: query.isEmpty ? null : IconButton(icon: const Icon(Icons.close), onPressed: () => onQueryChanged(''))));
    final marketPicker = DropdownButtonFormField<String>(value: market, isExpanded: true, decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined), contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)), items: marketLocations.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(), onChanged: (value) { if (value != null) onMarketChanged(value); });
    if (isMobile) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [search, const SizedBox(height: 12), marketPicker, const SizedBox(height: 15), const SectionLabel('CATEGORY'), const SizedBox(height: 9), CategoryFilter(selected: category, onSelected: onCategoryChanged)]);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(flex: 3, child: search), const SizedBox(width: 12), SizedBox(width: 220, child: marketPicker)]),
      const SizedBox(height: 14),
      Row(children: [const SectionLabel('CATEGORY'), const SizedBox(width: 14), Expanded(child: CategoryFilter(selected: category, onSelected: onCategoryChanged))]),
    ]);
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: AppTheme.muted))), Text(value, style: const TextStyle(fontWeight: FontWeight.w700))]));
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});
  final VoidCallback onClear;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 34), child: Column(children: [const Icon(Icons.search_off, size: 36, color: AppTheme.muted), const SizedBox(height: 10), const Text('No matching products', style: TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), const Text('Try another search or category.', style: TextStyle(color: AppTheme.muted)), TextButton(onPressed: onClear, child: const Text('Clear search and category'))])));
}

class _SampleNotice extends StatelessWidget {
  const _SampleNotice();
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF4DE), borderRadius: BorderRadius.circular(14)), child: const Row(children: [Icon(Icons.info_outline, size: 19, color: Color(0xFF8A6427)), SizedBox(width: 10), Expanded(child: Text('Sample market prices for demonstration. These are not real-time rates.', style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF6F5528))))]));
}

class _SdgNote extends StatelessWidget {
  const _SdgNote();
  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.public, size: 17, color: AppTheme.green), SizedBox(width: 8), Expanded(child: Text('SDG 2 · Zero Hunger — Accessible agricultural market information can improve awareness of food markets, a concept related to food security.', style: TextStyle(fontSize: 11, height: 1.45, color: AppTheme.muted)))]));
}

class _SampleBadge extends StatelessWidget {
  const _SampleBadge();
  @override
  Widget build(BuildContext context) => Container(alignment: Alignment.center, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFE8EFE2), borderRadius: BorderRadius.circular(20)), child: const Text('SAMPLE DATA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .5, color: AppTheme.green)));
}




