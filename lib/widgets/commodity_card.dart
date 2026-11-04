import 'package:flutter/material.dart';
import '../models/commodity.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';

class CommodityCard extends StatelessWidget {
  const CommodityCard({super.key, required this.commodity, required this.marketName, required this.isFavorite, required this.onTap, required this.onFavoriteTap});

  final Commodity commodity;
  final String marketName;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final price = commodity.priceFor(marketName);
    final trendColor = price.isIncreasing ? AppColors.positive : (price.isDecreasing ? AppColors.negative : AppColors.muted);
    final trendIcon = price.isIncreasing ? Icons.trending_up : (price.isDecreasing ? Icons.trending_down : Icons.trending_flat);
    final changeText = '${price.changePercent > 0 ? '+' : ''}${price.changePercent.toStringAsFixed(1)}%';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: const Color(0xFFEAF2E8), borderRadius: BorderRadius.circular(13)),
                child: Icon(commodity.icon, color: AppColors.forest, size: 22),
              ),
              const SizedBox(width: 11),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(commodity.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 3),
                Text(commodity.category, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ])),
              IconButton(
                tooltip: isFavorite ? 'Remove from favourites' : 'Add to favourites',
                onPressed: onFavoriteTap,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? AppColors.negative : AppColors.muted),
              ),
            ]),
            const SizedBox(height: 17),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Modal price', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                const SizedBox(height: 3),
                Text(formatRupees(price.modal), style: const TextStyle(color: AppColors.ink, fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -.5)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(color: trendColor.withOpacity(.1), borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(trendIcon, size: 15, color: trendColor), const SizedBox(width: 3), Text(changeText, style: TextStyle(color: trendColor, fontSize: 12, fontWeight: FontWeight.w700))]),
              ),
            ]),
            const SizedBox(height: 13),
            Row(children: [
              Expanded(child: Text('Min ${formatRupees(price.minimum)}', style: const TextStyle(color: AppColors.muted, fontSize: 11))),
              Expanded(child: Text('Max ${formatRupees(price.maximum)}', textAlign: TextAlign.end, style: const TextStyle(color: AppColors.muted, fontSize: 11))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(child: Text(marketName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11))),
              Text('per ${price.unit}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            ]),
          ]),
        ),
      ),
    );
  }
}
