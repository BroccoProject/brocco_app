import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ConnectorLine extends StatelessWidget {
  final double fromX, fromY, toX, toY;
  final bool isCompleted;

  const ConnectorLine({
    super.key,
    required this.fromX,
    required this.fromY,
    required this.toX,
    required this.toY,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _LinePainter(
        from: Offset(fromX, fromY),
        to: Offset(toX, toY),
        color: isCompleted
            ? AppColors.accentGreen
            : AppColors.accentGreen.withValues(alpha: 0.35),
        strokeWidth: isCompleted ? 6 : 4,
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final Color color;
  final double strokeWidth;

  _LinePainter({
    required this.from,
    required this.to,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final random = Random((from.dx * 100 + from.dy * 10 + to.dx + to.dy).toInt());
    
    final dist = (to - from).distance;
    final noiseAmount = dist * 0.2; 
    
    final dyOffset1 = (random.nextDouble() - 0.5) * noiseAmount;
    final dyOffset2 = (random.nextDouble() - 0.5) * noiseAmount;
    final dxOffset1 = (random.nextDouble() - 0.5) * noiseAmount * 0.5;
    final dxOffset2 = (random.nextDouble() - 0.5) * noiseAmount * 0.5;

    final midX = (from.dx + to.dx) / 2;
    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..cubicTo(
        midX + dxOffset1, from.dy + dyOffset1, 
        midX + dxOffset2, to.dy + dyOffset2, 
        to.dx, to.dy
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) =>
      from != oldDelegate.from ||
      to != oldDelegate.to ||
      color != oldDelegate.color;
}
