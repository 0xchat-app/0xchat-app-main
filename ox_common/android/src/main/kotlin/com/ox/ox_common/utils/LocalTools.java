package com.ox.ox_common.utils;

import android.content.Context;
import android.provider.Settings;

/**
 * Title: LocalTools
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
public class LocalTools {

    public static String getAndroidId(Context context) {
        String ANDROID_ID = Settings.System.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        return ANDROID_ID;
    }
}
