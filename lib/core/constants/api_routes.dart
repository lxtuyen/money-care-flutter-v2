class ApiRoutes {
  // --- Auth ---
  static const login = 'auth/login';
  static const register = 'auth/register';
  static const googleLogin = 'auth/google-login';
  static const googleLogin2 = 'auth/google/gmail/connect';
  static const forgotPassword = 'otp/forgot-password';
  static const resetPassword = 'otp/reset-password';
  static const verifyOtp = 'otp/verify-otp';

  // --- Saving Fund ---
  static const savingFund = 'saving-fund';
  static const getSavingFunds = 'saving-fund/user';
  static const selectSavingFund = 'saving-fund/select';

  // --- User proflie ---
  static const userProfile = 'user-profile/me';
  static const monthlyIncome = 'user-profile/monthly-income';
  static const users = 'users';
  static const stats = 'users/admin/stats';

  // --- Transaction ---
  static const transaction = 'transactions';
  static const getTransactionsFilter = 'transactions/filter';
  static const pendingTransactions = 'pending-transactions';

  // --- Notification ---
  static const getNotificationsByUser = 'notifications/me';
  static const notification = 'notifications';

  // --- Scan Receipt ---
  static const scanReceipt = 'receipt/scan';

    // --- Chat bot ---
  static const chatbot = 'chatbot';

  static const paymentconfirm = 'vip-payments/confirm';
  static const getMonthlyRevenue = 'vip-payments/monthly-revenue';
}
