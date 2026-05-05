import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CategoryChipWidget extends StatelessWidget {
  final String label;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.label,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  static final Map<String, IconData> _icons = {
    'all': Icons.grid_view_rounded,
    'electronics': Icons.devices_rounded,
    'fashion': Icons.checkroom_rounded,
    'sports': Icons.sports_soccer_rounded,
    'home': Icons.home_rounded,
    'beauty': Icons.face_retouching_natural,
    'books': Icons.menu_book_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[iconName] ?? Icons.category_rounded;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
