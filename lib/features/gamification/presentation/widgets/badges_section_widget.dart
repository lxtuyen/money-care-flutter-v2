import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/features/gamification/domain/entities/gamification_entity.dart';
import 'package:money_care/features/gamification/presentation/controllers/gamification_controller.dart';

class BadgesSectionWidget extends StatelessWidget {
  const BadgesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GamificationController? controller =
        Get.isRegistered<GamificationController>()
        ? Get.find<GamificationController>()
        : null;

    if (controller == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Huy hiệu đạt được',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final badges = controller.badges;

          if (badges.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text('🏅', style: TextStyle(fontSize: 32)),
                  SizedBox(height: 8),
                  Text(
                    'Chưa có huy hiệu nào',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.text4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ghi chép đều đặn để nhận huy hiệu!',
                    style: TextStyle(fontSize: 12, color: AppColors.text5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: badges.map((badge) => _BadgeChip(badge: badge)).toList(),
          );
        }),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final BadgeEntity badge;

  const _BadgeChip({required this.badge});

  String get _icon {
    switch (badge.key) {
      case BadgeKeys.streak7:
        return '🔥';
      case BadgeKeys.streak30:
        return '⭐';
      case BadgeKeys.goalCompleted:
        return '🏆';
      default:
        return '🏅';
    }
  }

  Color get _color {
    switch (badge.key) {
      case BadgeKeys.streak7:
        return AppColors.warning;
      case BadgeKeys.streak30:
        return AppColors.primary;
      case BadgeKeys.goalCompleted:
        return AppColors.success;
      default:
        return AppColors.text4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withOpacity(0.35), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            _formatDate(badge.awardedAt),
            style: const TextStyle(fontSize: 10, color: AppColors.text5),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }
}
