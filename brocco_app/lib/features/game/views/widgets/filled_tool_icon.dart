import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilledToolIcon extends StatelessWidget {
  final IconData icon;
  final double fillFraction;

  const FilledToolIcon({
    super.key,
    required this.icon,
    required this.fillFraction,
  });

  @override
  Widget build(BuildContext context) {
    final filled = fillFraction.clamp(0.0, 1.0);
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 120, color: AppColors.primaryText.withOpacity(0.15)),
          ClipRect(
            clipper: _BottomFillClipper(filled),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.primaryText,
                  AppColors.primaryText.withValues(alpha: 0.8),
                ],
              ).createShader(bounds),
              child: Icon(icon, size: 120, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomFillClipper extends CustomClipper<Rect> {
  final double fill;
  const _BottomFillClipper(this.fill);

  @override
  Rect getClip(Size size) {
    final top = size.height * (1 - fill);
    return Rect.fromLTWH(0, top, size.width, size.height - top);
  }

  @override
  bool shouldReclip(_BottomFillClipper old) => old.fill != fill;
}
