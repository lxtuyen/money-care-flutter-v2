import 'package:money_care/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:money_care/features/transaction/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/features/auth/presentation/controllers/auth_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/filter_controller.dart';
import 'package:money_care/features/saving_fund/presentation/controllers/saving_fund_controller.dart';
import 'package:money_care/features/transaction/presentation/controllers/transaction_controller.dart';
import 'package:money_care/features/user/presentation/controllers/user_controller.dart';
import 'package:money_care/core/constants/colors.dart';
import 'package:money_care/core/constants/icon_string.dart';
import 'package:money_care/core/constants/sizes.dart';
import 'package:money_care/core/controllers/app_controller.dart';
import 'package:money_care/features/home/presentation/widgets/widgets.dart';
import 'package:money_care/core/presentation/widgets/icon/circular_icon.dart';
import 'package:money_care/core/presentation/widgets/texts/section_heading.dart';
import 'package:money_care/core/constants/app_assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();
  late DateTime startDate = now.subtract(const Duration(days: 6));
  late DateTime endDate = now;

  final AppController appController = Get.find<AppController>();
  final TransactionController transactionController =
      Get.find<TransactionController>();
  final FilterController filterController = Get.find<FilterController>();
  final SavingFundController fundController = Get.find<SavingFundController>();
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  final StatisticsController statisticsController =
      Get.find<StatisticsController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final userId = await appController.getCurrentUserId();

    final fundId =
        fundController.fundId.value > 0 ? fundController.fundId.value : null;

    await Future.wait([
      statisticsController.loadStatisticsData(userId!, startDate, endDate),
      transactionController.filterTransactions(
        userId,
        TransactionFilterDto(
          fundId: fundId,
          startDate: startDate.toIso8601String(),
          endDate: endDate.toIso8601String(),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  final profile = userController.userProfile.value;

                  if (userController.isLoading.value) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (profile == null) {
                    return const Text(
                      "Chào mừng",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.text4,
                      ),
                    );
                  }
                  return Text(
                    "Chào mừng, ${profile.fullName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.text4,
                    ),
                  );
                }),

                Row(
                  children: [
                    CircularIcon(
                      iconPath: AppIcons.search,
                      backgroundColor: const Color(0XFFF5FAFE),
                      height: 36,
                      width: 36,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Obx(() {
                                    final transactions =
                                        transactionController
                                            .transactionByfilter
                                            .value
                                            ?.expenseTransactions ??
                                        [];

                                    if (transactionController.isLoading.value) {
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
                    const SizedBox(width: AppSizes.spaceBtwItems),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircularIcon(
                          onTap: () => Get.toNamed(RoutePath.notification),
                          iconPath: AppIcons.notification,
                          backgroundColor: const Color(0XFFF5FAFE),
                          height: 36,
                          width: 36,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 10,
                            height: 10,
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

            const SizedBox(height: AppSizes.defaultSpace),
            Obx(() {
              final totals = statisticsController.totalByType.value;

              if (statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (totals == null) {
                return const SpendingSummary(
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

            AppSectionHeading(
              title: "Chi theo phân loại",
              showActionButton: false,
            ),

            const SizedBox(height: AppSizes.defaultSpace),

            Obx(() {
              final categories = statisticsController.totalByCate;

              if (statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (categories.isEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutePath.expense);
                      },
                      child: Container(
                        width: 50,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundPrimary,
                          borderRadius: BorderRadius.circular(
                            AppSizes.cardRadiusLg,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            color: AppColors.text5,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: AppSizes.defaultSpace),
                    Expanded(
                      child: Text(
                        "Tạo hoặc lựa chọn quỹ tiết kiệm để chúng tôi giúp bạn quản lý tài chính hiệu quả",
                        style: TextStyle(
                          color: AppColors.text4,
                          fontSize: AppSizes.fontSizeSm,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return CategorySection(categories: categories);
            }),

            const SizedBox(height: AppSizes.defaultSpace),

            AppSectionHeading(title: "Giao dịch gần đây", showActionButton: false),
            Obx(() {
              final transactions =
                  transactionController.transactionByfilter.value;
              if (transactionController.isLoading.value) {
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
              final totalsData = statisticsController.totalByDate.value;

              if (statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (totalsData == null || totalsData.expense.isEmpty) {
                return SpendingOverviewCard(
                  startDate: startDate,
                  endDate: endDate,
                  totals: [],
                  amountSpent: 0,
                );
              }

              final totals = totalsData.expense;
              double totalSpent = totals.fold(0, (sum, t) => sum + t.total);

              return SpendingOverviewCard(
                startDate: startDate,
                endDate: endDate,
                totals: totals,
                amountSpent: totalSpent,
              );
            }),

            const SizedBox(height: AppSizes.defaultSpace),

            AppSectionHeading(title: "Hạn mức chi tiêu", showActionButton: false),
            const SizedBox(height: AppSizes.defaultSpace),

            Obx(() {
              final categories = statisticsController.totalByCate;
              if (statisticsController.isLoading.value) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (categories.isEmpty) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: Text('Không có dữ liệu')),
                );
              }

              return Column(
                children:
                    categories.map((category) {
                      return SpendingLimitCard(
                        title: category.categoryName,
                        limit: category.limit,
                        spent: category.total,
                        iconPath: AppAssets.iconSvgPath(category.categoryIcon),
                      );
                    }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
