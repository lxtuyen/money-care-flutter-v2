import 'package:get/get.dart';
import 'package:money_care/core/constants/route_path.dart';
import 'package:money_care/app/router/navigation_menu.dart';
import 'package:money_care/features/chatbot/presentation/screens/chatbot.dart';
import 'package:money_care/features/spending_plan/presentation/screens/initial_setup_screen.dart';
import 'package:money_care/features/auth/presentation/screens/otp.dart';
import 'package:money_care/features/auth/presentation/screens/reset_password.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_expense_management.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_financial_freedom.dart';
import 'package:money_care/features/auth/presentation/screens/forgot_password.dart';
import 'package:money_care/features/auth/presentation/screens/login.dart';
import 'package:money_care/features/auth/presentation/screens/login_option.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_welcome.dart';

import 'package:money_care/features/auth/presentation/screens/register.dart';
import 'package:money_care/features/saving_goal/presentation/screens/create_saving_goal_screen.dart';
import 'package:money_care/features/saving_goal/presentation/screens/saving_goal_management_screen.dart';
import 'package:money_care/features/splash/presentation/screens/splash.dart';
import 'package:money_care/features/transaction/presentation/screens/create_transaction_screen.dart';
import 'package:money_care/features/user/presentation/screens/profile.dart';
import 'package:money_care/features/notification/presentation/screens/notification.dart';
import 'package:money_care/features/transaction/presentation/screens/user_category_management_screen.dart';
import 'package:money_care/features/gamification/presentation/screens/streak_calendar_screen.dart';
import 'package:money_care/features/wallet/presentation/screens/wallet_list_screen.dart';
import 'package:money_care/features/wallet/presentation/screens/wallet_transfer_screen.dart';
import 'package:money_care/features/wallet/presentation/screens/wallet_detail_screen.dart';
import 'package:money_care/features/saving_goal/presentation/screens/saving_goal_detail_screen.dart';
import 'package:money_care/features/spending_plan/presentation/bindings/spending_plan_binding.dart';
import 'package:money_care/features/spending_plan/presentation/screens/create_spending_plan_screen.dart';
import 'package:money_care/features/spending_plan/presentation/screens/spending_plan_detail_screen.dart';
import 'package:money_care/features/spending_plan/presentation/screens/spending_plan_list_screen.dart';
import 'package:money_care/features/splash/presentation/bindings/splash_binding.dart';
import 'package:money_care/features/auth/presentation/bindings/auth_binding.dart';
import 'package:money_care/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:money_care/features/transaction/presentation/bindings/transaction_binding.dart';
import 'package:money_care/features/saving_goal/presentation/bindings/saving_goal_binding.dart';
import 'package:money_care/features/user/presentation/bindings/user_binding.dart';
import 'package:money_care/features/chatbot/presentation/bindings/chat_binding.dart';
import 'package:money_care/features/notification/presentation/bindings/notification_binding.dart';
import 'package:money_care/features/statistics/presentation/screens/model_evaluation_screen.dart';
import 'package:money_care/features/statistics/presentation/bindings/model_evaluation_binding.dart';
import 'package:money_care/features/scenario_planning/presentation/screens/scenario_planning_screen.dart';

final List<GetPage> appPages = [
  GetPage(
    name: '/splash',
    page: () => const SplashScreen(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: '/onboarding_expense_management',
    page: () => const OnboardingExpenseManagementScreen(),
    transition: Transition.rightToLeft,
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: '/onboarding_financial_freedom',
    page: () => const OnboardingFinancialFreedomScreen(),
    transition: Transition.leftToRight,
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: '/select_method_login',
    page: () => const LoginOptionScreen(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/forgot_password',
    page: () => const ForgotPasswordScreen(),
    binding: AuthBinding(),
  ),
  GetPage(name: '/otp', page: () => const OtpScreen(), binding: AuthBinding()),
  GetPage(
    name: '/reset_password',
    page: () => const ResetPasswordScreen(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/register',
    page: () => const RegisterScreen(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: '/onboarding_welcome',
    page: () => const OnboardingWelcomeScreen(),
    binding: OnboardingBinding(),
  ),
  GetPage(
    name: RoutePath.savingGoalManagement,
    page: () => const SavingGoalManagementScreen(),
    binding: SavingGoalBinding(),
  ),
  GetPage(
    name: '/create_saving_goal',
    page: () => const CreateSavingGoalScreen(),
    binding: SavingGoalBinding(),
  ),
  GetPage(
    name: '/onboarding_balance_setup',
    page: () => const CreateSavingGoalScreen(),
    transition: Transition.rightToLeft,
    binding: SavingGoalBinding(),
  ),
  GetPage(
    name: RoutePath.initialSetup,
    page: () => const InitialSetupScreen(),
    transition: Transition.rightToLeft,
    binding: SpendingPlanBinding(),
  ),
  GetPage(
    name: RoutePath.expense,
    page: () => const CreateTransactionScreen(),
    binding: TransactionBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.income,
    page: () => const CreateTransactionScreen(),
    binding: TransactionBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.transactionWithImage,
    page: () => const CreateTransactionScreen(),
    binding: TransactionBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.createTransaction,
    page: () => const CreateTransactionScreen(),
    binding: TransactionBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/profile',
    page: () => const ProfileScreen(),
    binding: UserBinding(),
  ),
  GetPage(
    name: '/chatbot',
    page: () => const ChatbotScreen(),
    binding: ChatBinding(),
  ),
  GetPage(name: '/main', page: () => const ScaffoldWithNavBar()),
  GetPage(
    name: '/notification',
    page: () => const NotificationScreen(),
    binding: NotificationBinding(),
  ),
  GetPage(
    name: '/category_management',
    page: () => const UserCategoryManagementScreen(),
    transition: Transition.rightToLeft,
    binding: TransactionBinding(),
  ),
  GetPage(
    name: '/streak_calendar',
    page: () => const StreakCalendarScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/wallets',
    page: () => const WalletListScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/wallet_transfer',
    page: () => const WalletTransferScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/wallet_detail',
    page: () => const WalletDetailScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.savingGoalDetail,
    page: () => const SavingGoalDetailScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.spendingPlanList,
    page: () => const SpendingPlanListScreen(),
    binding: SpendingPlanBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.createSpendingPlan,
    page: () => const CreateSpendingPlanScreen(),
    binding: SpendingPlanBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.spendingPlanDetail,
    page: () => const SpendingPlanDetailScreen(),
    binding: SpendingPlanBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.modelEvaluation,
    page: () => const ModelEvaluationScreen(),
    binding: ModelEvaluationBinding(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: RoutePath.scenarioPlanning,
    page: () => const ScenarioPlanningScreen(),
    transition: Transition.rightToLeft,
  ),
];
