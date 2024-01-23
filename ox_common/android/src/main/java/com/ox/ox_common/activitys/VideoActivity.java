package com.ox.ox_common.activitys;

import android.content.Context;
import android.content.res.Configuration;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.bumptech.glide.Glide;
import com.ox.ox_common.R;

import java.io.File;

import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

public class VideoActivity extends BaseActivity{
    private static final int READ_SDCARD = 101;
    public static final String VIDEO_PATH = "VIDEO_PATH";
    public static final String THUMB_PATH = "THUMB_PATH";
    VideoView videoView;
    LinearLayout layout_root;
    RelativeLayout videoParent;

    ImageView iv_src;
    ProgressBar progressBar;

    private String videoPath;
    private String thumbPath;

    private DisplayMetrics outMetrics;
    private int videoHeight,videoWidth;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video);
        videoView = findViewById(R.id.videoView);
        layout_root = findViewById(R.id.layout_root);
        videoParent = findViewById(R.id.videoParent);
        iv_src = findViewById(R.id.iv_src);
        progressBar = findViewById(R.id.progressBar);

        videoPath = getIntent().getStringExtra(VIDEO_PATH);
        thumbPath = getIntent().getStringExtra(THUMB_PATH);

        WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);

        startPlay();
    }

    protected void startPlay() {
        if (!TextUtils.isEmpty(thumbPath)){
            Glide.with(this).asBitmap().load(thumbPath).into(iv_src);
            iv_src.setVisibility(View.VISIBLE);
        }
        //Online video URL or local video path

        Uri uri;
        if (videoPath.startsWith("http")){
            uri = Uri.parse(videoPath);
        }else{
            if (Build.VERSION.SDK_INT >= 24) {
                uri = FileProvider.getUriForFile(this, getPackageName() + ".luckProvider", new File(videoPath));
            }else{
                uri = Uri.parse(videoPath);
            }
        }


        videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mediaPlayer) {
                videoHeight = mediaPlayer.getVideoHeight();
                videoWidth = mediaPlayer.getVideoWidth();
                updateVideoViewSize();
                mediaPlayer.setVideoScalingMode(MediaPlayer.VIDEO_SCALING_MODE_SCALE_TO_FIT);
                mediaPlayer.setOnInfoListener(new MediaPlayer.OnInfoListener() {
                    @Override
                    public boolean onInfo(MediaPlayer mp, int what, int extra) {
                        if (what == MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START){
                            iv_src.setVisibility(View.GONE);
                            progressBar.setVisibility(View.GONE);
                        }
                        return true;
                    }
                });
            }
        });

        videoView.setVideoURI(uri);

        videoView.start();

        layout_root.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        //Playback completion callback
        videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mediaPlayer) {
                finish();
            }
        });
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT){
            updateVideoViewSize();
        }else if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE){
            updateVideoViewSize();
        }
    }

    private void updateVideoViewSize() {
        if (videoHeight == 0 || videoWidth == 0){
            return;
        }
        Configuration mConfiguration = getResources().getConfiguration(); //Retrieve the configured settings information
        if (mConfiguration.orientation == Configuration.ORIENTATION_PORTRAIT){
            RelativeLayout.LayoutParams videoViewParam;
            float height = ((videoHeight*1f / videoWidth) * outMetrics.widthPixels);
            videoViewParam = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, (int) height);
            videoViewParam.addRule(RelativeLayout.CENTER_IN_PARENT);
            videoView.setLayoutParams(videoViewParam);
        }else{
            RelativeLayout.LayoutParams videoViewParam;
            float width = ((videoWidth*1f / videoHeight) * outMetrics.widthPixels);
            videoViewParam = new RelativeLayout.LayoutParams((int) width,RelativeLayout.LayoutParams.MATCH_PARENT);
            videoViewParam.addRule(RelativeLayout.CENTER_IN_PARENT);
            videoView.setLayoutParams(videoViewParam);
        }
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (videoView != null) {
            videoView.suspend();
        }
    }
}
