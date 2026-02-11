import 'package:flutter/material.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onTwitterTap;
  final VoidCallback? onAppleTap;

  const SocialLoginRow({
    super.key,
    this.onGoogleTap,
    this.onFacebookTap,
    this.onTwitterTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(Icons.facebook, Colors.blue[800], onFacebookTap),
        const SizedBox(width: 20),
        _buildSocialButton(
          Icons.flutter_dash,
          Colors.lightBlue,
          onTwitterTap,
        ), // Placeholder for Twitter
        const SizedBox(width: 20),
        _buildSocialButton(
          Icons.g_mobiledata,
          Colors.red,
          onGoogleTap,
        ), // Placeholder for Google
        const SizedBox(width: 20),
        _buildSocialButton(Icons.apple, Colors.black, onAppleTap),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color? color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
