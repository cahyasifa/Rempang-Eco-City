import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BadgeType { green, red, amber }

// ================= APP BAR =================
PreferredSizeWidget buildAppBar(String title, {String? subtitle}) {
  return AppBar(
    backgroundColor: AppColors.appBar,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.appBarText)),
        if (subtitle != null)
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
      ],
    ),
    toolbarHeight: 64,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0.5),
      child: Container(height: 0.5, color: AppColors.divider),
    ),
  );
}

// ================= CARD =================
class AppCard extends StatelessWidget {
  final Widget child;
  final double opacity;

  const AppCard({super.key, required this.child, this.opacity = 1.0});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: child,
      ),
    );
  }
}

// ================= DIVIDER =================
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: AppColors.divider);
  }
}

// ================= CHIP =================
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryChip(this.label,
      {super.key, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.chipActive : AppColors.chipDefault,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? AppColors.chipActiveText
                  : AppColors.chipDefaultText,
            )),
      ),
    );
  }
}

// ================= BADGE =================
class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;

  const StatusBadge(this.text, {super.key, required this.type});

  Color get bg {
    switch (type) {
      case BadgeType.green: return AppColors.badgeGreenBg;
      case BadgeType.red:   return AppColors.badgeRedBg;
      case BadgeType.amber: return AppColors.badgeAmberBg;
    }
  }

  Color get textColor {
    switch (type) {
      case BadgeType.green: return AppColors.badgeGreenText;
      case BadgeType.red:   return AppColors.badgeRedText;
      case BadgeType.amber: return AppColors.badgeAmberText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w600)),
    );
  }
}

// ================= METRIC CARD =================
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final bool accent;
  final Color? valueColor;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.accent = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = unit != null ? '$value $unit' : value;
    return Expanded(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text(displayValue,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ??
                      (accent ? AppColors.primary : AppColors.textPrimary),
                )),
          ],
        ),
      ),
    );
  }
}

// ================= PRIMARY BUTTON =================
class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

  const PrimaryButton(this.text,
      {super.key, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon ?? Icons.add, size: 16),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

// ================= OUTLINE BUTTON 2 =================
class OutlineButton2 extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const OutlineButton2(this.label,
      {super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: color)),
      ),
    );
  }
}

// ================= FIELD LABEL =================
Widget fieldLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary)),
  );
}

// ================= FIELD DECORATION =================
InputDecoration fieldDeco(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle:
        const TextStyle(fontSize: 13, color: AppColors.textSecondary),
    filled: true,
    fillColor: AppColors.bgCard,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.borderInput, width: 0.5)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.borderInput, width: 0.5)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.textDanger, width: 1)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: AppColors.textDanger, width: 1.5)),
  );
}