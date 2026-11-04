import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum BoardSection { overview, commodities, favourites }

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key, required this.selected, required this.onSelected});
  final BoardSection selected;
  final ValueChanged<BoardSection> onSelected;

  @override
  Widget build(BuildContext context) => Container(
        width: 236,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 22, 12, 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 6, 24),
            child: Row(children: [
              Icon(Icons.agriculture, color: AppColors.forest, size: 27),
              SizedBox(width: 10),
              Expanded(child: Text('Market Board', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.ink, fontSize: 16))),
            ]),
          ),
          _SidebarItem(icon: Icons.space_dashboard_outlined, label: 'Overview', section: BoardSection.overview, selected: selected, onSelected: onSelected),
          _SidebarItem(icon: Icons.inventory_2_outlined, label: 'Commodities', section: BoardSection.commodities, selected: selected, onSelected: onSelected),
          _SidebarItem(icon: Icons.favorite_border, label: 'Favourites', section: BoardSection.favourites, selected: selected, onSelected: onSelected),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: const Color(0xFFF0F5EF), borderRadius: BorderRadius.circular(14)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.eco_outlined, color: AppColors.forest, size: 19),
              SizedBox(height: 7),
              Text('Market information for stronger food systems.', style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.muted)),
            ]),
          ),
        ]),
      );
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.icon, required this.label, required this.section, required this.selected, required this.onSelected});
  final IconData icon;
  final String label;
  final BoardSection section;
  final BoardSection selected;
  final ValueChanged<BoardSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final active = selected == section;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        selected: active,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selectedTileColor: const Color(0xFFEAF2E8),
        leading: Icon(icon, color: active ? AppColors.forest : AppColors.muted),
        title: Text(label, style: TextStyle(color: active ? AppColors.forest : AppColors.ink, fontWeight: active ? FontWeight.w700 : FontWeight.w500, fontSize: 13)),
        onTap: () => onSelected(section),
      ),
    );
  }
}
