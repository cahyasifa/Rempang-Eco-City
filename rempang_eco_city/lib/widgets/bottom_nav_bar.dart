import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, index: 0, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.shopping_cart_outlined, index: 1, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.list_alt_outlined, index: 2, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.history_outlined, index: 3, currentIndex: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_outline_rounded, index: 4, currentIndex: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({required this.icon, required this.index, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool selected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? AppColors.bgSecondary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: selected ? AppColors.blue : AppColors.iconGrey, size: 24),
      ),
    );
  }
}