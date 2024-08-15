package com.oxchat.nostr;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;

import com.oxchat.nostr.R;

public class VoiceCallService extends Service {
    private static final String CHANNEL_ID = "VoiceCallServiceChannel";
    public static final String VOICE_TITLE_STR = "notice_voice_title";
    public static final String VOICE_CONTENT_STR = "notice_voice_content";
    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String voiceTitle = intent.getStringExtra(VOICE_TITLE_STR);
        String voiceContent = intent.getStringExtra(VOICE_CONTENT_STR);
        // Handle the start command here
        NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "Voice Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
        );
        NotificationManager manager = getSystemService(NotificationManager.class);
        manager.createNotificationChannel(channel);
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
        Notification notification = new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle(voiceTitle)
                .setContentText(voiceContent)
                .setContentIntent(pendingIntent)
                .setSmallIcon(R.mipmap.ox_logo_launcher)
                .build();
        startForeground(1, notification);
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        stopForeground(true);
    }
}