import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, required this.padding});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Padding(padding: padding, child: child),
        ),
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: AppTheme.muted,
          fontWeight: FontWeight.w700,
          letterSpacing: .3,
        ),
      );
}
