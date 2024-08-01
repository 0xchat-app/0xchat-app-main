package com.oxchat.global;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

public class VoiceCallService extends Service {
    private static final String CHANNEL_ID = "VoiceCallServiceChannel";

    @Override
    public void onCreate() {
        super.onCreate();

        NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "Voice Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
        );
        NotificationManager manager = getSystemService(NotificationManager.class);
        manager.createNotificationChannel(channel);

        Notification notification = new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("Voice Service")
                .setContentText("Running in background")
                .setSmallIcon(R.mipmap.ox_logo_launcher)
                .build();
        startForeground(1, notification);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Handle the start command here
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