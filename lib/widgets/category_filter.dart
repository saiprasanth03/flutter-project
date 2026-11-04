import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key, required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: commodityCategories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = commodityCategories[index];
            return ChoiceChip(label: Text(category), selected: selected == category, onSelected: (_) => onSelected(category));
          },
        ),
      );
}
