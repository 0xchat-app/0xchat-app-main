package com.ox.ox_common.activitys;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.MimeTypeMap;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.VideoView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.Priority;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.ox.ox_common.R;
import com.ox.ox_common.utils.AppPath;
import com.ox.ox_common.utils.CommonUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

@SuppressWarnings("all")
public class PhotosActivity extends BaseActivity {


    public static final String IMAGES = "IMAGES";
    public static final String CURRENT_POSITION = "CURRENT_POSITION";
    ViewPager viewPager;
    LinearLayout layout_tip;

    private List<String> images;
    private Number currentPosition;


    private LayoutInflater inflater;

    private DisplayMetrics outMetrics;
    private int videoHeight,videoWidth;
    private VideoView currentVideoView;
    private ImageView currentPlay;
    private ImageView currentSrc;

    private class Adapter extends PagerAdapter {

        @Override
        public int getCount() {
            return images.size();
        }

        @Override
        public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
            return view == object;
        }

        @NonNull
        @Override
        public Object instantiateItem(@NonNull final ViewGroup container, final int position) {
            View view = null;
            String url = images.get(position);
            String ext = MimeTypeMap.getFileExtensionFromUrl(url);
            String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ext);
            if (!TextUtils.isEmpty(mimeType) && mimeType.contains("video")){
                view = setupVideo(container,url);
            }else{
                view = setupImage(container,url);
            }

