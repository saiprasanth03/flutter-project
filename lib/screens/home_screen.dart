import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import '../models/commodity.dart';
import '../utils/app_breakpoints.dart';
import '../utils/app_colors.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/category_filter.dart';
import '../widgets/commodity_card.dart';
import '../widgets/commodity_table.dart';
import '../widgets/dashboard_stat_card.dart';
import 'commodity_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BoardSection _section = BoardSection.overview;
  String _marketName = sampleMarkets.first.name;
  String _query = '';
  String _category = 'All';
  String _sort = 'Price: Low to High';
  final Set<String> _favoriteIds = <String>{};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Commodity> get _visibleCommodities {
    final query = _query.trim().toLowerCase();
    final values = sampleCommodities.where((commodity) {
      final matchesQuery = commodity.name.toLowerCase().contains(query);
      final matchesCategory = _category == 'All' || commodity.category == _category;
      final matchesFavorite = _section != BoardSection.favourites || _favoriteIds.contains(commodity.id);
      return matchesQuery && matchesCategory && matchesFavorite;
    }).toList();

    int comparePrice(Commodity first, Commodity second) =>
        first.priceFor(_marketName).modal.compareTo(second.priceFor(_marketName).modal);
    switch (_sort) {
      case 'Price: High to Low':
        values.sort((a, b) => comparePrice(b, a));
        break;
      case 'Name: A to Z':
        values.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Highest Price Increase':
        values.sort((a, b) => b.priceFor(_marketName).changePercent.compareTo(a.priceFor(_marketName).changePercent));
        break;
      case 'Highest Price Decrease':
        values.sort((a, b) => a.priceFor(_marketName).changePercent.compareTo(b.priceFor(_marketName).changePercent));
        break;
      default:
        values.sort(comparePrice);
        break;
    }
    return values;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final breakpoint = AppBreakpoints.fromWidth(constraints.maxWidth);
        final isMobile = breakpoint == AppBreakpoint.mobile;
        final isTablet = breakpoint == AppBreakpoint.tablet;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.agriculture, color: AppColors.forest, size: 25),
              const SizedBox(width: 10),
              Text(isMobile ? 'Market Board' : 'Farmer Market Price Board', maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
            actions: [
              if (!isMobile)
                Container(
                  margin: const EdgeInsets.only(right: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(color: const Color(0xFFEAF2E8), borderRadius: BorderRadius.circular(24)),
                  child: const Text('SAMPLE DATA', style: TextStyle(fontSize: 10, letterSpacing: .5, color: AppColors.forest, fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          body: Row(children: [
            if (breakpoint == AppBreakpoint.desktop)
              AppSidebar(selected: _section, onSelected: _selectSection)
            else if (isTablet)
              NavigationRail(
                selectedIndex: _section.index,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (index) => _selectSection(BoardSection.values[index]),
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: Text('Overview')),
                  NavigationRailDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: Text('Board')),
                  NavigationRailDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: Text('Favourites')),
                ],
              ),
            Expanded(child: _buildContent(breakpoint)),
          ]),
          bottomNavigationBar: isMobile
              ? NavigationBar(
                  selectedIndex: _section.index,
                  onDestinationSelected: (index) => _selectSection(BoardSection.values[index]),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.space_dashboard_outlined), selectedIcon: Icon(Icons.space_dashboard), label: 'Overview'),
                    NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Board'),
                    NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favourites'),
                  ],
                )
              : null,
        );
      });

  void _selectSection(BoardSection section) => setState(() {
        _section = section;
        _query = '';
        _searchController.clear();
        _category = 'All';
      });

  void _clearSearch() => setState(() {
        _query = '';
        _searchController.clear();
      });

  void _clearFilters() => setState(() {
        _category = 'All';
        _query = '';
        _searchController.clear();
      });

  void _setMarket(String market) => setState(() => _marketName = market);

  void _toggleFavorite(Commodity commodity) => setState(() {
        if (!_favoriteIds.add(commodity.id)) _favoriteIds.remove(commodity.id);
      });

  void _openDetails(Commodity commodity) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => CommodityDetailsScreen(
        commodity: commodity,
        marketName: _marketName,
        isFavorite: _favoriteIds.contains(commodity.id),
        onFavoriteTap: () => _toggleFavorite(commodity),
      ),
    ));
  }

  Widget _buildContent(AppBreakpoint breakpoint) {
    final horizontalPadding = switch (breakpoint) {
      AppBreakpoint.mobile => 18.0,
      AppBreakpoint.tablet => 26.0,
      AppBreakpoint.desktop => 36.0,
    };
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPadding, breakpoint == AppBreakpoint.mobile ? 14 : 24, horizontalPadding, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: switch (_section) {
            BoardSection.overview => _buildOverview(breakpoint),
            BoardSection.commodities => _buildCommodityBoard(breakpoint),
            BoardSection.favourites => _buildCommodityBoard(breakpoint, favouritesOnly: true),
          },
        ),
      ),
    );
  }

  Widget _buildOverview(AppBreakpoint breakpoint) {
    final featured = _sortedForMarket(sampleCommodities).take(4).toList();
    final rising = sampleCommodities.where((item) => item.priceFor(_marketName).isIncreasing).length;
    final falling = sampleCommodities.where((item) => item.priceFor(_marketName).isDecreasing).length;
    final average = sampleCommodities.map((item) => item.priceFor(_marketName).modal).reduce((a, b) => a + b) / sampleCommodities.length;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildPageHeading(
        title: 'Market overview',
        subtitle: 'A clear snapshot of agricultural prices in your selected market.',
      ),
      const SizedBox(height: 20),
      _WelcomeBanner(marketName: _marketName, isMobile: breakpoint == AppBreakpoint.mobile),
      const SizedBox(height: 18),
      LayoutBuilder(builder: (context, constraints) {
        final columns = breakpoint == AppBreakpoint.desktop ? 4 : 2;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        final stats = [
          DashboardStatCard(label: 'Commodities', value: '${sampleCommodities.length}', icon: Icons.inventory_2_outlined, accent: AppColors.forest, helper: 'Across 6 categories'),
          DashboardStatCard(label: 'Average modal price', value: formatRupees(average), icon: Icons.payments_outlined, accent: const Color(0xFF926B2A), helper: 'Per quintal'),
          DashboardStatCard(label: 'Prices increasing', value: '$rising', icon: Icons.trending_up, accent: AppColors.positive, helper: 'In this market'),
          DashboardStatCard(label: 'Prices decreasing', value: '$falling', icon: Icons.trending_down, accent: AppColors.negative, helper: 'In this market'),
        ];
        return Wrap(spacing: gap, runSpacing: gap, children: stats.map((stat) => SizedBox(width: width, child: stat)).toList());
      }),
      const SizedBox(height: 26),
      if (breakpoint == AppBreakpoint.desktop)
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 3, child: _featuredSection(featured, breakpoint)),
          const SizedBox(width: 18),
          Expanded(flex: 2, child: _recentUpdates()),
        ])
      else ...[
        _featuredSection(featured, breakpoint),
        const SizedBox(height: 24),
        _recentUpdates(),
      ],
      const SizedBox(height: 22),
      const _SdgPanel(),
    ]);
  }

  Widget _buildCommodityBoard(AppBreakpoint breakpoint, {bool favouritesOnly = false}) {
    final results = _visibleCommodities;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildPageHeading(
        title: favouritesOnly ? 'Favourites' : 'Commodity price board',
        subtitle: favouritesOnly ? 'Your saved commodities for quick reference.' : 'Search, compare, and sort sample market prices.',
      ),
      const SizedBox(height: 18),
      LayoutBuilder(builder: (context, _) {
        final search = TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Search commodities',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _query.isEmpty ? null : IconButton(tooltip: 'Clear search', onPressed: _clearSearch, icon: const Icon(Icons.close)),
          ),
        );
        final sort = DropdownButtonFormField<String>(
          value: _sort,
          isExpanded: true,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.sort), labelText: 'Sort by'),
          items: _sortOptions.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (value) { if (value != null) setState(() => _sort = value); },
        );
        if (breakpoint == AppBreakpoint.mobile) {
          return Column(children: [search, const SizedBox(height: 10), sort]);
        }
        return Row(children: [Expanded(flex: 3, child: search), const SizedBox(width: 12), SizedBox(width: 270, child: sort)]);
      }),
      const SizedBox(height: 16),
      const _Overline('CATEGORY'),
      const SizedBox(height: 8),
      CategoryFilter(selected: _category, onSelected: (value) => setState(() => _category = value)),
      const SizedBox(height: 18),
      Row(children: [
        Expanded(child: Text('${results.length} ${results.length == 1 ? 'commodity' : 'commodities'} · $_marketName', style: const TextStyle(color: AppColors.muted, fontSize: 12))),
        if (!favouritesOnly && _favoriteIds.isNotEmpty)
          Text('${_favoriteIds.length} saved', style: const TextStyle(color: AppColors.forest, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 10),
      if (results.isEmpty)
        _EmptyState(
          title: favouritesOnly ? 'No favourites yet' : 'No commodities found',
          message: favouritesOnly ? 'Tap the heart on any commodity to save it here.' : 'Try another name or select a different category.',
          onClear: favouritesOnly ? null : _clearFilters,
        )
      else if (breakpoint == AppBreakpoint.desktop)
        CommodityTable(commodities: results, marketName: _marketName, favorites: _favoriteIds, onOpen: _openDetails, onFavorite: _toggleFavorite)
      else if (breakpoint == AppBreakpoint.tablet)
        _commodityGrid(results, breakpoint)
      else
        _commodityList(results),
      const SizedBox(height: 22),
      const _SampleNotice(),
    ]);
  }

  Widget _featuredSection(List<Commodity> items, AppBreakpoint breakpoint) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: Text('Featured commodity prices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink))),
          TextButton(onPressed: () => _selectSection(BoardSection.commodities), child: const Text('View board')),
        ]),
        const SizedBox(height: 10),
        breakpoint == AppBreakpoint.mobile ? _commodityList(items) : _commodityGrid(items, breakpoint),
      ]);

  Widget _recentUpdates() {
    final recent = _sortedForMarket(sampleCommodities).take(5).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Recent market updates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink)),
      const SizedBox(height: 10),
      Card(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recent.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final item = recent[index];
            final price = item.priceFor(_marketName);
            final color = price.isIncreasing ? AppColors.positive : (price.isDecreasing ? AppColors.negative : AppColors.muted);
            return ListTile(
              dense: true,
              leading: CircleAvatar(radius: 17, backgroundColor: const Color(0xFFEAF2E8), child: Icon(item.icon, size: 16, color: AppColors.forest)),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              subtitle: Text('Updated ${_sampleUpdateTime(index)}', style: const TextStyle(fontSize: 11)),
              trailing: Text('${price.changePercent > 0 ? '+' : ''}${price.changePercent.toStringAsFixed(1)}%', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
              onTap: () => _openDetails(item),
            );
          },
        ),
      ),
    ]);
  }

  Widget _commodityGrid(List<Commodity> items, AppBreakpoint breakpoint) => LayoutBuilder(builder: (context, constraints) {
        final columns = breakpoint == AppBreakpoint.desktop ? (constraints.maxWidth >= 850 ? 3 : 2) : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 14, mainAxisSpacing: 14, mainAxisExtent: 230),
          itemBuilder: (context, index) => _commodityCard(items[index]),
        );
      });

  Widget _commodityList(List<Commodity> items) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _commodityCard(items[index])),
      );

  Widget _commodityCard(Commodity commodity) => CommodityCard(
        commodity: commodity,
        marketName: _marketName,
        isFavorite: _favoriteIds.contains(commodity.id),
        onTap: () => _openDetails(commodity),
        onFavoriteTap: () => _toggleFavorite(commodity),
      );

  Widget _buildPageHeading({required String title, required String subtitle}) => LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 600;
        final titleColumn = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: narrow ? 24 : 29, fontWeight: FontWeight.w800, letterSpacing: -.4, color: AppColors.ink)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        ]);
        final picker = SizedBox(width: narrow ? double.infinity : 245, child: _MarketPicker(value: _marketName, onChanged: _setMarket));
        if (narrow) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleColumn, const SizedBox(height: 15), picker]);
        return Row(children: [Expanded(child: titleColumn), picker]);
      });

  List<Commodity> _sortedForMarket(List<Commodity> source) {
    final copy = source.toList();
    copy.sort((a, b) => b.priceFor(_marketName).modal.compareTo(a.priceFor(_marketName).modal));
    return copy;
  }

  static const _sortOptions = ['Price: Low to High', 'Price: High to Low', 'Name: A to Z', 'Highest Price Increase', 'Highest Price Decrease'];
  String _sampleUpdateTime(int index) => ['10:30 AM', '10:15 AM', '10:05 AM', '09:50 AM', '09:35 AM'][index % 5];
}

