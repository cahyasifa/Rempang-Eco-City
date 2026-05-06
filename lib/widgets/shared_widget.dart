import 'package:flutter/material.dart';
import 'package:rempang_eco_city/theme/app_theme.dart';

// --- TAMBAHAN: FUNGSI NAVIGASI GLOBAL ---

Widget buildProdusenNav(BuildContext context, int activeIndex) {
  return BottomNavigationBar(
    currentIndex: activeIndex,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: const Color(0xFF1D9E75), // Warna hijau tema
    unselectedItemColor: Colors.grey,
    selectedFontSize: 10,
    unselectedFontSize: 10,
    onTap: (index) {
      if (index == activeIndex) return;

      // Navigasi menggunakan Named Routes
      if (index == 0) Navigator.pushReplacementNamed(context, '/produsen/dashboard');
      if (index == 1) Navigator.pushReplacementNamed(context, '/produsen/daftar-produksi');
      if (index == 2) Navigator.pushReplacementNamed(context, '/produsen/stok');
      if (index == 3) Navigator.pushReplacementNamed(context, '/produsen/permintaan');
      if (index == 4) Navigator.pushReplacementNamed(context, '/produsen/riwayat');
      
      if (index == 5) {
        // Logika Logout
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Apakah Anda yakin ingin keluar aplikasi?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  // Kembali ke halaman paling awal (Login)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Keluar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Produksi'),
      BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stok'),
      BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Permintaan'),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ],
  );
}

// --- CODINGAN LAMA KAMU (DIPERTAHANKAN) ---

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
    {String? subtitle, bool showBack = false}) {
  return AppBar(
    backgroundColor: const Color(0xFFFDFDFD),
    elevation: 0,
    automaticallyImplyLeading: showBack,
    iconTheme: const IconThemeData(color: Color(0xFF222222)),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222222))),
        if (subtitle != null)
          Text(subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    ),
    toolbarHeight: subtitle != null ? 64 : 56,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0.5),
      child: Container(height: 0.5, color: const Color(0xFFE4E4E4)),
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