import 'package:get/get.dart';
import 'package:money_care/app/router/navigation_menu.dart';
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
import 'package:money_care/features/saving_goal/presentation/screens/create_saving_goal_screen.dart';
import 'package:money_care/features/saving_goal/presentation/screens/select_saving_goal_screen.dart';
import 'package:money_care/features/saving_goal/presentation/screens/expired_saving_goals_screen.dart';
import 'package:money_care/features/splash/presentation/screens/splash.dart';
import 'package:money_care/features/transaction/presentation/screens/create_income_screen.dart';
import 'package:money_care/features/transaction/presentation/screens/create_expense_screen.dart';
import 'package:money_care/features/transaction/presentation/screens/create_photo_transaction_screen.dart';
import 'package:money_care/features/transaction/presentation/screens/photo_transaction_history_screen.dart';
import 'package:money_care/features/user/presentation/screens/profile.dart';
import 'package:money_care/features/notification/presentation/screens/notification.dart';
import 'package:money_care/features/transaction/presentation/screens/user_category_management_screen.dart';
import 'package:money_care/features/gamification/presentation/screens/streak_calendar_screen.dart';
import 'package:money_care/features/splash/presentation/bindings/splash_binding.dart';
import 'package:money_care/features/auth/presentation/bindings/auth_binding.dart';
import 'package:money_care/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:money_care/features/transaction/presentation/bindings/transaction_binding.dart';
import 'package:money_care/features/saving_goal/presentation/bindings/saving_goal_binding.dart';
import 'package:money_care/features/user/presentation/bindings/user_binding.dart';
import 'package:money_care/features/chatbot/presentation/bindings/chat_binding.dart';
import 'package:money_care/features/notification/presentation/bindings/notification_binding.dart';

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
  GetPage(
    name: '/otp',
    page: () => const OtpScreen(),
    binding: AuthBinding(),
  ),
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
    name: '/select_saving_goal',
    page: () => const SelectSavingGoalScreen(),
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
    name: '/expense',
    page: () => const CreateExpenseScreen(),
    binding: TransactionBinding(),
  ),
  GetPage(
    name: '/income',
    page: () => const CreateIncomeScreen(),
    binding: TransactionBinding(),
  ),
  GetPage(
    name: '/transaction_with_image',
    page: () => const CreatePhotoTransactionScreen(),
    binding: TransactionBinding(),
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
    name: '/photo_transaction_history',
    page: () => const PhotoTransactionHistoryScreen(),
    binding: TransactionBinding(),
  ),
  GetPage(
    name: '/expired_saving_goals',
    page: () => const ExpiredSavingGoalsScreen(),
    binding: SavingGoalBinding(),
  ),
  GetPage(
    name: '/onboarding_category_select',
    page: () => const OnboardingCategorySelectScreen(),
    transition: Transition.rightToLeft,
    binding: OnboardingBinding(),
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
];
