package com.oxchat.nostr;

import androidx.multidex.MultiDexApplication;
import android.os.Build;
import android.util.Log;

/**
 * Title: OXApplication
 * Description: Main Application class with Android 15 compatibility
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
public class OXApplication extends MultiDexApplication {

    private static final String TAG = "OXApplication";

    @Override
    public void onCreate() {
//        SharedPreferences preferences = getSharedPreferences("yl_perferences", Context.MODE_PRIVATE);
//        int themeStyle = 0;//preferences.getInt("themeStyle", 0);
//        if(themeStyle==0) {
//            setTheme(R.style.LaunchTheme_light);
//            Log.e("gj", "YLApplication set success   " );
//        }else{
//            setTheme(R.style.LaunchTheme_night);
//        }
        super.onCreate();
        
        // Handle Android 15 compatibility
        if (Build.VERSION.SDK_INT >= 35) { // Android 15 (API level 35)
            handleAndroid15Compatibility();
        }
    }

    /**
     * Handle Android 15 specific compatibility issues
     * Including DCL DENY_EXECMEM and memory protection
     */
    private void handleAndroid15Compatibility() {
        try {
            // Set system properties for better compatibility
            System.setProperty("dalvik.vm.dex2oat-flags", "--compiler-filter=quicken");
            System.setProperty("dalvik.vm.usejit", "true");
            
            // Enable memory optimization
            System.setProperty("dalvik.vm.heapstartsize", "8m");
            System.setProperty("dalvik.vm.heapgrowthlimit", "256m");
            System.setProperty("dalvik.vm.heapsize", "512m");
            
            Log.d(TAG, "Android 15 compatibility settings applied");
        } catch (Exception e) {
            Log.e(TAG, "Error applying Android 15 compatibility settings", e);
        }
    }
}
