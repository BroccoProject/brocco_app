import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/profile/viewmodels/profile_viewmodel.dart';

class StarsPill extends ConsumerWidget {
  final int? initialCount;

  const StarsPill({super.key, this.initialCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileLogicProvider);
    final count = profileAsync.valueOrNull?.starsBank ?? initialCount ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryOrange, width: 2.1),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: AppColors.darkOrange,
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: AppColors.primaryOrange,
            size: 27,
          ),
          const SizedBox(width: 7),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
