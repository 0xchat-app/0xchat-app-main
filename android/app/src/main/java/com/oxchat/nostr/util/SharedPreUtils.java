package com.oxchat.nostr.util;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Objects;

/**
 * Title: SharedPreUtils
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author Michael
 * @since JDK1.8
 */
public class SharedPreUtils {
    public static final String SP_NAME = "ox_perferences";
    public static String PARAM_JUMP_INFO = "param_jump_info";


    private SharedPreferences sharedPreferences;


    public SharedPreUtils(Context context) {
        sharedPreferences = context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
    }

    public SharedPreferences getSharedPreferences() {
        return sharedPreferences;
    }

    public void saveHashMap(HashMap<String, String> hashMap, String saveKey) {
        SharedPreferences.Editor editor = sharedPreferences.edit();
        JSONObject jsonObject = new JSONObject();

        for (Map.Entry<String, String> entry : hashMap.entrySet()) {
            try {
                jsonObject.put(entry.getKey(), entry.getValue());
            } catch (JSONException e) {
                Log.e("JSONException", Objects.requireNonNull(e.getMessage()));
            }
        }
        editor.putString(saveKey, jsonObject.toString());
        editor.apply();
    }

    public HashMap<String, String> getHashMap(String saveKey) {
        HashMap<String, String> hashMap = new HashMap<>();
        String json = sharedPreferences.getString(saveKey, "{}");
        try {
            JSONObject jsonObject = new JSONObject(json);
            Iterator<String> keys = jsonObject.keys();

            while (keys.hasNext()) {
                String key = keys.next();
                String value = jsonObject.getString(key);
                hashMap.put(key, value);
            }
        } catch (JSONException e) {
            Log.e("JSONException", Objects.requireNonNull(e.getMessage()));
        }

        return hashMap;
    }
}
