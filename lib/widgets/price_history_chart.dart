import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PriceHistoryChart extends StatelessWidget {
  const PriceHistoryChart({super.key, required this.values, required this.isPositive});
  final List<double> values;
  final bool isPositive;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 190,
        width: double.infinity,
        child: CustomPaint(painter: _PriceHistoryPainter(values: values, color: isPositive ? AppColors.positive : AppColors.negative)),
      );
}

class _PriceHistoryPainter extends CustomPainter {
  const _PriceHistoryPainter({required this.values, required this.color});
  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.isEmpty) return;
    const horizontalInset = 8.0;
    const verticalInset = 12.0;
    final chartWidth = size.width - horizontalInset * 2;
    final chartHeight = size.height - verticalInset * 2;
    final low = values.reduce((a, b) => a < b ? a : b);
    final high = values.reduce((a, b) => a > b ? a : b);
    final range = (high - low).abs() < 1 ? 1.0 : (high - low);
    final yFor = (double value) => verticalInset + chartHeight - ((value - low) / range) * chartHeight;

    final gridPaint = Paint()..color = AppColors.border..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = verticalInset + chartHeight * i / 3;
      canvas.drawLine(Offset(horizontalInset, y), Offset(size.width - horizontalInset, y), gridPaint);
    }

    final points = List<Offset>.generate(values.length, (index) {
      final x = horizontalInset + chartWidth * index / (values.length - 1);
      return Offset(x, yFor(values[index]));
    });
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      linePath.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height - verticalInset)
      ..lineTo(points.first.dx, size.height - verticalInset)
      ..close();
    canvas.drawPath(fillPath, Paint()..shader = LinearGradient(colors: [color.withOpacity(.19), color.withOpacity(.01)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Offset.zero & size));
    canvas.drawPath(linePath, Paint()..color = color..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    for (final point in points) {
      canvas.drawCircle(point, 4, Paint()..color = Colors.white);
      canvas.drawCircle(point, 3, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _PriceHistoryPainter oldDelegate) => oldDelegate.values != values || oldDelegate.color != color;
}