class _MarketPicker extends StatelessWidget {
  const _MarketPicker({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined), labelText: 'Market'),
        items: sampleMarkets.map((market) => DropdownMenuItem(value: market.name, child: Text('${market.name} · ${market.region}', overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (next) { if (next != null) onChanged(next); },
      );
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.marketName, required this.isMobile});
  final String marketName;
  final bool isMobile;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        decoration: BoxDecoration(color: const Color(0xFFE8F0E4), borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(.82), borderRadius: BorderRadius.circular(20)), child: const Text('SAMPLE MARKET SNAPSHOT', style: TextStyle(fontSize: 10, letterSpacing: .6, color: AppColors.forest, fontWeight: FontWeight.w800))),
            const SizedBox(height: 12),
            Text('Good morning, farmer', style: TextStyle(fontSize: isMobile ? 22 : 28, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text('Explore indicative commodity rates from $marketName and nearby trading centres.', style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.45)),
          ])),
          if (!isMobile) ...[const SizedBox(width: 20), Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white.withOpacity(.8), shape: BoxShape.circle), child: const Icon(Icons.eco_outlined, size: 37, color: AppColors.forest))],
        ]),
      );
}

class _SdgPanel extends StatelessWidget {
  const _SdgPanel();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFEAF2E8), borderRadius: BorderRadius.circular(16)),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.public, size: 19, color: AppColors.forest),
          SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Sustainable Development Goals · SDG 2: Zero Hunger', style: TextStyle(color: AppColors.forest, fontWeight: FontWeight.w800, fontSize: 12)),
            SizedBox(height: 5),
            Text('Accessible agricultural price information can help farmers compare selling options and understand local markets. This learning project demonstrates the idea; it does not measure real-world impact.', style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.45)),
          ])),
        ]),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message, this.onClear});
  final String title;
  final String message;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          child: Center(child: Column(children: [
            const Icon(Icons.search_off, size: 38, color: AppColors.muted),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 5),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            if (onClear != null) TextButton(onPressed: onClear, child: const Text('Clear search and category')),
          ])),
        ),
      );
}

class _SampleNotice extends StatelessWidget {
  const _SampleNotice();
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xFFFFF4DE), borderRadius: BorderRadius.circular(13)),
        child: const Row(children: [
          Icon(Icons.info_outline, color: AppColors.amber, size: 18),
          SizedBox(width: 9),
          Expanded(child: Text('Demonstration values only — prices are not live government market rates.', style: TextStyle(fontSize: 12, color: Color(0xFF705426)))),
        ]),
      );
}

class _Overline extends StatelessWidget {
  const _Overline(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w800, letterSpacing: .6));
}

