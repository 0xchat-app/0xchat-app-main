package com.oxchat.global.channel;

import static android.app.Activity.RESULT_OK;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import com.dexterous.flutterlocalnotifications.utils.LongUtils;
import com.oxchat.global.MultiEngineActivity;
import com.oxchat.global.util.SharedPreUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Title: ApplicationPreferences
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
public class AppPreferences implements MethodChannel.MethodCallHandler, FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener {
    private static final String OX_PERFERENCES_CHANNEL = "com.oxchat.global/perferences";
    private Context mContext;
    private Activity mActivity;
    private MethodChannel.Result mMethodChannelResult;
    private int mSignatureRequestCode = 101;

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
        binding.addActivityResultListener(this);

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
        } else if (call.method.equals("nostrsigner")) {
            String extendParse = "";
            if (paramsMap.containsKey("extendParse")) {
                extendParse = (String) paramsMap.get("extendParse");
            }
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("nostrsigner:" + extendParse));
            intent.setPackage("com.greenart7c3.nostrsigner");
            String type = "get_public_key";
            if (paramsMap.containsKey("type")) {
                type = (String) paramsMap.get("type");
            }
            intent.putExtra("type", type);
            if (paramsMap.containsKey("id")) {
                String id = (String) paramsMap.get("id");
                intent.putExtra("id", id);
            }
            if (paramsMap.containsKey("current_user")) {
                String current_user = (String) paramsMap.get("current_user");
                intent.putExtra("current_user", current_user);
            }
            if (paramsMap.containsKey("pubKey")) {
                String pubKey = (String) paramsMap.get("pubKey");
                intent.putExtra("pubKey", pubKey);
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            if (paramsMap.containsKey("requestCode")) {
                mSignatureRequestCode = (int) paramsMap.get("requestCode");
            }
            mActivity.startActivityForResult(intent, mSignatureRequestCode);


        }
    }

    public boolean onActivityResult(int requestCode, int resultCode, Intent result) {
        if (mSignatureRequestCode == requestCode) {
            if (resultCode == RESULT_OK && result != null) {
                Map<String, String> dataMap = new HashMap<>();
                if (result.hasExtra("signature")) {
                    String signature = result.getStringExtra("signature");
                    dataMap.put("signature", signature);
                }
                if (result.hasExtra("id")) {
                    String id = result.getStringExtra("id");
                    dataMap.put("id", id);
                }
                if (result.hasExtra("event")) {
                    String event = result.getStringExtra("event");
                    dataMap.put("event", event);
                }
                if (mMethodChannelResult != null) {
                    mMethodChannelResult.success(dataMap);
                }
            } else {
                if (mMethodChannelResult != null) {
                    mMethodChannelResult.success(null);
                }
            }
        }
        return false;
    }
}
