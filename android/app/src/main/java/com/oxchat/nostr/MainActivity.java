package com.oxchat.nostr;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.oxchat.nostr.channel.AppPreferences;
import com.oxchat.nostr.util.Constant;
import com.oxchat.nostr.util.SharedPreUtils;
import com.oxchat.nostr.util.Tools;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterFragmentActivity {

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
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onResume() {
        super.onResume();
        getOpenData(getIntent());
        handleIntent(getIntent());
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        getOpenData(getIntent());
        handleIntent(getIntent());
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        flutterEngine.getPlugins().add(new AppPreferences());

    }

    private void getOpenData(Intent intent) {
        try {
            Uri uridata = intent.getData();
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
        if (type != null) {
            if (Intent.ACTION_SEND.equals(action)) {
                if (type.startsWith("text/")) {//Process text types (may include image url)
                    // Process received text (may contain URLs)
                    String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
                    if (sharedText != null && !sharedText.isEmpty()) {
                        //use url in here
                        try {
                            SharedPreUtils sp = new SharedPreUtils(this);
                            String schemeUrl = Constant.APP_SCHEME + Constant.APP_SCHEME_SHARE + URLEncoder.encode(sharedText, "UTF-8") + Constant.APP_SCHEME_SHARE_TYPE + "text";
                            SharedPreferences.Editor e = sp.getSharedPreferences().edit();
                            e.putString(SharedPreUtils.PARAM_JUMP_INFO, schemeUrl);
                            e.apply();
                            intent.removeExtra(Intent.EXTRA_TEXT);
                            //may include image url
                        } catch (Exception e) {
                            Log.e("JSONException", Objects.requireNonNull(e.getMessage()));
                        }
                    }
                } else if (type.startsWith("image/")) {
                    Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
                    if (uri != null) handleSharedImage(uri);
                    intent.removeExtra(Intent.EXTRA_STREAM);
                } else if (type.startsWith("application/")) {
                    Uri uri = intent.getParcelableExtra(Intent.EXTRA_STREAM);
                    if (uri != null) handleSharedFile(uri);
                    intent.removeExtra(Intent.EXTRA_STREAM);
                }
            }
        }
    }

    private void handleSharedImage(Uri uri) {//share mobile local image to 0xchat
        try {
            File file = Tools.copyToCache(this, uri, "shared_image_" + System.currentTimeMillis() + ".jpg");
            SharedPreUtils sp = new SharedPreUtils(this);
            String schemeUrl = Constant.APP_SCHEME + Constant.APP_SCHEME_SHARE + Constant.APP_SCHEME_SHARE_TYPE + "image" + Constant.APP_SCHEME_SHARE_PATH + file.getAbsolutePath()
                    + Constant.APP_SCHEME_SHARE_NAME + file.getName();
            SharedPreferences.Editor e = sp.getSharedPreferences().edit();
            e.putString(SharedPreUtils.PARAM_JUMP_INFO, schemeUrl);
            e.apply();
        } catch (Exception e) {
            Log.e("io", Objects.requireNonNull(e.getMessage()));
        }
    }

    private void handleSharedFile(Uri uri) {//share mobile local file to 0xchat
        try {
            String fileName = Tools.getFileName(this, uri);
            File file = Tools.copyToCache(this, uri, fileName);
            SharedPreUtils sp = new SharedPreUtils(this);
            String schemeUrl = Constant.APP_SCHEME + Constant.APP_SCHEME_SHARE + Constant.APP_SCHEME_SHARE_TYPE + "file" + Constant.APP_SCHEME_SHARE_PATH + file.getAbsolutePath()
                    + Constant.APP_SCHEME_SHARE_NAME + fileName;
            SharedPreferences.Editor e = sp.getSharedPreferences().edit();
            e.putString(SharedPreUtils.PARAM_JUMP_INFO, schemeUrl);
            e.apply();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
