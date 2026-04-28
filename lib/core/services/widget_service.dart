import 'package:home_widget/home_widget.dart';
import 'package:money_care/core/utils/helper/helper_functions.dart';

class WidgetService {
  static const String _androidWidgetName = 'HomeWidgetProvider';

  static Future<void> updateHomeWidget({
    required double balance,
    required double monthlyExpense,
    required double remainingBudget,
  }) async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'widget_balance',
        AppHelperFunction.formatAmount(balance),
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_expense',
        AppHelperFunction.formatAmount(monthlyExpense),
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_remaining',
        AppHelperFunction.formatAmount(remainingBudget),
      );

      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
      );
    } catch (e) {
      // Log error if needed
    }
  }
}
