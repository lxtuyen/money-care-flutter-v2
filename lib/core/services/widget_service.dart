import 'package:home_widget/home_widget.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class WidgetService {
  static const String _androidWidgetName = 'HomeWidgetProvider';

  static Future<void> updateHomeWidget({
    double? balance,
    double? monthlyExpense,
    double? remainingBudget,
  }) async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'widget_balance',
        balance != null ? AppHelperFunction.formatAmount(balance) : '****** VND',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_expense',
        monthlyExpense != null
            ? AppHelperFunction.formatAmount(monthlyExpense)
            : '****** VND',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_remaining',
        remainingBudget != null
            ? AppHelperFunction.formatAmount(remainingBudget)
            : '****** VND',
      );

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
      );
    } catch (e) {
      // Log error if needed
    }
  }
}
