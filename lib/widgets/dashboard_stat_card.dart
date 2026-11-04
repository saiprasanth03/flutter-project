import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({super.key, required this.label, required this.value, required this.icon, required this.accent, this.helper});

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final String? helper;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: accent.withOpacity(.11), borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: accent, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 5),
                Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.ink, fontSize: 19, fontWeight: FontWeight.w800)),
                if (helper != null) ...[
                  const SizedBox(height: 2),
                  Text(helper!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
                ],
              ]),
            ),
          ]),
        ),
      );
}
