package com.dev.noteflow.activities;

import android.database.Cursor;
import android.net.Uri;
import android.os.Build;

import android.provider.OpenableColumns;
import android.provider.Settings;
import android.provider.DocumentsContract;

import android.widget.Toast;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import android.app.Activity;
import android.media.RingtoneManager;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import android.annotation.SuppressLint;

import com.dev.noteflow.providers.SingleNoteWidgetProvider;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    private MethodCall call;
    private MethodChannel.Result result;

    private static final String DOWNLOADS_FOLDER = "content://com.android.externalstorage.documents/tree/primary%3ADownloads/document/primary%3ADownloads";
    private static final String CHANNEL_MAIN = "com.dev.noteflow.channel.MAIN";
    private static final String BACKUP_FILE_NAME = "nf_backup.json";
    private static final int ACTION_OPEN_SOUND_PICKER = 1;
    private static final int ACTION_CREATE_BACKUP_FILE = 2;
    private static final int ACTION_OPEN_BACKUP_FILE = 3;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_MAIN)
                .setMethodCallHandler((call, result) -> {
                    this.result = result;
                    this.call = call;

                    switch (call.method) {
                        case "getBackupFile":
                            getBackupFile();
                            break;
                        case "createBackupFile":
                            createBackupFile();
                            break;
                        case "showToast":
                            showToast(call.argument("message"), call.argument("short"));
                            break;
                        case "getAppVersion":
                            getAppVersion();
                            break;
                        case "getSoundUri":
                            getSoundUri();
                            break;
                        case "openNotificationSettings":
                            openNotificationSettings();
                            break;
                        case "getSingleNoteWidgetLaunchDetails":
                            getSingleNoteWidgetLaunchDetails();
                            break;
                        case "initSingleNoteWidget":
                            SingleNoteWidgetProvider.initWidget(getIntent(), getApplicationContext(), (HashMap<String, Object>) call.arguments);
                            break;
                        case "updateSingleNoteWidget":
                            SingleNoteWidgetProvider.updateWidget(getApplicationContext(), (HashMap<String, Object>) call.arguments);
                            break;
                        case "deleteSingleNoteWidget":
                            SingleNoteWidgetProvider.deleteWidget(getApplicationContext(), (String) call.arguments);
                            break;
                    }
                });
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    @SuppressLint("Range")
    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent intent) {
        if (resultCode == Activity.RESULT_OK && intent != null) {
            if (requestCode == ACTION_OPEN_SOUND_PICKER) {
                Uri uri = intent.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI);

                if (uri != null) result.success(uri.toString());
                else result.success(null);
            } else if (requestCode == ACTION_CREATE_BACKUP_FILE) {
                Uri uri = intent.getData();

                if (uri != null) {
                    String json = call.argument("json");
                    String error = call.argument("error");
                    String success = call.argument("success");

                    try {
                        OutputStream stream = getContentResolver().openOutputStream(uri, "wt");
                        Objects.requireNonNull(stream).write(Objects.requireNonNull(json).getBytes());
                        stream.close();

                        showToast(success, true);
                    } catch (IOException e) {
                        showToast(error, true);
                    }
                }
            } else if (requestCode == ACTION_OPEN_BACKUP_FILE) {
                Uri uri = intent.getData();

                if (uri != null) {
                    String name = "";

                    try (Cursor cursor = getContentResolver().query(uri, null, null, null)) {
                        if (cursor != null && cursor.moveToFirst()) {
                            name = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                        }
                    }

                    if (name.equals(BACKUP_FILE_NAME)) {
                        StringBuilder builder = new StringBuilder();

                        try {
                            InputStream stream = getContentResolver().openInputStream(uri);
                            InputStreamReader inputStreamReader = new InputStreamReader(stream);
                            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                            String json;

                            while ((json = bufferedReader.readLine()) != null) builder.append(json);

                            result.success(builder.toString());
                        } catch (IOException e) {
                            showToast(call.argument("unknownError"), true);
                        }
                    } else {
                        showToast(call.argument("notFound"), true);
                    }
                }
            }
        }

        super.onActivityResult(requestCode, resultCode, intent);
    }

    private void createBackupFile() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
            intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse(DOWNLOADS_FOLDER));
            intent.putExtra(Intent.EXTRA_TITLE, BACKUP_FILE_NAME);
            intent.addCategory(Intent.CATEGORY_OPENABLE);
            intent.setType("application/json");

            startActivityForResult(intent, ACTION_CREATE_BACKUP_FILE);
        }
    }

    private void getBackupFile() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
            intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, Uri.parse(DOWNLOADS_FOLDER));
            intent.addCategory(Intent.CATEGORY_OPENABLE);
            intent.setType("application/json");

            startActivityForResult(intent, ACTION_OPEN_BACKUP_FILE);
        }
    }

    private void getSingleNoteWidgetLaunchDetails() {
        Intent intent = getIntent();

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("noteId", intent.getStringExtra(SingleNoteWidgetProvider.EXTRA_NOTE_ID));
        hashMap.put("launchAction", intent.getIntExtra(SingleNoteWidgetProvider.EXTRA_LAUNCH_ACTION, -1));

        result.success(hashMap);
    }

    private void showToast(String message, boolean brief) {
        Toast.makeText(getApplicationContext(), message, brief ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG).show();
    }

    private void getAppVersion() {
        try {
           PackageInfo packageInfo = getApplicationContext().getPackageManager()
                    .getPackageInfo(getApplicationContext().getPackageName(), 0);

            result.success(packageInfo.versionName);
        } catch (PackageManager.NameNotFoundException e) {
            result.success("???");
        }
    }


    void openNotificationSettings() {
        Intent intent;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            intent = new Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    .putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName());
        } else {
            intent = new Intent("android.settings.APP_NOTIFICATION_SETTINGS")
                    .putExtra("app_package", getPackageName())
                    .putExtra("app_uid", getApplicationInfo().uid);
        }

        startActivity(intent);
    }

    void getSoundUri() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent intent = new Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
                    .putExtra(Settings.EXTRA_APP_PACKAGE, getPackageName())
                    .putExtra(Settings.EXTRA_CHANNEL_ID, "Note_Notification_ID");

            startActivity(intent);
        } else {
            String soundUri = call.argument("soundUri");
            Intent intent = new Intent(RingtoneManager.ACTION_RINGTONE_PICKER);
            Uri uri = soundUri == null
                    ? RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                    : Uri.parse(soundUri);

            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_NOTIFICATION);
            intent.putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, uri);

            startActivityForResult(intent, 1);
        }
    }
}