            container.addView(view);
            return view;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            View view = (View) object;
            container.removeView(view);
        }


        private View setupVideo(ViewGroup container,String videoPath){
            View view = inflater.inflate(R.layout.item_activity_video, container, false);
            VideoView videoView = view.findViewById(R.id.videoView);
            LinearLayout layout_root = view.findViewById(R.id.layout_root);
            ImageView iv_src = view.findViewById(R.id.iv_src);
            ImageView iv_play = view.findViewById(R.id.iv_play);
            iv_play.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (currentVideoView != null) {
                        currentVideoView.suspend();
                        currentVideoView = null;
                    }
                    Uri uri;
                    if (videoPath.startsWith("http")){
                        uri = Uri.parse(videoPath);
                    }else{
                        if (Build.VERSION.SDK_INT >= 24) {
                            uri = FileProvider.getUriForFile(PhotosActivity.this, getPackageName() + ".luckProvider", new File(videoPath));
                        }else{
                            uri = Uri.parse(videoPath);
                        }
                    }
                    currentVideoView = videoView;
                    currentPlay = iv_play;
                    //设置视频路径
                    videoView.setVideoURI(uri);

                    //开始播放视频
                    videoView.start();
                }
            });
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
                                iv_play.setVisibility(View.GONE);
                            }
                            return true;
                        }
                    });
                }
            });
            videoView.postDelayed(new Runnable() {
                @Override
                public void run() {
                    MediaMetadataRetriever retriever = new MediaMetadataRetriever();
                    if (videoPath.startsWith("http")){

                        final String fileName = videoPath.substring(videoPath.lastIndexOf("/") + 1).replaceAll("\\.","_")+".png";

                        AppPath appPath = new AppPath(PhotosActivity.this);
                        File file = new File(appPath.getAppImgDirPath(),fileName);
                        if(file.exists()){
                            Glide.with(PhotosActivity.this).load(file).into(iv_src);
                        }else{
                            try {
                                retriever.setDataSource(videoPath,new HashMap<>());
                                Bitmap bitmap = retriever.getFrameAtTime();
                                iv_src.setImageBitmap(bitmap);
                                CommonUtils.saveBitmapByPath(PhotosActivity.this,appPath.getAppImgDirPath(),fileName,bitmap);
                                retriever.release();
                            }catch (Exception e){
                                e.printStackTrace();
                            }
                        }

                    }else{
                        try {
                            retriever.setDataSource(videoPath);
                            Bitmap bitmap = retriever.getFrameAtTime();
                            iv_src.setImageBitmap(bitmap);
                            retriever.release();
                        }catch (Exception e){
                            e.printStackTrace();
                        }

                    }
                }
            },200);

            layout_root.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (currentVideoView != null && currentPlay != null){
                        if (currentVideoView.isPlaying()){
                            currentVideoView.pause();
                            currentPlay.setVisibility(View.VISIBLE);
                        }else{
                            finish();
                        }
                    }else{
                        finish();
                    }
                }
            });
            //播放完成回调
            videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mediaPlayer) {
                    videoView.start();
                }
            });
            return view;
        }
        private View setupImage(ViewGroup container,String url){

            View view = inflater.inflate(R.layout.item_activity_photos, container, false);
            final ProgressBar progressBar = (ProgressBar) view.findViewById(R.id.progressBar);
            final ImageView photoView = (ImageView) view.findViewById(R.id.photoView);
            photoView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                }
            });
            progressBar.setVisibility(View.VISIBLE);

            if (!TextUtils.isEmpty(url) && url.endsWith(".gif")) {

                Glide.with(PhotosActivity.this)
                        .asGif()
                        .diskCacheStrategy(DiskCacheStrategy.NONE)
                        .priority(Priority.HIGH)
                        .load(url)
                        .listener(new RequestListener<GifDrawable>() {
                            @Override
                            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<GifDrawable> target, boolean isFirstResource) {
                                return false;
                            }

                            @Override
                            public boolean onResourceReady(GifDrawable resource, Object model, Target<GifDrawable> target, DataSource dataSource, boolean isFirstResource) {
                                int resWidth = resource.getIntrinsicWidth();
                                int reHeight = resource.getIntrinsicHeight();
                                float scaleWH = (float) resWidth / (float) reHeight;
                                int photoViewHeight = (int) (CommonUtils.getScreenWidth(PhotosActivity.this) /scaleWH);
                                ViewGroup.LayoutParams layoutParams = photoView.getLayoutParams();
                                layoutParams.width =  CommonUtils.getScreenWidth(PhotosActivity.this);
                                layoutParams.height = photoViewHeight;
                                photoView.setLayoutParams(layoutParams);

                                progressBar.setVisibility(View.GONE);
                                photoView.setImageDrawable(resource);
                                return false;
                            }
                        }).into(photoView);

            } else {

                Glide.with(PhotosActivity.this).asDrawable().load(url).listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        photoView.setImageDrawable(resource);
                        progressBar.setVisibility(View.GONE);
                        return false;
                    }
                }).into(photoView);
            }
            return view;
        }

    }

    public int dp2px(float dpValue) {
        final float scale = getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
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
        if (videoHeight == 0 || videoWidth == 0 || currentVideoView == null){
            return;
        }
        Configuration mConfiguration = getResources().getConfiguration(); //获取设置的配置信息
        if (mConfiguration.orientation == Configuration.ORIENTATION_PORTRAIT){
            RelativeLayout.LayoutParams videoViewParam;
            float height = ((videoHeight*1f / videoWidth) * outMetrics.widthPixels);
            videoViewParam = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, (int) height);
            videoViewParam.addRule(RelativeLayout.CENTER_IN_PARENT);
            currentVideoView.setLayoutParams(videoViewParam);
        }else{
            RelativeLayout.LayoutParams videoViewParam;
            float width = ((videoWidth*1f / videoHeight) * outMetrics.widthPixels);
            videoViewParam = new RelativeLayout.LayoutParams((int) width,RelativeLayout.LayoutParams.MATCH_PARENT);
            videoViewParam.addRule(RelativeLayout.CENTER_IN_PARENT);
            currentVideoView.setLayoutParams(videoViewParam);
        }
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (currentVideoView != null) {
            currentVideoView.suspend();
        }
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent();
        intent.putExtra("needBackValue", false);
        setResult(RESULT_OK, intent);
        finish();
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_photos);
        viewPager = findViewById(R.id.viewPager);
        layout_tip = findViewById(R.id.layout_tip);
        TextView tv_photos_confirm = findViewById(R.id.tv_photos_confirm);
        View iv_photos_back = findViewById(R.id.v_photos_back);
        inflater = LayoutInflater.from(this);
        images = getIntent().getStringArrayListExtra(IMAGES);
        currentPosition = getIntent().getIntExtra(CURRENT_POSITION, 0);

        WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);
        iv_photos_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.putExtra("needBackValue", false);
                setResult(RESULT_OK, intent);
                finish();
            }
        });
        tv_photos_confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.putExtra("needBackValue", true);
                setResult(RESULT_OK, intent);
                finish();
            }
        });

        if (images != null && images.size() > 0) {

            if (images.size() < 10 && images.size() > 1) {

                for (int i = 0; i < images.size(); i++) {
                    View view = new View(this);
                    if (0 == i) {
                        view.setBackground(ContextCompat.getDrawable(this, R.drawable.circle_white));
                    } else {
                        view.setBackground(ContextCompat.getDrawable(this, R.drawable.circle_gray));
                    }
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                    params.width = params.height = dp2px(6);
                    params.leftMargin = params.rightMargin = dp2px(5);
                    view.setLayoutParams(params);
                    layout_tip.addView(view);
                }
            }
        }

        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                if (images.size() < 10) {
                    reset(position);
                }
                if (currentVideoView != null) {
                    currentVideoView.suspend();
                    currentVideoView = null;
                }
                if (currentPlay != null){
                    currentPlay.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });

        Adapter adapter = new Adapter();
        viewPager.setAdapter(adapter);
        viewPager.setCurrentItem(currentPosition.intValue());
    }

    private void reset(int pos) {
        for (int i = 0; i < layout_tip.getChildCount(); i++) {
            View view = layout_tip.getChildAt(i);
            view.setBackground(ContextCompat.getDrawable(this, R.drawable.circle_gray));
        }
        layout_tip.getChildAt(pos).setBackground(ContextCompat.getDrawable(this, R.drawable.circle_white));
    }
}
