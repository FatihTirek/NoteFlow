package com.dev.noteflow.services;

import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;

import android.content.SharedPreferences;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.dev.noteflow.R;
import com.dev.noteflow.entities.SingleNoteWidget;
import com.google.gson.Gson;

public class SingleNoteWidgetService extends RemoteViewsService {
    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new SingleNoteWidgetFactory(getApplicationContext(), intent);
    }

    private static class SingleNoteWidgetFactory implements RemoteViewsService.RemoteViewsFactory {
        final Context context;
        final int appWidgetId;

        public SingleNoteWidgetFactory(Context context, Intent intent) {
            this.context = context;
            this.appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, 0);
        }

        private SharedPreferences preferences;
        private SingleNoteWidget singleNoteWidget;

        @Override
        public void onCreate() {
            preferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        }

        @Override
        public void onDataSetChanged() {
            String json = preferences.getString("flutter." + appWidgetId, null);
            if (json != null) singleNoteWidget = new Gson().fromJson(json, SingleNoteWidget.class);
            else singleNoteWidget = null;
        }

        @Override
        public void onDestroy() {}

        @Override
        public int getCount() {
            if (singleNoteWidget == null) return 0;
            return 1;
        }

        @Override
        public RemoteViews getViewAt(int i) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.single_note_widget_child);

            views.setOnClickFillInIntent(R.id.single_note_widget_child_background, new Intent());
            views.setInt(R.id.single_note_widget_title, "setVisibility", View.GONE);
            views.setInt(R.id.single_note_widget_spacer, "setVisibility", View.GONE);
            views.setInt(R.id.single_note_widget_content, "setVisibility", View.GONE);

            if (!singleNoteWidget.title.isEmpty()) {
                views.setInt(R.id.single_note_widget_title, "setVisibility", View.VISIBLE);
                views.setTextViewText(R.id.single_note_widget_title, singleNoteWidget.title);
                views.setTextColor(R.id.single_note_widget_title, context.getColor(R.color.single_note_widget_initial_title_color));
            }

            if (!singleNoteWidget.content.isEmpty()) {
                views.setInt(R.id.single_note_widget_content, "setVisibility", View.VISIBLE);
                views.setTextViewText(R.id.single_note_widget_content, singleNoteWidget.content);
                views.setTextColor(R.id.single_note_widget_content, singleNoteWidget.contentColor);
            }

            if (!singleNoteWidget.title.isEmpty() && !singleNoteWidget.content.isEmpty()) {
                views.setInt(R.id.single_note_widget_spacer, "setVisibility", View.VISIBLE);
            }

            return views;
        }

        @Override
        public RemoteViews getLoadingView() { return null; }

        @Override
        public int getViewTypeCount() { return 1; }

        @Override
        public long getItemId(int i) { return i; }

        @Override
        public boolean hasStableIds() { return true; }
    }
}