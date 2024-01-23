package com.ox.ox_common.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.transition.Transition;
import com.luck.picture.lib.engine.CropFileEngine;
import com.yalantis.ucrop.UCrop;
import com.yalantis.ucrop.UCropActivity;
import com.yalantis.ucrop.UCropImageEngine;
import com.yalantis.ucrop.model.AspectRatio;

import java.io.File;
import java.util.ArrayList;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class ImageCropEngine implements CropFileEngine {
    private Context context;
    private UCrop.Options options;
    private float aspectRatioX;
    private float aspectRatioY;
    public ImageCropEngine(Context context, UCrop.Options options, float aspectRatioX, float aspectRatioY) {
        this.context = context;
        this.options = options;
        this.aspectRatioX = aspectRatioX;
        this.aspectRatioY = aspectRatioY;
    }

    private String getSandboxPath() {
        AppPath appPath = new AppPath(context);
        return appPath.getAppImgDirPath() + File.separator;
    }
    @Override
    public void onStartCrop(Fragment fragment, Uri srcUri, Uri destinationUri, ArrayList<String> dataSource, int requestCode) {
        UCrop uCrop = UCrop.of(srcUri, destinationUri, dataSource);
        //options.setMultipleCropAspectRatio(buildAspectRatios(dataSource.size()));
        options.isDragCropImages(true);
        options.setShowCropFrame(true);
        options.setFreeStyleCropEnabled(aspectRatioX <= 0 || aspectRatioY <= 0);
        options.setHideBottomControls(true);
        options.setAllowedGestures(UCropActivity.ALL,UCropActivity.ALL,UCropActivity.ALL);
        AspectRatio[] aspectRatios = new AspectRatio[dataSource.size()];
        for (int i = 0; i < dataSource.size(); i++) {
            aspectRatios[i] = new AspectRatio("",aspectRatioX,aspectRatioY);
        }
        options.setMultipleCropAspectRatio(aspectRatios);
        uCrop.withOptions(options);
        uCrop.withAspectRatio(aspectRatioX,aspectRatioY);
        uCrop.setImageEngine(new UCropImageEngine() {
            @Override
            public void loadImage(Context context, String url, ImageView imageView) {
                if (!ImageLoaderUtils.assertValidRequest(context)) {
                    return;
                }
                Glide.with(context).load(url).override(180, 180).into(imageView);
            }

            @Override
            public void loadImage(Context context, Uri url, int maxWidth, int maxHeight, OnCallbackListener<Bitmap> call) {
                if (!ImageLoaderUtils.assertValidRequest(context)) {
                    return;
                }
                Glide.with(context).asBitmap().override(maxWidth, maxHeight).load(url).into(new CustomTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                        if (call != null) {
                            call.onCall(resource);
                        }
                    }

                    @Override
                    public void onLoadFailed(@Nullable Drawable errorDrawable) {
                        if (call != null) {
                            call.onCall(null);
                        }
                    }

                    @Override
                    public void onLoadCleared(@Nullable Drawable placeholder) {
                    }
                });
            }
        });
        uCrop.start(fragment.getActivity(), fragment, requestCode);
    }
}
