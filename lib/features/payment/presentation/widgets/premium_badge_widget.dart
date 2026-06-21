import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

/// Small premium badge shown next to feature titles or on user profile.
class PremiumBadgeWidget extends StatelessWidget {
  final bool mini;

  const PremiumBadgeWidget({super.key, this.mini = false});

  @override
  Widget build(BuildContext context) {
    if (mini) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF71C4FF), Color(0xFF0966A7)],
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'PRO',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'BeVietnamPro',
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF71C4FF), Color(0xFF0966A7)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.crown_1, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Premium',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'BeVietnamPro',
            ),
          ),
        ],
      ),
    );
  }
}
