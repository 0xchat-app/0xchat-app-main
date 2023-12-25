package com.ox.ox_common.utils;

import android.content.Context;
import android.graphics.Color;

import com.luck.picture.lib.style.AlbumWindowStyle;
import com.luck.picture.lib.style.BottomNavBarStyle;
import com.luck.picture.lib.style.PictureSelectorStyle;
import com.luck.picture.lib.style.SelectMainStyle;
import com.luck.picture.lib.style.TitleBarStyle;
import com.ox.ox_common.R;

import java.util.Map;

import androidx.core.content.ContextCompat;

public class PictureStyleUtil {

    private Context context;
    private PictureSelectorStyle selectorStyle = new PictureSelectorStyle();
    public PictureStyleUtil(Context context) {
        this.context = context;
    }

    public PictureSelectorStyle getSelectorStyle() {
        return selectorStyle;
    }

    /**
     * Album theme
     * @param uiColor
     * @return
     */

    public void setStyle(Map<String, Number> uiColor) {

        int a = 255;
        int r = 255;
        int g = 255;
        int b = 255;
        int l = 255;
        Number aNumber = uiColor.get("a");
        if (aNumber != null) {
            a = aNumber.intValue();
        }
        Number rNumber = uiColor.get("r");
        if (rNumber != null) {
            r = rNumber.intValue();
        }
        Number gNumber = uiColor.get("g");
        if (gNumber != null) {
            g = gNumber.intValue();
        }
        Number bNumber = uiColor.get("b");
        if (bNumber != null) {
            b = bNumber.intValue();
        }
        Number lNumber = uiColor.get("l");
        if (lNumber != null) {
            l = lNumber.intValue();
        }

        int argb = Color.argb(a, r, g, b);

        AlbumWindowStyle albumWindowStyle = selectorStyle.getAlbumWindowStyle();
        selectorStyle.setAlbumWindowStyle(albumWindowStyle);

        TitleBarStyle titleBarStyle = selectorStyle.getTitleBarStyle();
        titleBarStyle.setTitleBackgroundColor(argb);
        selectorStyle.setTitleBarStyle(titleBarStyle);

        BottomNavBarStyle bottomBarStyle = selectorStyle.getBottomBarStyle();
        bottomBarStyle.setBottomNarBarBackgroundColor(argb);
        bottomBarStyle.setBottomPreviewNarBarBackgroundColor(argb);
        selectorStyle.setBottomBarStyle(bottomBarStyle);

        SelectMainStyle selectMainStyle = selectorStyle.getSelectMainStyle();
        selectMainStyle.setStatusBarColor(argb);
        selectMainStyle.setSelectNumberStyle(true);

        selectorStyle.setSelectMainStyle(selectMainStyle);
        albumWindowStyle.setAlbumAdapterItemSelectStyle(R.drawable.num_oval_black);
        if (l > (int) (255 * 0.7)) {
            int color = ContextCompat.getColor(context, R.color.bar_grey);
            titleBarStyle.setTitleLeftBackResource(R.drawable.black_back);
            titleBarStyle.setTitleTextColor(color);
            titleBarStyle.setTitleCancelTextColor(color);

            bottomBarStyle.setBottomPreviewSelectTextColor(color);
            bottomBarStyle.setBottomEditorTextColor(color);
            bottomBarStyle.setBottomOriginalTextColor(color);
            bottomBarStyle.setBottomPreviewNormalTextColor(color);
            bottomBarStyle.setBottomSelectNumTextColor(color);

            selectMainStyle.setSelectTextColor(color);
        }else{

            int color = ContextCompat.getColor(context, R.color.white);
            titleBarStyle.setTitleLeftBackResource(R.drawable.back);
            titleBarStyle.setTitleTextColor(color);
            titleBarStyle.setTitleCancelTextColor(color);

            bottomBarStyle.setBottomPreviewSelectTextColor(color);
            bottomBarStyle.setBottomEditorTextColor(color);
            bottomBarStyle.setBottomOriginalTextColor(color);
            bottomBarStyle.setBottomPreviewNormalTextColor(color);
            bottomBarStyle.setBottomSelectNumTextColor(color);

            selectMainStyle.setSelectTextColor(color);
        }
        bottomBarStyle.setBottomSelectNumResources(R.drawable.num_oval_black_def);

        selectMainStyle.setPreviewBackgroundColor(ContextCompat.getColor(context, R.color.white));
        selectMainStyle.setAdapterSelectTextColor(ContextCompat.getColor(context, R.color.white));
        selectMainStyle.setSelectBackground(R.drawable.num_oval_black_def);
        selectMainStyle.setSelectNormalTextColor(ContextCompat.getColor(context,R.color.white));
        selectMainStyle.setPreviewSelectNumberStyle(true);

    }


}
