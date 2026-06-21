class ApiRoutes {
  static const login = 'auth/login';
  static const register = 'auth/register';
  static const googleLogin = 'auth/google-login';
  static const googleLogin2 = 'auth/google/gmail/connect';
  static const forgotPassword = 'otp/forgot-password';
  static const resetPassword = 'otp/reset-password';
  static const verifyOtp = 'otp/verify-otp';

  static const savingGoal = 'saving-goals';
  static const getSavingGoals = 'saving-goals/user';
  static const savingGoalPredictions = 'saving-goals/predictions';
  static const savingGoalBudgetSuggestion = 'saving-goals/budget-suggestion';
  static const selectSavingGoal = 'saving-goals/select';
  static const checkExpiredSavingGoal = 'saving-goals/check-expired';
  static String activateSavingGoal(int id) => 'saving-goals/$id/activate';
  static String pauseSavingGoal(int id) => 'saving-goals/$id/pause';
  static const spendingPlans = 'spending-plans';

  static const userProfile = 'user-profile/me';
  static const users = 'users';

  static const transaction = 'transactions';

  static const wallets = 'wallets';
  static const totalAssets = 'wallets/total-assets';

  static const categories = 'categories';
  static const userCategories = 'categories/user';

  static const notification = 'notifications';
  static const fcmToken = 'notifications/fcm-token';

  static const scanReceipt = 'ai/receipt/scan';

  static const chatbot = 'ai/chat';
  static const goalPlanInsight = 'ai/goal-plan-insight';
  static const initialFinancialPlanSuggest =
      'ai/initial-financial-plan/suggest';
  static const financialAnalytics = 'analytics/financial-summary';
  static const trainForecastingModel = 'analytics/model-training/forecasting';
  static const aiFeedback = 'ai-feedback';
  static const aiFeedbackSummary = 'ai-feedback/summary';
  static const personalizationProfile = 'personalization/profile';
  static const personalizationProfileRebuild =
      'personalization/profile/rebuild';


  static const splitSession = 'split-session';
  static const gamification = 'gamification';
  static const couples = 'couples';

  // Payments
  static const paymentsSubscribe = 'payments/subscribe';
  static const paymentsActivateTrial = 'payments/activate-trial';
  static const subscriptionStatus = 'payments/subscription-status';
  static const paymentHistory = 'payments/history';
  static String paymentVerify(int orderCode) => 'payments/verify/$orderCode';
}
