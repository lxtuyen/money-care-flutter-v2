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
import 'package:money_care/features/onboarding/presentation/screens/onboarding_income.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_welcome.dart';
import 'package:money_care/features/onboarding/presentation/screens/onboarding_saving_rule.dart';
import 'package:money_care/features/auth/presentation/screens/register.dart';
import 'package:money_care/features/saving_fund/presentation/screens/create_saving_fund.dart';
import 'package:money_care/features/saving_fund/presentation/screens/select_saving_fund.dart';
import 'package:money_care/features/splash/presentation/screens/splash.dart';
import 'package:money_care/features/transaction/presentation/screens/Income.dart';
import 'package:money_care/features/transaction/presentation/screens/expense.dart';
import 'package:money_care/features/user/presentation/screens/profile.dart';

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
    name: '/onboarding_saving_rule',
    page: () => const OnboardingSavingRuleScreen(),
  ),
  GetPage(
    name: '/onboarding_income',
    page: () => const OnboardingIncomeScreen(),
  ),
  GetPage(
    name: '/select_saving_fund',
    page: () => const SelectSavingFundScreen(),
  ),
  GetPage(name: '/create_saving_fund', page: () => const CreateSavingFund()),
  GetPage(name: '/expense', page: () => const ExpenseScreen()),
  GetPage(name: '/income', page: () => const IncomeScreen()),
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
];
