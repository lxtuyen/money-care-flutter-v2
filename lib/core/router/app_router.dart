import 'package:get/get.dart';
import 'package:money_care/core/router/navigation_menu.dart';
import 'package:money_care/features/admin/presentation/screens/admin_dashboard.dart';
import 'package:money_care/features/admin/presentation/screens/dashboard_content.dart';
import 'package:money_care/features/admin/presentation/screens/user_content.dart';
import 'package:money_care/features/chatbot/presentation/screens/chatbot.dart';
import 'package:money_care/features/auth/presentation/screens/otp.dart';
import 'package:money_care/features/auth/presentation/screens/reset_password.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_expense_management.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_financial_freedom.dart';
import 'package:money_care/features/auth/presentation/screens/forgot_password.dart';
import 'package:money_care/features/auth/presentation/screens/login.dart';
import 'package:money_care/features/auth/presentation/screens/login_option.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_welcome.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_category_select_screen.dart';

import 'package:money_care/features/auth/presentation/screens/register.dart';
import 'package:money_care/features/fund/presentation/screens/create_fund.dart';
import 'package:money_care/features/fund/presentation/screens/select_fund.dart';
import 'package:money_care/features/fund/presentation/screens/fund_report_screen.dart';
import 'package:money_care/features/splash/presentation/screens/splash.dart';
import 'package:money_care/features/transaction/presentation/screens/create_income_screen.dart';
import 'package:money_care/features/transaction/presentation/screens/create_expense_screen.dart';
import 'package:money_care/features/transaction/presentation/screens/create_photo_transaction_screen.dart';
import 'package:money_care/features/transaction/presentation/screens/photo_transaction_history_screen.dart';
import 'package:money_care/features/fund/presentation/screens/expired_funds_screen.dart';
import 'package:money_care/features/user/presentation/screens/profile.dart';
import 'package:money_care/features/notification/presentation/screens/notification.dart';
import 'package:money_care/features/transaction/presentation/screens/user_category_management_screen.dart';
import 'package:money_care/features/gamification/presentation/screens/streak_calendar_screen.dart';

final List<GetPage> appPages = [
  GetPage(name: '/splash', page: () => const SplashScreen()),
  GetPage(
    name: '/onboarding_expense_management',
    page: () => const OnboardingExpenseManagementScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/onboarding_financial_freedom',
    page: () => const OnboardingFinancialFreedomScreen(),
    transition: Transition.leftToRight,
  ),
  GetPage(name: '/select_method_login', page: () => const LoginOptionScreen()),
  GetPage(name: '/forgot_password', page: () => const ForgotPasswordScreen()),
  GetPage(name: '/otp', page: () => const OtpScreen()),
  GetPage(name: '/reset_password', page: () => const ResetPasswordScreen()),
  GetPage(name: '/login', page: () => const LoginScreen()),
  GetPage(name: '/register', page: () => const RegisterScreen()),
  GetPage(
    name: '/onboarding_welcome',
    page: () => const OnboardingWelcomeScreen(),
  ),
  GetPage(
    name: '/select_fund',
    page: () => const SelectFundScreen(),
  ),
  GetPage(name: '/create_fund', page: () => const CreateFund()),
  GetPage(
    name: '/onboarding_balance_setup',
    page: () => const CreateFund(),
    transition: Transition.rightToLeft,
  ),
  GetPage(name: '/expense', page: () => const CreateExpenseScreen()),
  GetPage(name: '/income', page: () => const CreateIncomeScreen()),
  GetPage(
    name: '/transaction_with_image',
    page: () => const CreatePhotoTransactionScreen(),
  ),
  GetPage(name: '/profile', page: () => const ProfileScreen()),
  GetPage(name: '/chatbot', page: () => const ChatbotScreen()),

  GetPage(
    name: '/admin/home',
    page: () => const AdminDashboard(child: DashboardContent()),
  ),

  GetPage(
    name: '/admin/users',
    page: () => const AdminDashboard(child: UsersContent()),
  ),

  GetPage(name: '/main', page: () => const ScaffoldWithNavBar()),

  GetPage(name: '/notification', page: () => const NotificationScreen()),
  GetPage(
    name: '/fund_report',
    page: () => const FundReportScreen(),
  ),
  GetPage(
    name: '/photo_transaction_history',
    page: () => const PhotoTransactionHistoryScreen(),
  ),
  GetPage(
    name: '/expired_funds',
    page: () => const ExpiredFundsScreen(),
  ),
  GetPage(
    name: '/onboarding_category_select',
    page: () => const OnboardingCategorySelectScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/category_management',
    page: () => const UserCategoryManagementScreen(),
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: '/streak_calendar',
    page: () => const StreakCalendarScreen(),
    transition: Transition.rightToLeft,
  ),
];
