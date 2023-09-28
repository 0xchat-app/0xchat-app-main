package com.oxchat.global.channel;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import androidx.annotation.NonNull;

import com.oxchat.global.MultiEngineActivity;
import com.oxchat.global.util.SharedPreUtils;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
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
        HashMap paramsMap = null;
        if (call.arguments != null && call.arguments instanceof HashMap) {
            paramsMap = (HashMap) call.arguments;
        }
        if (call.method.equals("getAppOpenURL")) {
            SharedPreferences preferences = mContext.getSharedPreferences(SharedPreUtils.SP_NAME, Context.MODE_PRIVATE);
            String jumpInfo = preferences.getString(SharedPreUtils.PARAM_JUMP_INFO, "");
            result.success(jumpInfo);

            SharedPreferences.Editor e = preferences.edit();
            e.putString(SharedPreUtils.PARAM_JUMP_INFO, "");
            e.apply();
        } else if (call.method.equals("changeTheme")) {
            int themeStyle = (int) paramsMap.get("themeStyle");
            SharedPreferences preferences = mContext.getSharedPreferences(SharedPreUtils.SP_NAME, Context.MODE_PRIVATE);
            preferences.edit().putInt("themeStyle", themeStyle);
            if (themeStyle == 0) {
               //TODO light
            } else {
                //TODO Dark
            }
        } else if (call.method.equals("showFlutterActivity")) {

            String route = null;
            if (paramsMap.containsKey("route")) {
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
//            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            mActivity.startActivity(intent);
        }
    }


}
