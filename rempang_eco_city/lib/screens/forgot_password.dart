import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lupa Password',
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reset Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Masukkan email untuk reset password',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 28),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.iconGrey),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link reset dikirim ke email')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Kirim Link Reset'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}