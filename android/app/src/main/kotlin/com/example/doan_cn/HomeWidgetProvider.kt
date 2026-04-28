package com.example.doan_cn

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                // Get data from SharedPreferences (set by Flutter)
                val balance = widgetData.getString("widget_balance", "0 VND")
                val expense = widgetData.getString("widget_expense", "0 VND")
                val remaining = widgetData.getString("widget_remaining", "0 VND")

                setTextViewText(R.id.widget_balance, balance)
                setTextViewText(R.id.widget_expense, expense)
                setTextViewText(R.id.widget_remaining, remaining)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
