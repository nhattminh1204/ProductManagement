import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../product_management/presentation/design_system.dart';

class FloatingDock extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final List<IconData> icons;
  final List<String> labels;

  final List<GlobalKey>? itemKeys;

  const FloatingDock({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.icons,
    required this.labels,
    this.itemKeys,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(icons.length, (index) {
                final isSelected = currentIndex == index;
                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[index],
                          key: itemKeys != null && index < itemKeys!.length ? itemKeys![index] : null,
                          color: isSelected ? Colors.white : AppColors.textMain,
                          size: 24,
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Text(
                            labels[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
