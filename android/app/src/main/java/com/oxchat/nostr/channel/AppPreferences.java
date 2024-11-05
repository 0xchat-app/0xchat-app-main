package com.oxchat.nostr.channel;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import androidx.annotation.NonNull;

import com.oxchat.nostr.MultiEngineActivity;
import com.oxchat.nostr.util.SharedPreUtils;
import com.oxchat.nostr.VoiceCallService;
import java.util.HashMap;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Title: ApplicationPreferences
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
public class AppPreferences implements MethodChannel.MethodCallHandler, FlutterPlugin, ActivityAware {
    private static final String OX_PERFERENCES_CHANNEL = "com.oxchat.global/perferences";
    private Context mContext;
    private Activity mActivity;
    private MethodChannel.Result mMethodChannelResult;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        mContext = binding.getApplicationContext();
        MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), OX_PERFERENCES_CHANNEL);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        mMethodChannelResult = result;
        HashMap paramsMap = null;
        if (call.arguments instanceof HashMap) {
            paramsMap = (HashMap) call.arguments;
        }
        switch (call.method) {
            case "isAppInBackground" -> {
                Log.e("Michael:" ,"----onMethodCall----isAppInBackground  ");
                boolean isAppInBackground = isAppInBackground();
                result.success(isAppInBackground);
            }
            case "startVoiceCallService" -> {
                String title = "";
                String content = "";
                if (paramsMap != null && paramsMap.containsKey(VoiceCallService.VOICE_TITLE_STR)) {
                    title = (String) paramsMap.get(VoiceCallService.VOICE_TITLE_STR);
                }
                if (paramsMap != null && paramsMap.containsKey(VoiceCallService.VOICE_CONTENT_STR)) {
                    content = (String) paramsMap.get(VoiceCallService.VOICE_CONTENT_STR);
                }
                Intent serviceIntent = new Intent(mContext, VoiceCallService.class);
                serviceIntent.putExtra(VoiceCallService.VOICE_TITLE_STR, title);
                serviceIntent.putExtra(VoiceCallService.VOICE_CONTENT_STR, content);
                mContext.startForegroundService(serviceIntent);
            }
            case "stopVoiceCallService" -> {
                Intent serviceIntent = new Intent(mContext, VoiceCallService.class);
                mContext.stopService(serviceIntent);
            }
            case "getAppOpenURL" -> {
                SharedPreferences preferences = mContext.getSharedPreferences(SharedPreUtils.SP_NAME, Context.MODE_PRIVATE);
                String jumpInfo = preferences.getString(SharedPreUtils.PARAM_JUMP_INFO, "");
                SharedPreferences.Editor e = preferences.edit();
                e.remove(SharedPreUtils.PARAM_JUMP_INFO);
                e.apply();
                if (mMethodChannelResult != null) {
                    mMethodChannelResult.success(jumpInfo);
                    mMethodChannelResult = null;
                }
            }
            case "changeTheme" -> {
                int themeStyle = 0;
                if (paramsMap != null && paramsMap.containsKey("themeStyle")) {
                    themeStyle = (int) paramsMap.get("themeStyle");
                }
                SharedPreferences preferences = mContext.getSharedPreferences(SharedPreUtils.SP_NAME, Context.MODE_PRIVATE);
                preferences.edit().putInt("themeStyle", themeStyle);
                if (themeStyle == 0) {
                    //TODO light
                } else {
                    //TODO Dark
                }
            }
            case "showFlutterActivity" -> {
                String route = null;
                if (paramsMap != null && paramsMap.containsKey("route")) {
                    route = (String) paramsMap.get("route");
                }
                String params = null;
                if (paramsMap.containsKey("params")) {
                    params = (String) paramsMap.get("params");
                }
                Intent intent = MultiEngineActivity
                        .withNewEngine(MultiEngineActivity.class)
                        .initialRoute(MultiEngineActivity.getFullRoute(route, params))
                        .build(mContext);
                //intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                mActivity.startActivity(intent);
            }
        }
    }

    private boolean isAppInBackground() {
        ActivityManager activityManager = (ActivityManager) mActivity.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> runningApps = activityManager.getRunningAppProcesses();
        for (ActivityManager.RunningAppProcessInfo processInfo : runningApps) {
            if (processInfo.processName.equals(mActivity.getPackageName())) {
                if (processInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                    //ActivityState", "App is in the foreground.  is see
                    return false;
                } else {
                    //ActivityState", "App is in the background.
                    return true;
                }
            }
        }
        return false;
    }
}
