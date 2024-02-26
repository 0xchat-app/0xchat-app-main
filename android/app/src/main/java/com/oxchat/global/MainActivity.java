package com.oxchat.global;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.oxchat.global.channel.AppPreferences;
import com.oxchat.global.util.SharedPreUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.net.URLDecoder;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {
    AppPreferences mAppPreferences;
    private final String CODE_SHARE_NEW_MSG_TO_CHAT = "shareNewMessageToChat";

    public static NewMyEngineIntentBuilder withNewEngine(Class<? extends FlutterFragmentActivity> activityClass) {
        return new NewMyEngineIntentBuilder(activityClass);
    }

    //Rewrite engine method
    public static class NewMyEngineIntentBuilder extends NewEngineIntentBuilder {

        protected NewMyEngineIntentBuilder(Class<? extends FlutterFragmentActivity> activityClass) {
            super(activityClass);
        }
    }

    public static String getFullRoute(String route, String params) {
        //Splicing parameter
        JSONObject jsonObject = new JSONObject();
        try {
            if (!TextUtils.isEmpty(params)) {
                jsonObject.put("pageParams", new JSONObject(params));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return route + "?" + jsonObject.toString();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        handleIntent(getIntent());
    }

    @Override
    protected void onResume() {
        super.onResume();
        getOpenData();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleIntent(intent);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        mAppPreferences = new AppPreferences();
        Log.e("John:", "--configureFlutterEngine--mAppPreferences =" + mAppPreferences.hashCode());
        flutterEngine.getPlugins().add(mAppPreferences);

    }

    private void getOpenData() {
        try {
            Uri uridata = getIntent().getData();
            if (uridata == null) {
                return;
            }
            String param = uridata.toString();
            if (!TextUtils.isEmpty(param)) {
                try {
                    android.content.SharedPreferences sp = this.getSharedPreferences(SharedPreUtils.SP_NAME, Context.MODE_PRIVATE);
                    if (sp != null) {
                        SharedPreferences.Editor e = sp.edit();
                        e.putString(SharedPreUtils.PARAM_JUMP_INFO, param);
                        e.apply();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            Log.e("scheme-", e.getMessage(), e);
        }
    }

    void handleIntent(Intent intent) {
        String action = intent.getAction();
        String type = intent.getType();
        if (Intent.ACTION_SEND.equals(action) && type != null && "text/plain".equals(type)) {
            // Process received text (may contain URLs)
            String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
            if (mAppPreferences != null) {
                Log.e("John:", "--handleIntent--mAppPreferences =" + mAppPreferences.hashCode());
                Log.e("John:", "--handleIntent--mAppPreferences.mCSink =" + mAppPreferences.mCSink);
            }
            if (mAppPreferences != null && mAppPreferences.mCSink != null)
                Log.e("John:", "--handleIntent--mAppPreferences =" + mAppPreferences.mCSink.hashCode());
            if (sharedText != null && mAppPreferences != null && mAppPreferences.mCSink != null) {
                //use url in here
                HashMap<String, String> event = new HashMap<>();
                event.put("type", CODE_SHARE_NEW_MSG_TO_CHAT);
                event.put("data", sharedText);
                mAppPreferences.mCSink.success(event);
            }
        }

    }
}
