package com.dev.noteflow.providers;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.RemoteViews;

import com.dev.noteflow.R;
import com.dev.noteflow.activities.MainActivity;
import com.dev.noteflow.entities.NoteWidget;

import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;

public class NoteWidgetProvider extends AppWidgetProvider {
    private enum LaunchAction { SELECT, ADD, SHOW }

    private static SharedPreferences preferences;

    public static final String EXTRA_LAUNCH_ACTION = "extra.LAUNCH_ACTION";
    public static final String EXTRA_NOTE_ID = "extra.NOTE_ID";

    private static final String ACTION_ADD_NOTE = "action.ADD_NOTE";
    private static final String ACTION_SHOW_NOTE = "action.SHOW_NOTE";
    private static final String ACTION_SELECT_NOTE = "action.SELECT_NOTE";

    private static void updateAppWidgetToPremiumRequired(Context context, int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.note_widget_premium_required);
        AppWidgetManager.getInstance(context).updateAppWidget(appWidgetId, views);
    }

    private static void updateAppWidget(Context context, int appWidgetId, NoteWidget noteWidget) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.note_widget);

        Intent addIntent = new Intent(context, NoteWidgetProvider.class);
        addIntent.setAction(ACTION_ADD_NOTE);
        addIntent.setData(Uri.parse(addIntent.toUri(Intent.URI_INTENT_SCHEME)));

        PendingIntent addPendingIntent = PendingIntent.getBroadcast(
                context, 0, addIntent, PendingIntent.FLAG_IMMUTABLE);

        Intent selectIntent = new Intent(context, NoteWidgetProvider.class);
        selectIntent.setAction(ACTION_SELECT_NOTE);
        selectIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        selectIntent.setData(Uri.parse(selectIntent.toUri(Intent.URI_INTENT_SCHEME)));

        PendingIntent selectPendingIntent = PendingIntent.getBroadcast(
                context, 2, selectIntent, PendingIntent.FLAG_IMMUTABLE);

        Intent showIntent = new Intent(context, NoteWidgetProvider.class);
        showIntent.setAction(ACTION_SHOW_NOTE);
        showIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
        showIntent.setData(Uri.parse(showIntent.toUri(Intent.URI_INTENT_SCHEME)));

        PendingIntent showPendingIntent = PendingIntent.getBroadcast(
                context, 1, showIntent, PendingIntent.FLAG_IMMUTABLE);

        if (noteWidget != null) {
            if (!noteWidget.title.isEmpty()) {
                views.setTextViewText(R.id.note_widget_note_title, noteWidget.title);
                views.setTextColor(R.id.note_widget_note_title, context.getColor(R.color.note_widget_initial_title_color));
                views.setViewVisibility(R.id.note_widget_note_title, View.VISIBLE);
            } else {
                views.setViewVisibility(R.id.note_widget_note_title, View.GONE);
            }

            if (!noteWidget.content.isEmpty()) {
                views.setTextViewText(R.id.note_widget_note_content, noteWidget.content);
                views.setTextColor(R.id.note_widget_note_content, noteWidget.contentColor);
                views.setViewVisibility(R.id.note_widget_note_content, View.VISIBLE);
                views.setInt(R.id.note_widget_note_content, "setGravity", Gravity.START);
            } else {
                views.setViewVisibility(R.id.note_widget_note_content, View.GONE);
            }

            if (!noteWidget.title.isEmpty() && !noteWidget.content.isEmpty()) {
                views.setViewVisibility(R.id.note_widget_spacer, View.VISIBLE);
            } else {
                views.setViewVisibility(R.id.note_widget_spacer, View.GONE);
            }

            views.setInt(R.id.note_widget_action_add, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_action_select, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_divider_vertical, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_divider_horizontal, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_background, "setBackgroundColor", noteWidget.backgroundColor);
        } else {
            showPendingIntent.cancel();

            views.setViewVisibility(R.id.note_widget_note_title, View.GONE);
            views.setTextColor(R.id.note_widget_note_content, context.getColor(R.color.note_widget_initial_content_color));
            views.setInt(R.id.note_widget_action_add, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_action_select, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_divider_vertical, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_divider_horizontal, "setColorFilter", context.getColor(R.color.note_widget_initial_title_color));
            views.setInt(R.id.note_widget_background, "setBackgroundColor", context.getColor(R.color.note_widget_initial_background_color));
            views.setInt(R.id.note_widget_note_content, "setGravity", Gravity.CENTER);
            views.setTextViewText(R.id.note_widget_note_content, context.getResources().getString(R.string.note_widget_initial_text));
        }

        views.setOnClickPendingIntent(R.id.note_widget_action_add, addPendingIntent);
        views.setOnClickPendingIntent(R.id.note_widget_action_select, selectPendingIntent);
        views.setOnClickPendingIntent(R.id.note_widget_note_background, showPendingIntent);

        AppWidgetManager.getInstance(context).updateAppWidget(appWidgetId, views);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        SharedPreferences preferences = getPreferences(context);

        for (int appWidgetId : appWidgetIds) {
            if (preferences.getBoolean("flutter.UnlockWidget", false)) {
                updateAppWidget(context, appWidgetId, null);
            } else  {
                updateAppWidgetToPremiumRequired(context, appWidgetId);
            }
        }

        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        int appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0);

        switch (intent.getAction()) {
            case ACTION_SELECT_NOTE:
            {
                SharedPreferences preferences = getPreferences(context);
                Intent activityIntent = FlutterActivity.withNewEngine().build(context)
                        .setClass(context, MainActivity.class)
                        .putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                        .putExtra(EXTRA_LAUNCH_ACTION, LaunchAction.SELECT.ordinal())
                        .putExtra(EXTRA_NOTE_ID, preferences.getString("flutter." + appWidgetId, null))
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
                SharedPreferences preferences = getPreferences(context);
                String noteId = preferences.getString("flutter." + appWidgetId, null);

                if (noteId != null) {
                    Intent activityIntent = FlutterActivity.withNewEngine().build(context)
                        .setClass(context, MainActivity.class)
                        .putExtra(EXTRA_NOTE_ID, noteId)
                        .putExtra(EXTRA_LAUNCH_ACTION, LaunchAction.SHOW.ordinal())
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
            String noteId = preferences.getString("flutter." + appWidgetId, null);

            if (noteId != null) {
                editor.remove("flutter." + noteId);
                editor.apply();
            }

            editor.remove("flutter." + appWidgetId);
        }

        super.onDeleted(context, appWidgetIds);
    }

    public static void initNoteWidget(Intent intent, Context context, HashMap<String, Object> hashMap) {
        SharedPreferences.Editor editor = getPreferences(context).edit();
        NoteWidget noteWidget = NoteWidget.fromMap(hashMap);
        int appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0);

        editor.remove("flutter." + intent.getStringExtra(EXTRA_NOTE_ID));
        editor.putString("flutter." + appWidgetId, noteWidget.id);
        editor.putInt("flutter." + noteWidget.id, appWidgetId);
        editor.apply();

        NoteWidgetProvider.updateAppWidget(context, appWidgetId, noteWidget);
    }

    public static void updateNoteWidget(Context context, HashMap<String, Object> hashMap) {
        SharedPreferences preferences = getPreferences(context);
        NoteWidget noteWidget = NoteWidget.fromMap(hashMap);
        int appWidgetId = preferences.getInt("flutter." + noteWidget.id, 0);

        NoteWidgetProvider.updateAppWidget(context, appWidgetId, noteWidget);
    }

    public static void deleteNoteWidget(Context context, String noteId) {
        SharedPreferences preferences = getPreferences(context);
        SharedPreferences.Editor editor = preferences.edit();
        int appWidgetId = preferences.getInt("flutter." + noteId, 0);

        editor.remove("flutter." + noteId);
        editor.remove("flutter." + appWidgetId);
        editor.apply();

        NoteWidgetProvider.updateAppWidget(context, appWidgetId, null);
    }

    private static SharedPreferences getPreferences(Context context) {
        if (preferences == null) {
            preferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        }

        return preferences;
    }
}
