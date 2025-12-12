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
                getString(R.string.voice_call_service_name),
                NotificationManager.IMPORTANCE_DEFAULT
        );
        channel.setDescription(getString(R.string.voice_call_service_description));
        NotificationManager manager = getSystemService(NotificationManager.class);
        manager.createNotificationChannel(channel);
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);
        
        // Enhanced notification to clearly indicate foreground service usage
        String notificationTitle = voiceTitle != null ? voiceTitle : getString(R.string.voice_call_notification_title);
        String notificationText = voiceContent != null ? 
            getString(R.string.voice_call_notification_text).replace("Tap to return to call", voiceContent) : 
            getString(R.string.voice_call_notification_text);
            
        Notification notification = new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("🔊 " + notificationTitle)
                .setContentText("📱 " + notificationText)
                .setSubText(getString(R.string.voice_call_notification_subtext))
                .setContentIntent(pendingIntent)
                .setSmallIcon(R.mipmap.ic_notification)
                .setOngoing(true)
                .setVisibility(Notification.VISIBILITY_PUBLIC)
                .setPriority(Notification.PRIORITY_HIGH)
                .setCategory(Notification.CATEGORY_CALL)
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