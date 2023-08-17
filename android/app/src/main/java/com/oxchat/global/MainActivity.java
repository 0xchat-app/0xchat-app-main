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

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterShellArgs;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    public static NewMyEngineIntentBuilder withNewEngine(Class<? extends FlutterActivity> activityClass) {
        return new NewMyEngineIntentBuilder(activityClass);
    }

    //Rewrite engine method
    public static class NewMyEngineIntentBuilder extends NewEngineIntentBuilder{

        protected NewMyEngineIntentBuilder(Class<? extends FlutterActivity> activityClass) {
            super(activityClass);
        }
    }

    public static String getFullRoute(String route,String params){
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
    }

    @Override
    protected void onResume() {
        super.onResume();
        getOpenData();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
    }

    @Override
    public FlutterShellArgs getFlutterShellArgs() {
        FlutterShellArgs supFA = super.getFlutterShellArgs();

        return supFA;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        flutterEngine.getPlugins().add(new AppPreferences());

    }

    private void getOpenData(){
        try {
            Uri uridata = getIntent().getData();
            if (uridata==null){
                return;
            }
            String param = uridata.getQueryParameter("param");
            try {
                param = URLDecoder.decode(param, "UTF-8");
            } catch (Exception e) {
                param = "";
            }
            if(!TextUtils.isEmpty(param)) {
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
}
