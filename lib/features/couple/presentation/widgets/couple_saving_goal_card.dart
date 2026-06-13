import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/couple/presentation/controllers/couple_controller.dart';
import 'package:money_care/features/couple/domain/entities/couple_saving_goal_entity.dart';
import 'package:money_care/core/constants/route_path.dart';

class CoupleSavingGoalCard extends StatefulWidget {
  final CoupleSavingGoalEntity goal;
  final CoupleController controller;

  const CoupleSavingGoalCard({
    super.key,
    required this.goal,
    required this.controller,
  });

  @override
  State<CoupleSavingGoalCard> createState() => _CoupleSavingGoalCardState();
}

class _CoupleSavingGoalCardState extends State<CoupleSavingGoalCard> {
  /// Tracks which member userId is currently expanded.
  final Set<int> _expandedMembers = {};

  /// Max transactions shown per member before "Xem thêm".
  static const int _maxVisibleTransactions = 5;

  CoupleSavingGoalEntity get goal => widget.goal;
  CoupleController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final progress = goal.target > 0
        ? (goal.savedAmount / goal.target).clamp(0.0, 1.0)
        : 0.0;
    final isCompleted =
        goal.status == 'completed' || goal.savedAmount >= goal.target;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name & Status & Delete
            _buildHeader(theme, primaryColor, isCompleted),
            const Divider(height: 20),

            // Progress Text
            _buildProgress(primaryColor, progress, isCompleted),

            const SizedBox(height: 16),

            // Member Breakdown with accordion
            _buildMemberSection(primaryColor),

            const SizedBox(height: 16),

            // Action Button
            _buildContributeButton(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    Color primaryColor,
    bool isCompleted,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.name.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.green : Colors.black87,
                ),
              ),
              if (goal.endDate != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Hạn chót: ${DateFormat('dd/MM/yyyy').format(goal.endDate!)}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Row(
          children: [
            if (isCompleted) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Hoàn thành',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Colors.grey[600],
                size: 20,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  Get.toNamed(
                    RoutePath.createSavingGoal,
                    arguments: {'isCouple': true, 'goal': goal},
                  );
                } else if (value == 'delete') {
                  _confirmDeleteGoal(context, goal);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Chỉnh sửa'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('Xóa', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgress(Color primaryColor, double progress, bool isCompleted) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đã tích lũy: ${AppHelperFunction.formatAmount(goal.savedAmount)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              'Mục tiêu: ${AppHelperFunction.formatAmount(goal.target)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? Colors.green : primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Đạt ${(progress * 100).toStringAsFixed(1)}% mục tiêu',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ĐÓNG GÓP CỦA TỪNG NGƯỜI',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        ...goal.memberContributions.map((member) {
          final isExpanded = _expandedMembers.contains(member.userId);
          final memberTransactions = goal.contributions
              .where((c) => c.userId == member.userId)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final hasTransactions = memberTransactions.isNotEmpty;

          return Column(
            children: [
              // Member header row (tappable)
              InkWell(
                onTap: hasTransactions
                    ? () => setState(() {
                          if (isExpanded) {
                            _expandedMembers.remove(member.userId);
                          } else {
                            _expandedMembers.add(member.userId);
                          }
                        })
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            primaryColor.withValues(alpha: 0.1),
                        child: Text(
                          member.fullName.isNotEmpty
                              ? member.fullName[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            fontSize: 9,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          member.fullName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        AppHelperFunction.formatAmount(member.amount),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasTransactions) ...[
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Expandable transaction list
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildMemberTransactions(
                  memberTransactions,
                  primaryColor,
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildMemberTransactions(
    List<CoupleSavingGoalContribution> transactions,
    Color primaryColor,
  ) {
    final showAll = transactions.length <= _maxVisibleTransactions;
    final visible =
        showAll ? transactions : transactions.take(_maxVisibleTransactions).toList();
    final remaining = transactions.length - _maxVisibleTransactions;

    return Container(
      margin: const EdgeInsets.only(left: 28, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          ...visible.map(
            (tx) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 14,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Text(
                    '+${AppHelperFunction.formatAmount(tx.amount)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!showAll)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: InkWell(
                onTap: () {
                  // TODO: navigate to full transaction list if needed
                },
                child: Text(
                  'Xem thêm $remaining giao dịch...',
                  style: TextStyle(
                    fontSize: 11,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContributeButton(Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor.withValues(alpha: 0.1),
          foregroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
        label: const Text(
          'Đóng Góp Quỹ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        onPressed: () => Get.toNamed(
          RoutePath.walletTransfer,
          arguments: {
            'toWalletId': goal.walletId,
            'lockToWallet': true,
          },
        ),
      ),
    );
  }

  void _confirmDeleteGoal(BuildContext context, CoupleSavingGoalEntity goal) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Xóa Quỹ Tiết Kiệm Chung'),
          content: Text(
            'Bạn có chắc chắn muốn xóa quỹ "${goal.name}"? Dữ liệu đóng góp và ví tiết kiệm sẽ bị xóa vĩnh viễn.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteSharedSavingGoal(goal.id);
                Navigator.of(ctx).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
