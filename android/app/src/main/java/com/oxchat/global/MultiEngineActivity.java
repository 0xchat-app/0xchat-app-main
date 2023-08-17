package com.oxchat.global;

import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.oxchat.global.channel.AppPreferences;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * Title: MultiEngineActivity
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
public class MultiEngineActivity extends FlutterFragmentActivity {
    public static MultiEngineActivity.NewMyEngineIntentBuilder withNewEngine(Class<? extends FlutterFragmentActivity> activityClass) {
        return new MultiEngineActivity.NewMyEngineIntentBuilder(activityClass);
    }

    public static class NewMyEngineIntentBuilder extends NewEngineIntentBuilder{

        protected NewMyEngineIntentBuilder(Class<? extends FlutterFragmentActivity> activityClass) {
            super(activityClass);
        }
    }

    public static String getFullRoute(String route,String params){

        JSONObject jsonObject = new JSONObject();
        try {
            if (!TextUtils.isEmpty(params)) {
                jsonObject.put("pageParams", new JSONObject(params));
            }
        } catch (JSONException e) {
            Log.e("multi", e.getMessage());
        }
        return route + "?" + jsonObject.toString();
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        flutterEngine.getPlugins().add(new AppPreferences());

    }
}
