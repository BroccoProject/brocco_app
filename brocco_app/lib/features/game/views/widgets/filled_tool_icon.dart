import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class FilledToolIcon extends StatelessWidget {
  final String svgPath;
  final double fillFraction; // Base fill (e.g. ingredients)
  final double timerFillFraction; // Secondary fill (e.g. timer)
  final Color fillColor; 
  final Color timerFillColor;

  const FilledToolIcon({
    super.key,
    required this.svgPath,
    required this.fillFraction,
    this.timerFillFraction = 0.0,
    this.fillColor = AppColors.primaryText,
    this.timerFillColor = AppColors.primaryText,
  });

  @override
  Widget build(BuildContext context) {
    final baseFilled = fillFraction.clamp(0.0, 1.0);
    final timerFilled = timerFillFraction.clamp(0.0, 1.0);
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 120,
            height: 120,
            colorFilter: ColorFilter.mode(
              AppColors.primaryText.withValues(alpha: 0.15),
              BlendMode.srcIn,
            ),
          ),
          // Base filled layer
          ClipRect(
            clipper: _BottomFillClipper(baseFilled),
            child: SvgPicture.asset(
              svgPath,
              width: 120,
              height: 120,
              colorFilter: ColorFilter.mode(
                fillColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          // Secondary filled layer
          if (timerFilled > 0.0)
            ClipRect(
              clipper: _BottomFillClipper(timerFilled),
              child: SvgPicture.asset(
                svgPath,
                width: 120,
                height: 120,
                colorFilter: ColorFilter.mode(
                  timerFillColor,
                  BlendMode.srcIn,
                ),
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
