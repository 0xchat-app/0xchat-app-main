package com.oxchat.global;

import androidx.multidex.MultiDexApplication;

/**
 * Title: YLApplication
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2023
 *
 * @author john
 * @CheckItem Fill in by oneself
 * @since JDK1.8
 */
public class OXApplication extends MultiDexApplication {


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

    }
}
