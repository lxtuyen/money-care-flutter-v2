import 'package:money_care/app/controllers/statistics_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/app/controllers/fund_controller.dart';
import 'package:money_care/app/controllers/transaction_controller.dart';
import 'package:money_care/app/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/app/controllers/app_controller.dart';
import 'package:money_care/features/home/presentation/widgets/widgets.dart';
import 'package:money_care/features/home/presentation/controllers/home_controller.dart';
import 'package:money_care/app/widgets/icon/circular_icon.dart';
import 'package:money_care/app/widgets/texts/section_heading.dart';
import 'package:money_care/core/constants/app_assets.dart';
import 'package:money_care/features/finance_mode/domain/entities/finance_mode_entity.dart';
import 'package:money_care/features/finance_mode/presentation/controllers/finance_mode_controller.dart';
import 'package:money_care/features/finance_mode/presentation/widgets/finance_mode_banner.dart';
import 'package:money_care/features/finance_mode/presentation/widgets/days_until_income_widget.dart';
import 'package:money_care/features/fund/presentation/widgets/fund_progress_bar.dart';
import 'package:money_care/features/gamification/presentation/widgets/streak_badge_widget.dart';
import 'package:money_care/features/transaction/domain/entities/total_by_category_entity.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final profile = controller.userController.userProfile.value;
                        final String greeting = AppHelperFunction.getGreeting();
                        
                        if (controller.userController.isLoading.value) {
                          return const SizedBox(
                            height: 48,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          );
                        }

                        return Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: profile?.avatar != null 
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: Image.network(profile!.avatar!, width: 44, height: 44, fit: BoxFit.cover),
                                    )
                                  : Text(
                                      (profile?.firstName?.isNotEmpty == true) ? profile!.firstName![0].toUpperCase() : "U",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.text4,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    profile?.fullName ?? "Người dùng",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.text1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    Row(
                      children: [
                        CircularIcon(
                          iconPath: AppIcons.search,
                          backgroundColor: const Color(0XFFF5FAFE),
                          height: 38,
                          width: 38,
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: '',
                              transitionDuration: const Duration(milliseconds: 200),
                              pageBuilder: (context, anim1, anim2) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 80),
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      child: Obx(() {
                                        final transactions = controller.transactionController
                                                .transactionByfilter
                                                .value
                                                ?.expenseTransactions ??
                                            [];

                                        if (controller.transactionController.isLoading.value) {
                                          return const SizedBox(
                                            height: 120,
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        }

                                        return TransactionSearchAnchor(
                                          listData: transactions,
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircularIcon(
                              onTap: () => Get.toNamed(RoutePath.notification),
                              iconPath: AppIcons.notification,
                              backgroundColor: const Color(0XFFF5FAFE),
                              height: 38,
                              width: 38,
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const FinanceModeBanner(),
                      const SizedBox(width: 8),
                      const StreakBadgeWidget(),
                      const SizedBox(width: 8),
                      const DaysUntilIncomeWidget(),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.defaultSpace),
            Obx(() {
              final totals = controller.statisticsController.totalByType.value;

              if (controller.statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (totals == null) {
                return SpendingSummary(
                  incomeTotal: 0,
                  expenseTotal: 0,
                );
              }

              return SpendingSummary(
                incomeTotal: totals.incomeTotal,
                expenseTotal: totals.expenseTotal,
              );
            }),

            const SizedBox(height: AppSizes.defaultSpace),

            AppSectionHeading(title: "Giao dịch gần đây", showActionButton: false),
            Obx(() {
              final transactions =
                  controller.transactionController.transactionByfilter.value;
              if (controller.transactionController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (transactions == null) {
                return const TransactionSection(
                incomeTransactions: [],
                expenseTransactions: [],
              );
              }

              return TransactionSection(
                incomeTransactions: transactions.incomeTransactions,
                expenseTransactions: transactions.expenseTransactions,
              );
            }),

            const SizedBox(height: AppSizes.defaultSpace),

            AppSectionHeading(title: "Tổng quan", showActionButton: false),
            const SizedBox(height: AppSizes.spaceBtwItems),
            Obx(() {
              final totalsData = controller.statisticsController.totalByDate.value;

              if (controller.statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (totalsData == null || totalsData.expense.isEmpty) {
                return SpendingOverviewCard(
                  startDate: controller.startDate,
                  endDate: controller.endDate,
                  totals: [],
                  amountSpent: 0,
                );
              }

              final totals = totalsData.expense;
              double totalSpent = totals.fold(0, (sum, t) => sum + t.total);

              return SpendingOverviewCard(
                startDate: controller.startDate,
                endDate: controller.endDate,
                totals: totals,
                amountSpent: totalSpent,
              );
            }),

            const SizedBox(height: AppSizes.defaultSpace),

            Obx(() {
              final categories = controller.statisticsController.totalByCate;
              final mode = controller.financeModeController.currentMode.value;

              final filtered = categories.where((cat) {
                if (cat.limit > 0) return true;
                if (mode == FinanceMode.survival && !cat.isEssential && cat.total > 0) {
                  return true;
                }
                return false;
              }).toList();
              filtered.sort((a, b) {
                double percentA = a.limit > 0 ? a.total / a.limit : (a.total > 0 ? 10.0 : 0.0);
                double percentB = b.limit > 0 ? b.total / b.limit : (b.total > 0 ? 10.0 : 0.0);
                return percentB.compareTo(percentA);
              });

              if (filtered.isEmpty) return const SizedBox.shrink();

              return Column(
                children: [
                   AppSectionHeading(
                    title: "Hạn mức chi tiêu", 
                    showActionButton: filtered.length > 3,
                    buttonTitle: "Tất cả",
                    onPressed: () {
                    },
                  ),
                  const SizedBox(height: AppSizes.spaceBtwItems),
                  ...filtered.take(3).map((category) {
                    return CategoryOverviewCard(
                      title: category.categoryName,
                      limit: category.limit,
                      spent: category.total,
                      iconPath: category.categoryIcon,
                    );
                  }).toList(),
                ],
              );
            }),
            const SizedBox(height: AppSizes.defaultSpace),

            Obx(() {
              if (controller.statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 124,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              final mode = controller.financeModeController.currentMode.value;
              final categories = controller.statisticsController.expenseCategories;
              
              List<TotalByCategoryEntity> filteredCategories;
              if (mode == FinanceMode.survival) {
                filteredCategories = categories.where((c) => c.isEssential).toList();
              } else {
                filteredCategories = categories.toList();
              }

              if (mode == FinanceMode.saving) {
                filteredCategories.sort((a, b) {
                  if (a.limit <= 0 && b.limit <= 0) return 0;
                  if (a.limit <= 0) return 1;
                  if (b.limit <= 0) return -1;
                  final aPercent = a.total / a.limit;
                  final bPercent = b.total / b.limit;
                  return bPercent.compareTo(aPercent);
                });
              }

              if (filteredCategories.isEmpty) {
                return mode == FinanceMode.survival 
                  ? AppSectionHeading(
                      title: "Chi tiêu tháng này (Cắt giảm tối đa!)", 
                      showActionButton: false,
                    )
                  : const SizedBox.shrink();
              }

              String sectionTitle = "Chi tiêu tháng này";
              String? sectionSubtitle;
              
              if (mode == FinanceMode.survival) {
                sectionTitle = "Chi tiêu thiết yếu (Sinh tồn)";
              } else if (mode == FinanceMode.saving) {
                sectionTitle = "Kế hoạch tiết kiệm";
                sectionSubtitle = "Duy trì chi tiêu dưới 80% hạn mức";
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   AppSectionHeading(
                    title: sectionTitle,
                    showActionButton: false,
                  ),
                  if (sectionSubtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        sectionSubtitle,
                        style: const TextStyle(fontSize: 12, color: AppColors.text4, fontStyle: FontStyle.italic),
                      ),
                    ),
                  SizedBox(height: sectionSubtitle != null ? 0 : AppSizes.spaceBtwItems),
                  ...filteredCategories.map((category) {
                    return CategoryOverviewCard(
                      title: category.categoryName,
                      limit: category.limit,
                      spent: category.total,
                      iconPath: category.categoryIcon,
                      isIncome: false,
                    );
                  }).toList(),
                  if (mode == FinanceMode.survival && categories.any((c) => !c.isEssential && c.total > 0))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Đã ẩn ${categories.where((c) => !c.isEssential).length} mục không thiết yếu",
                        style: const TextStyle(fontSize: 11, color: AppColors.error, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              );
            }),

            const SizedBox(height: AppSizes.md),

            Obx(() {
              if (controller.statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 124,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.statisticsController.incomeCategories.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                   AppSectionHeading(
                    title: "Thu nhập tháng này", 
                    showActionButton: false,
                  ),
                  const SizedBox(height: AppSizes.spaceBtwItems),
                  ...controller.statisticsController.incomeCategories.map((category) {
                    return CategoryOverviewCard(
                      title: category.categoryName,
                      limit: category.limit,
                      spent: category.total,
                      iconPath: category.categoryIcon,
                      isIncome: true,
                    );
                  }).toList(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.fontSizeSm,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}
