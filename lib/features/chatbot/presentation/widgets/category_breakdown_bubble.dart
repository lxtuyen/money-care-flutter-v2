import 'package:flutter/material.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';
import 'package:money_care/features/chatbot/data/models/category_breakdown_model.dart';

/// Chatbot bubble hiển thị phân tích chi tiết chi tiêu theo từng danh mục.
class CategoryBreakdownBubble extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const CategoryBreakdownBubble({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    final data = CategoryBreakdownModel.fromJson(metadata);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (data.categories.isEmpty) {
      return _EmptyState(isDark: isDark);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(periodLabel: data.periodLabel, isDark: isDark),
            const SizedBox(height: 8),
            ...data.categories.map(
              (cat) => _CategoryCard(category: cat, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final String periodLabel;
  final bool isDark;

  const _HeaderCard({required this.periodLabel, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A2744), const Color(0xFF162038)]
              : [const Color(0xFFE8F0FE), const Color(0xFFD4E4FC)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('📊', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(
            'Chi tiết chi tiêu $periodLabel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A2744),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Card (expandable) ─────────────────────────────────

class _CategoryCard extends StatefulWidget {
  final CategoryBreakdownItem category;
  final bool isDark;

  const _CategoryCard({required this.category, required this.isDark});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isDark = widget.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          // Header row (tap to expand/collapse)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Expand icon
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark
                          ? Colors.white54
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Category icon
                  if (cat.categoryIcon != null &&
                      cat.categoryIcon!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        cat.categoryIcon!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  // Category name
                  Expanded(
                    child: Text(
                      cat.categoryName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  // Total
                  Text(
                    AppHelperFunction.formatAmount(cat.total),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Change badge
                  _ChangeBadge(changePct: cat.changePct, isDark: isDark),
                ],
              ),
            ),
          ),
          // Expanded sub-groups
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _SubGroupList(
              subGroups: cat.subGroups,
              isDark: isDark,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-Group List ─────────────────────────────────────────────

class _SubGroupList extends StatelessWidget {
  final List<SubGroupItem> subGroups;
  final bool isDark;

  const _SubGroupList({required this.subGroups, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFFAFBFC),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.grey.withValues(alpha: 0.12),
          ),
          ...subGroups.map(
            (sg) => _SubGroupRow(subGroup: sg, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _SubGroupRow extends StatefulWidget {
  final SubGroupItem subGroup;
  final bool isDark;

  const _SubGroupRow({required this.subGroup, required this.isDark});

  @override
  State<_SubGroupRow> createState() => _SubGroupRowState();
}

class _SubGroupRowState extends State<_SubGroupRow> {
  bool _showTransactions = false;
  bool _showAll = false;

  static const int _initialCount = 3;

  @override
  Widget build(BuildContext context) {
    final sg = widget.subGroup;
    final isDark = widget.isDark;
    final txs = sg.transactions;
    final hasMore = txs.length > _initialCount;
    final displayTxs = _showAll ? txs : txs.take(_initialCount).toList();

    return Column(
      children: [
        // Main row (tap to show/hide transactions)
        InkWell(
          onTap: txs.isNotEmpty
              ? () => setState(() {
                    _showTransactions = !_showTransactions;
                    if (!_showTransactions) _showAll = false;
                  })
              : null,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: [
                // Row 1: name, count, total
                Row(
                  children: [
                    if (txs.isNotEmpty)
                      AnimatedRotation(
                        turns: _showTransactions ? 0.25 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                      ),
                    if (txs.isNotEmpty) const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        sg.groupName,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.85)
                              : Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${sg.count} lần',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color:
                              isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppHelperFunction.formatAmount(sg.total),
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                // Row 2: avg + change
                Row(
                  children: [
                    Text(
                      '~${AppHelperFunction.formatShortAmount(sg.avgPerTransaction)}/lần',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.grey.shade500,
                      ),
                    ),
                    const Spacer(),
                    _ChangeBadge(
                      changePct: sg.changePct,
                      isDark: isDark,
                      small: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Transaction list (expandable)
        if (_showTransactions && txs.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(left: 24, right: 14, bottom: 6),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                ...displayTxs.map((tx) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              tx.note.isNotEmpty ? tx.note : '—',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatShortDate(tx.date),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppHelperFunction.formatAmount(tx.amount),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    )),
                if (hasMore && !_showAll)
                  GestureDetector(
                    onTap: () => setState(() => _showAll = true),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 2),
                      child: Text(
                        'Xem thêm ${txs.length - _initialCount} giao dịch',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ),
                  ),
                if (_showAll && hasMore)
                  GestureDetector(
                    onTap: () => setState(() => _showAll = false),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 2),
                      child: Text(
                        'Thu gọn',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade400,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatShortDate(String dateStr) {
    if (dateStr.length < 10) return dateStr;
    // "2026-06-15" → "15/06"
    return '${dateStr.substring(8, 10)}/${dateStr.substring(5, 7)}';
  }
}

// ─── Change Badge ──────────────────────────────────────────────

class _ChangeBadge extends StatelessWidget {
  final double? changePct;
  final bool isDark;
  final bool small;

  const _ChangeBadge({
    required this.changePct,
    required this.isDark,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    if (changePct == null) {
      return Text(
        'Mới',
        style: TextStyle(
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w500,
          color: Colors.blue.shade400,
        ),
      );
    }

    final isUp = changePct! > 0;
    final isDown = changePct! < 0;
    final pctText = '${changePct!.abs().toStringAsFixed(1)}%';

    Color bgColor;
    Color textColor;
    String arrow;

    if (isUp) {
      bgColor = isDark
          ? Colors.red.withValues(alpha: 0.15)
          : const Color(0xFFFEE2E2);
      textColor = isDark ? Colors.red.shade300 : Colors.red.shade700;
      arrow = '↑';
    } else if (isDown) {
      bgColor = isDark
          ? Colors.green.withValues(alpha: 0.15)
          : const Color(0xFFDCFCE7);
      textColor = isDark ? Colors.green.shade300 : Colors.green.shade700;
      arrow = '↓';
    } else {
      bgColor = isDark
          ? Colors.grey.withValues(alpha: 0.15)
          : Colors.grey.shade100;
      textColor = isDark ? Colors.white54 : Colors.grey.shade600;
      arrow = '';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 4 : 6,
        vertical: small ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        changePct == 0 ? '0%' : '$arrow$pctText',
        style: TextStyle(
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.grey.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            const Text('📊', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              'Chưa có dữ liệu chi tiêu',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hãy ghi nhận thêm giao dịch để xem phân tích chi tiết.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
