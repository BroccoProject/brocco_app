import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/pushable_3d_button.dart';
import '../viewmodels/browser_viewmodel.dart';
import '../../../shared/models/recipe_difficulty.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  int? _maxTime;
  List<String> _selectedDifficulties = [];

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(browserViewModelProvider).filters;
    _maxTime = currentFilters.maxTime;
    _selectedDifficulties = List.from(currentFilters.difficulties);
  }

  void _toggleDifficulty(String level) {
    setState(() {
      if (_selectedDifficulties.contains(level)) {
        _selectedDifficulties.remove(level);
      } else {
        _selectedDifficulties.add(level);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: AppColors.accentGreen, width: 3),
          left: BorderSide(color: AppColors.accentGreen, width: 3),
          right: BorderSide(color: AppColors.accentGreen, width: 3),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Filtruj przepisy',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 32),
          
          _buildSectionTitle('Maksymalny czas (min)'),
          const SizedBox(height: 16),
          _buildTimeSlider(),
          const SizedBox(height: 32),
          
          _buildSectionTitle('Poziom trudności'),
          const SizedBox(height: 16),
          _buildDifficultyOptions(),
          const SizedBox(height: 48),
          
          SizedBox(
            width: double.infinity,
            child: Pushable3DButton(
              onPressed: () {
                ref.read(browserViewModelProvider.notifier).applyFilters(
                      BrowserFilterCriteria(
                        maxTime: _maxTime,
                        difficulties: _selectedDifficulties,
                      ),
                    );
                Navigator.pop(context);
              },
              backgroundColor: AppColors.primaryOrange,
              shadowColor: AppColors.darkOrange,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: Text(
                  'Zastosuj filtry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildTimeSlider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bez limitu', style: TextStyle(fontSize: 12, color: AppColors.greyText)),
                Text('${_maxTime ?? 120} min', 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentGreen)
                ),
              ],
            ),
            Slider(
              value: (_maxTime ?? 120).toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              activeColor: AppColors.accentGreen,
              inactiveColor: AppColors.accentGreen.withValues(alpha: 0.1),
              onChanged: (val) {
                setState(() => _maxTime = val.toInt() == 120 ? null : val.toInt());
              },
            ),
          ],
        ));
  }

  Widget _buildDifficultyOptions() {
    return Row(
      children: RecipeDifficulty.values.map((diff) {
        final id = diff.dbValue;
        final label = diff.label;
        final isSelected = _selectedDifficulties.contains(id);
        return Expanded(
          child: GestureDetector(
            onTap: () => _toggleDifficulty(id),
            child: Container(
              margin: EdgeInsets.only(
                right: diff == RecipeDifficulty.masterChef ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentGreen : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.accentGreen,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryText,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
