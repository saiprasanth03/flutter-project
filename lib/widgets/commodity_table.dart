import 'package:flutter/material.dart';
import '../models/commodity.dart';
import '../utils/app_colors.dart';
import 'commodity_card.dart';

class CommodityTable extends StatelessWidget {
  const CommodityTable({super.key, required this.commodities, required this.marketName, required this.favorites, required this.onOpen, required this.onFavorite});

  final List<Commodity> commodities;
  final String marketName;
  final Set<String> favorites;
  final ValueChanged<Commodity> onOpen;
  final ValueChanged<Commodity> onFavorite;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAF7)),
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('COMMODITY')),
              DataColumn(label: Text('CATEGORY')),
              DataColumn(label: Text('MIN / MAX'), numeric: true),
              DataColumn(label: Text('MODAL PRICE'), numeric: true),
              DataColumn(label: Text('CHANGE')),
              DataColumn(label: Text('FAVOURITE')),
            ],
            rows: commodities.map((commodity) {
              final price = commodity.priceFor(marketName);
              final up = price.isIncreasing;
              final down = price.isDecreasing;
              final trendColor = up ? AppColors.positive : (down ? AppColors.negative : AppColors.muted);
              return DataRow(
                onSelectChanged: (_) => onOpen(commodity),
                cells: [
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(radius: 17, backgroundColor: const Color(0xFFEAF2E8), child: Icon(commodity.icon, size: 17, color: AppColors.forest)),
                    const SizedBox(width: 10),
                    Text(commodity.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ])),
                  DataCell(Text(commodity.category)),
                  DataCell(Text('${formatRupees(price.minimum)} / ${formatRupees(price.maximum)}')),
                  DataCell(Text('${formatRupees(price.modal)} / qtl', style: const TextStyle(fontWeight: FontWeight.w700))),
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(up ? Icons.trending_up : (down ? Icons.trending_down : Icons.trending_flat), size: 17, color: trendColor),
                    const SizedBox(width: 4),
                    Text('${price.changePercent > 0 ? '+' : ''}${price.changePercent.toStringAsFixed(1)}%', style: TextStyle(color: trendColor, fontWeight: FontWeight.w700)),
                  ])),
                  DataCell(IconButton(
                    tooltip: favorites.contains(commodity.id) ? 'Remove from favourites' : 'Add to favourites',
                    onPressed: () => onFavorite(commodity),
                    icon: Icon(favorites.contains(commodity.id) ? Icons.favorite : Icons.favorite_border, color: favorites.contains(commodity.id) ? AppColors.negative : AppColors.muted),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      );
}
