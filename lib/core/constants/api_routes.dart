class ApiRoutes {
  static const login = 'auth/login';
  static const register = 'auth/register';
  static const googleLogin = 'auth/google-login';
  static const googleLogin2 = 'auth/google/gmail/connect';
  static const forgotPassword = 'otp/forgot-password';
  static const resetPassword = 'otp/reset-password';
  static const verifyOtp = 'otp/verify-otp';

  static const fund = 'funds';
  static const getFunds = 'funds/user';
  static const selectFund = 'funds/select';
  static const checkExpiredFund = 'funds/check-expired';

  static const userProfile = 'user-profile/me';
  static const users = 'users';
  static const stats = 'users/admin/stats';

  static const transaction = 'transactions';
  static const getTransactionsFilter = 'transactions/filter';

  static const categories = 'categories';
  static const userCategories = 'categories/user';

  static const notification = 'notifications';

  static const scanReceipt = 'receipt/scan';

  static const chatbot = 'chatbot';

  static const studentProfile = 'student-profile';
  static const financeMode = 'finance-mode';
  static const splitSession = 'split-session';
  static const gamification = 'gamification';

  static const paymentconfirm = 'vip-payments/confirm';
  static const getMonthlyRevenue = 'vip-payments/monthly-revenue';
}
