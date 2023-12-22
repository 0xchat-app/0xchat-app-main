package com.ox.ox_common.views;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.VideoView;

/**
 * Created by lisen on 2018-09-15.
 *
 * @author lisen < 453354858@qq.com >
 */

public class FullScreenVideoView extends VideoView {
    public FullScreenVideoView(Context context) {
        super(context);
    }

    public FullScreenVideoView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public FullScreenVideoView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }
    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
//        int width = getDefaultSize(0, widthMeasureSpec);
//        int height = getDefaultSize(0, heightMeasureSpec);
//        setMeasuredDimension(width, heightMeasureSpec);


    }

    @Override
    public void start() {
        super.start();
        if (playerLisetener != null){
            playerLisetener.onStart();
        }
    }
    public interface PlayerLisetener{
        void onStart();
    }
    private PlayerLisetener playerLisetener;

    public void setPlayerLisetener(PlayerLisetener playerLisetener) {
        this.playerLisetener = playerLisetener;
    }
}
