package com.dev.noteflow.providers;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;

import android.content.Context;
import android.content.Intent;

import android.content.SharedPreferences;
import android.net.Uri;
import android.widget.RemoteViews;

import com.dev.noteflow.R;
import com.dev.noteflow.activities.MainActivity;
import com.dev.noteflow.entities.SingleNoteWidget;
import com.dev.noteflow.services.SingleNoteWidgetService;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;

public class SingleNoteWidgetProvider extends AppWidgetProvider {
    private enum LaunchAction { SELECT, ADD, SHOW }

    private static SharedPreferences preferences;

    public static final String EXTRA_LAUNCH_ACTION = "extra.LAUNCH_ACTION";
    public static final String EXTRA_NOTE_ID = "extra.NOTE_ID";
    private static final String ACTION_ADD_NOTE = "action.ADD_NOTE";
    private static final String ACTION_SHOW_NOTE = "action.SHOW_NOTE";
    private static final String ACTION_CHANGE_NOTE = "action.CHANGE_NOTE";

    private static void showPremiumRequired(Context context, int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.app_widget_premium_required);
        AppWidgetManager.getInstance(context).updateAppWidget(appWidgetId, views);
    }

    private static void updateAppWidget(Context context, int appWidgetId, SingleNoteWidget singleNoteWidget) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.single_note_widget);

        Intent addIntent = new Intent(context, SingleNoteWidgetProvider.class);
        addIntent.setAction(ACTION_ADD_NOTE);
        addIntent.setData(Uri.parse(addIntent.toUri(Intent.URI_INTENT_SCHEME)));

        PendingIntent addPendingIntent = PendingIntent.getBroadcast(
                context, 0, addIntent, PendingIntent.FLAG_IMMUTABLE);

        Intent changeIntent = new Intent(context, SingleNoteWidgetProvider.class);
        changeIntent.setAction(ACTION_CHANGE_NOTE);
        changeIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        changeIntent.setData(Uri.parse(changeIntent.toUri(Intent.URI_INTENT_SCHEME)));

        PendingIntent changePendingIntent = PendingIntent.getBroadcast(
                context, 2, changeIntent, PendingIntent.FLAG_IMMUTABLE);

        Intent showIntent = new Intent(context, SingleNoteWidgetProvider.class);
        showIntent.setAction(ACTION_SHOW_NOTE);
        showIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        showIntent.setData(Uri.parse(showIntent.toUri(Intent.URI_INTENT_SCHEME)));

        PendingIntent showPendingIntent = PendingIntent.getBroadcast(
                context, 1, showIntent, PendingIntent.FLAG_IMMUTABLE);

        Intent intent = new Intent(context, SingleNoteWidgetService.class);
        intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)));

        if (singleNoteWidget == null) {
            views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_0);
        } else {
            switch (singleNoteWidget.backgroundCIndex) {
                case 1:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_1);
                    break;
                case 2:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_2);
                    break;
                case 3:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_3);
                    break;
                case 4:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_4);
                    break;
                case 5:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_5);
                    break;
                case 6:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_6);
                    break;
                case 7:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_7);
                    break;
                case 8:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_8);
                    break;
                case 9:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_9);
                    break;
                case 10:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_10);
                    break;
                default:
                    views.setInt(R.id.single_note_widget_background, "setImageResource", R.drawable.single_note_widget_background_0);
                    break;
            }


        }

        views.setEmptyView(R.id.single_note_widget_listview, R.id.single_note_widget_empty_view);
        views.setRemoteAdapter(R.id.single_note_widget_listview, intent);
        views.setOnClickPendingIntent(R.id.single_note_widget_icon_add, addPendingIntent);
        views.setOnClickPendingIntent(R.id.single_note_widget_icon_select, changePendingIntent);
        views.setPendingIntentTemplate(R.id.single_note_widget_listview, showPendingIntent);

        AppWidgetManager.getInstance(context).updateAppWidget(appWidgetId, views);
        AppWidgetManager.getInstance(context).notifyAppWidgetViewDataChanged(appWidgetId, R.id.single_note_widget_listview);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        SharedPreferences preferences = getPreferences(context);

        for (int appWidgetId : appWidgetIds) {
            boolean isWidgetUnlocked = preferences.getBoolean("flutter.UnlockWidget", false);

            if (isWidgetUnlocked) updateAppWidget(context, appWidgetId, null);
            else showPremiumRequired(context, appWidgetId);
        }

        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        int appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0);

        switch (Objects.requireNonNull(intent.getAction())) {
            case ACTION_CHANGE_NOTE:
            {
                String json = getPreferences(context).getString("flutter." + appWidgetId, null);
                String noteId = json != null ? new Gson().fromJson(json, SingleNoteWidget.class).id : null;
                Intent activityIntent = FlutterActivity.withNewEngine().build(context)
                        .setClass(context, MainActivity.class)
                        .putExtra(EXTRA_NOTE_ID, noteId)
                        .putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                        .putExtra(EXTRA_LAUNCH_ACTION, LaunchAction.SELECT.ordinal())
                        .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_NO_HISTORY);

                context.startActivity(activityIntent);
                break;
            }
            case ACTION_ADD_NOTE:
            {
                Intent activityIntent = FlutterActivity.withNewEngine().build(context)
                        .setClass(context, MainActivity.class)
                        .putExtra(EXTRA_LAUNCH_ACTION, LaunchAction.ADD.ordinal())
                        .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_NO_HISTORY);

                context.startActivity(activityIntent);
                break;
            }
            case ACTION_SHOW_NOTE:
            {
                String json = getPreferences(context).getString("flutter." + appWidgetId, null);

                if (json != null) {
                    Intent activityIntent = FlutterActivity.withNewEngine().build(context)
                        .setClass(context, MainActivity.class)
                        .putExtra(EXTRA_LAUNCH_ACTION, LaunchAction.SHOW.ordinal())
                        .putExtra(EXTRA_NOTE_ID, new Gson().fromJson(json, SingleNoteWidget.class).id)
                        .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_NO_HISTORY);

                    context.startActivity(activityIntent);
                } 
                break;
            }
        }

        super.onReceive(context, intent);
    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        SharedPreferences preferences = getPreferences(context);
        SharedPreferences.Editor editor = preferences.edit();

        for (int appWidgetId : appWidgetIds) {
            String json = getPreferences(context).getString("flutter." + appWidgetId, null);

            if (json != null) {
                editor.remove("flutter." + new Gson().fromJson(json, SingleNoteWidget.class).id);
                editor.apply();
            }

            editor.remove("flutter." + appWidgetId);
        }

        super.onDeleted(context, appWidgetIds);
    }

    public static void initWidget(Intent intent, Context context, HashMap<String, Object> hashMap) {
        SharedPreferences.Editor editor = getPreferences(context).edit();
        SingleNoteWidget singleNoteWidget = SingleNoteWidget.fromMap(hashMap);
        int appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0);

        editor.remove("flutter." + intent.getStringExtra(EXTRA_NOTE_ID));
        editor.putString("flutter." + appWidgetId, new Gson().toJson(singleNoteWidget));
        editor.putInt("flutter." + singleNoteWidget.id, appWidgetId);
        editor.apply();

        SingleNoteWidgetProvider.updateAppWidget(context, appWidgetId, singleNoteWidget);
    }

    public static void updateWidget(Context context, HashMap<String, Object> hashMap) {
        SharedPreferences preferences = getPreferences(context);
        SharedPreferences.Editor editor = preferences.edit();
        SingleNoteWidget singleNoteWidget = SingleNoteWidget.fromMap(hashMap);
        int appWidgetId = preferences.getInt("flutter." + singleNoteWidget.id, 0);

        editor.putString("flutter." + appWidgetId, new Gson().toJson(singleNoteWidget));
        editor.apply();

        SingleNoteWidgetProvider.updateAppWidget(context, appWidgetId, singleNoteWidget);
    }

    public static void deleteWidget(Context context, String noteId) {
        SharedPreferences preferences = getPreferences(context);
        SharedPreferences.Editor editor = preferences.edit();
        int appWidgetId = preferences.getInt("flutter." + noteId, 0);

        editor.remove("flutter." + noteId);
        editor.remove("flutter." + appWidgetId);
        editor.apply();

        SingleNoteWidgetProvider.updateAppWidget(context, appWidgetId, null);
    }

    private static SharedPreferences getPreferences(Context context) {
        if (preferences == null) preferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        return preferences;
    }
}
