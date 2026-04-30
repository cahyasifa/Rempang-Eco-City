import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────
// PRODUSEN WIDGETS (tidak diubah sama sekali)
// ─────────────────────────────────────────────

enum BadgeType { green, amber, red, blue }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  const StatusBadge(this.label, {super.key, this.type = BadgeType.green});

  @override
  Widget build(BuildContext context) {
    final bg = {
      BadgeType.green: AppColors.badgeGreenBg,
      BadgeType.amber: AppColors.badgeAmberBg,
      BadgeType.red:   AppColors.badgeRedBg,
      BadgeType.blue:  AppColors.badgeBlueBg,
    }[type]!;
    final fg = {
      BadgeType.green: AppColors.badgeGreenText,
      BadgeType.amber: AppColors.badgeAmberText,
      BadgeType.red:   AppColors.badgeRedText,
      BadgeType.blue:  AppColors.badgeBlueText,
    }[type]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double opacity;
  const AppCard({super.key, required this.child, this.padding, this.opacity = 1.0});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderCard, width: 0.5),
        ),
        child: child,
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final bool accent;
  final Color? valueColor;
  const MetricCard({super.key, required this.label, required this.value, this.unit, this.accent = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: accent ? AppColors.metricAccentBg : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: accent ? AppColors.metricAccentBorder : AppColors.borderCard,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? (accent ? AppColors.textSuccess : AppColors.textPrimary),
                ),
                children: unit != null
                    ? [TextSpan(text: ' $unit', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.normal))]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const CategoryChip(this.label, {super.key, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.chipActive : AppColors.chipDefault,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.chipActiveText : AppColors.chipDefaultText,
          ),
        ),
      ),
    );
  }
}

class StokBarRow extends StatelessWidget {
  final String name, date, amount;
  final double ratio;
  final BadgeType badgeType;
  final Color barColor;
  const StokBarRow({super.key, required this.name, required this.date, required this.amount, required this.ratio, required this.badgeType, required this.barColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
            StatusBadge(amount, type: badgeType),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: const Color(0xFFEAEAEA),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      const Divider(color: AppColors.divider, thickness: 0.5, height: 1);
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const PrimaryButton(this.label, {super.key, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class OutlineButton2 extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const OutlineButton2(this.label, {super.key, this.color = AppColors.primary, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

PreferredSizeWidget buildAppBar(String title,
    {String? subtitle, bool showBack = false, BuildContext? context}) {
  return AppBar(
    backgroundColor: AppColors.appBar,
    elevation: 0,
    automaticallyImplyLeading: showBack,
    iconTheme: const IconThemeData(color: AppColors.appBarText),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.appBarText)),
        if (subtitle != null)
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    ),
    toolbarHeight: subtitle != null ? 64 : 56,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0.5),
      child: Container(height: 0.5, color: AppColors.divider),
    ),
  );
}

InputDecoration fieldDeco(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.bgWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderInput, width: 0.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderInput, width: 0.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.textDanger, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.textDanger, width: 1.5)),
    );

Widget fieldLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
    );

// ─────────────────────────────────────────────
// ADMIN WIDGETS (tambahan, khusus web)
// ─────────────────────────────────────────────

/// Badge untuk halaman admin. Terpisah dari [StatusBadge] milik produsen
/// agar tidak saling bergantung dan enum-nya tidak tabrakan.
enum AdminBadgeType { success, warning, danger, info, neutral }

class AdminBadge extends StatelessWidget {
  final String label;
  final AdminBadgeType type;
  const AdminBadge({super.key, required this.label, this.type = AdminBadgeType.neutral});

  @override
  Widget build(BuildContext context) {
    final bg = {
      AdminBadgeType.success: AppColors.adminSuccessSurface,
      AdminBadgeType.warning: AppColors.adminWarningSurface,
      AdminBadgeType.danger:  AppColors.adminDangerSurface,
      AdminBadgeType.info:    AppColors.adminInfoSurface,
      AdminBadgeType.neutral: const Color(0xFFF3F4F6),
    }[type]!;
    final fg = {
      AdminBadgeType.success: AppColors.adminSuccess,
      AdminBadgeType.warning: AppColors.adminWarning,
      AdminBadgeType.danger:  AppColors.adminDanger,
      AdminBadgeType.info:    AppColors.adminInfo,
      AdminBadgeType.neutral: AppColors.adminTextSecondary,
    }[type]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

/// Card standar untuk halaman admin (web), berbeda dari [AppCard] produsen
/// karena menggunakan warna & shadow yang sesuai tampilan web.
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const AdminCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.adminSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.adminBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Stat card untuk dashboard admin — menampilkan angka ringkasan
/// dengan ikon di sebelah kiri.
class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12, color: AppColors.adminTextSecondary)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.adminTextPrimary)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: const TextStyle(fontSize: 11, color: AppColors.adminTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// InputDecoration khusus admin (web) — sedikit berbeda dari [fieldDeco]
/// produsen dalam hal warna fill dan ukuran padding.
InputDecoration adminFieldDeco(String label, {String? hint, Widget? suffixIcon}) =>
    InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.adminTextSecondary),
      filled: true,
      fillColor: AppColors.adminBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.adminBorder)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.adminBorder)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.adminPrimary, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.adminDanger, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.adminDanger, width: 1.5)),
    );

/// Tombol utama admin — ukuran dan style disesuaikan untuk tampilan web.
class AdminPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  const AdminPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.adminPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      child: isLoading
          ? const SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 8)],
                Text(label),
              ],
            ),
    );
  }
}

/// Header baris tabel admin yang konsisten — dipakai di semua screen tabel.
class AdminTableHeader extends StatelessWidget {
  final List<_AdminTableCol> columns;
  const AdminTableHeader({super.key, required this.columns});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.adminBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: columns.map((col) {
          final text = Text(
            col.label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.adminTextSecondary),
          );
          return col.width != null
              ? SizedBox(width: col.width, child: text)
              : Expanded(flex: col.flex ?? 1, child: text);
        }).toList(),
      ),
    );
  }
}

/// Dipakai bersama [AdminTableHeader] untuk mendefinisikan kolom.
class _AdminTableCol {
  final String label;
  final double? width;
  final int? flex;
  const _AdminTableCol(this.label, {this.width, this.flex});
}

/// Helper untuk membuat list kolom tabel admin dengan lebih ringkas.
/// Contoh: AdminTableHeader(columns: adminCols([('Nama', null, 2), ('Status', 80, null)]))
List<_AdminTableCol> adminCols(List<(String, double?, int?)> defs) =>
    defs.map((d) => _AdminTableCol(d.$1, width: d.$2, flex: d.$3)).toList();

/// Baris info dua kolom (label — value) untuk dialog detail.
/// Dipakai di TransaksiDetailDialog, KonfirmasiPembayaranDialog, dll.
class AdminInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  const AdminInfoRow(this.label, this.value,
      {super.key, this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.adminTextSecondary))),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                      color: valueColor ?? AppColors.adminTextPrimary))),
        ],
      ),
    );
  }
}