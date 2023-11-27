package com.oxchat.global.channel;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import com.oxchat.global.MultiEngineActivity;
import com.oxchat.global.util.SharedPreUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
        } else if (call.method.equals("getPubKey")){
            List<String> proList = new ArrayList<>();
            proList.add("login");
            proList.add("测试");
            String[] stringArray = proList.toArray(new String[0]);
            for (String s : stringArray) {
                Log.e("Michael", "数组的值----s ="+s);
            }
            Cursor tempResult = mContext.getContentResolver().query(
                    Uri.parse("content://com.greenart7c3.nostrsigner.GET_PUBLIC_KEY"),
                    proList.toArray(new String[0]), null,null,null
            );
            if (tempResult != null) {
                try {
                    while (tempResult.moveToNext()) {
                        int columnIndex = tempResult.getColumnIndex("login");
                        if (columnIndex >= 0) {
                            // 确保列索引有效
                            String login = tempResult.getString(columnIndex);
                            Log.e("Michael", "----login ="+login);
                            // 此处处理 login 变量
                        } else {
                            // 列 "login" 在结果中不存在
                            // 此处处理错误或执行替代操作
                        }
                    }
                } finally {
                    tempResult.close();
                }
            }
        }
    }


}
