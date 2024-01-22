package com.ox.ox_common.activitys;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.provider.MediaStore;


import com.luck.picture.lib.basic.PictureSelector;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.config.SelectMimeType;
import com.luck.picture.lib.config.SelectModeConfig;
import com.luck.picture.lib.dialog.RemindDialog;
import com.luck.picture.lib.entity.LocalMedia;
import com.luck.picture.lib.interfaces.OnResultCallbackListener;
import com.luck.picture.lib.language.LanguageConfig;
import com.luck.picture.lib.style.PictureSelectorStyle;
import com.luck.picture.lib.style.SelectMainStyle;
import com.luck.picture.lib.style.TitleBarStyle;
import com.luck.picture.lib.utils.StyleUtils;
import com.ox.ox_common.R;
import com.ox.ox_common.utils.AppPath;
import com.ox.ox_common.utils.CommonUtils;
import com.ox.ox_common.utils.GlideEngine;
import com.ox.ox_common.utils.ImageCompressEngine;
import com.ox.ox_common.utils.ImageCropEngine;
import com.ox.ox_common.utils.MeSandboxFileEngine;
import com.ox.ox_common.utils.PictureStyleUtil;
import com.yalantis.ucrop.UCrop;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("all")
public class SelectPicsActivity extends BaseActivity {

    private static final int WRITE_SDCARD = 101;

    public static final String GALLERY_MODE = "GALLERY_MODE";
    public static final String UI_COLOR = "UI_COLOR";
    public static final String SHOW_GIF = "SHOW_GIF";
    public static final String SHOW_CAMERA = "SHOW_CAMERA";
    public static final String ENABLE_CROP = "ENABLE_CROP";
    public static final String WIDTH = "WIDTH";
    public static final String HEIGHT = "HEIGHT";
    public static final String COMPRESS_SIZE = "COMPRESS_SIZE";

    public static final String SELECT_COUNT = "SELECT_COUNT";//Selectable quantity

    public static final String COMPRESS_PATHS = "COMPRESS_PATHS";//compressed picture path
    public static final String CAMERA_MIME_TYPE = "CAMERA_MIME_TYPE";//Effective when directly invoking camera for photos or videos
    public static final String VIDEO_RECORD_MAX_SECOND = "VIDEO_RECORD_MAX_SECOND";//Maximum video recording time (seconds)
    public static final String VIDEO_RECORD_MIN_SECOND = "VIDEO_RECORD_MIN_SECOND";//Minimum video recording time (seconds)
    public static final String VIDEO_SELECT_MAX_SECOND = "VIDEO_SELECT_MAX_SECOND";//Maximum video duration when selecting a video (seconds)
    public static final String VIDEO_SELECT_MIN_SECOND = "VIDEO_SELECT_MIN_SECOND";//Minimum video duration when selecting a video (seconds)
    public static final String LANGUAGE = "LANGUAGE";


    @Override
    public void onCreate(@androidx.annotation.Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_pics);

        startSel();
    }

    private UCrop.Options buildOptions(PictureSelectorStyle selectorStyle) {
        UCrop.Options options = new UCrop.Options();
        if (selectorStyle != null && selectorStyle.getSelectMainStyle().getStatusBarColor() != 0) {
            SelectMainStyle mainStyle = selectorStyle.getSelectMainStyle();
            boolean isDarkStatusBarBlack = mainStyle.isDarkStatusBarBlack();
            int statusBarColor = mainStyle.getStatusBarColor();
            options.isDarkStatusBarBlack(isDarkStatusBarBlack);
            options.setSkipCropMimeType(new String[]{PictureMimeType.ofGIF(), PictureMimeType.ofWEBP()});
            if (StyleUtils.checkStyleValidity(statusBarColor)) {
                options.setStatusBarColor(statusBarColor);
                options.setToolbarColor(statusBarColor);
            }
            TitleBarStyle titleBarStyle = selectorStyle.getTitleBarStyle();
            if (StyleUtils.checkStyleValidity(titleBarStyle.getTitleTextColor())) {
                options.setToolbarWidgetColor(titleBarStyle.getTitleTextColor());
            }
        }
        return options;
    }

    private int getLang(String language){
        if ("chinese".equals(language)){
            return LanguageConfig.CHINESE;
        }else if ("traditional_chinese".equals(language)){
            return LanguageConfig.TRADITIONAL_CHINESE;
        }else if ("english".equals(language)){
            return LanguageConfig.ENGLISH;
        }else if ("japanese".equals(language)){
            return LanguageConfig.JAPAN;
        }else if ("france".equals(language)){
            return LanguageConfig.FRANCE;
        }else if ("german".equals(language)){
            return LanguageConfig.GERMANY;
        }else if ("russian".equals(language)){
            return LanguageConfig.RU;
        }else if ("vietnamese".equals(language)){
            return LanguageConfig.VIETNAM;
        }else if ("korean".equals(language)){
            return LanguageConfig.KOREA;
        }else if ("portuguese".equals(language)){
            return LanguageConfig.PORTUGAL;
        }else if ("spanish".equals(language)){
            return LanguageConfig.SPANISH;
        }else if ("arabic".equals(language)){
            return LanguageConfig.AR;
        }
        return LanguageConfig.SYSTEM_LANGUAGE;
    }
    private void startSel() {

        String mode = getIntent().getStringExtra(GALLERY_MODE);
        Map<String, Number> uiColor = (Map<String, Number>) getIntent().getSerializableExtra(UI_COLOR);

        Number selectCount = getIntent().getIntExtra(SELECT_COUNT, 9);
        boolean showGif = getIntent().getBooleanExtra(SHOW_GIF, true);
        boolean showCamera = getIntent().getBooleanExtra(SHOW_CAMERA, false);
        boolean enableCrop = getIntent().getBooleanExtra(ENABLE_CROP, false);
        Number width = getIntent().getIntExtra(WIDTH, 1);
        Number height = getIntent().getIntExtra(HEIGHT, 1);
        Number compressSize = getIntent().getIntExtra(COMPRESS_SIZE, 500);
        String mimeType = getIntent().getStringExtra(CAMERA_MIME_TYPE);

        Number videoRecordMaxSecond = getIntent().getIntExtra(VIDEO_RECORD_MAX_SECOND, 120);
        Number videoRecordMinSecond = getIntent().getIntExtra(VIDEO_RECORD_MIN_SECOND, 1);
        Number videoSelectMaxSecond = getIntent().getIntExtra(VIDEO_SELECT_MAX_SECOND, 120);
        Number videoSelectMinSecond = getIntent().getIntExtra(VIDEO_SELECT_MIN_SECOND, 1);

        String language = getIntent().getStringExtra(LANGUAGE);


        PictureStyleUtil pictureStyleUtil = new PictureStyleUtil(this);
        pictureStyleUtil.setStyle(uiColor);
        PictureSelectorStyle selectorStyle = pictureStyleUtil.getSelectorStyle();
        PictureSelector pictureSelector = PictureSelector.create(this);
        if (mimeType != null) {
            //When directly invoking the camera for photos or videos
            PictureSelector.create(this).openCamera("photo".equals(mimeType) ? SelectMimeType.ofImage() : SelectMimeType.ofVideo())
                    .setRecordVideoMaxSecond(videoRecordMaxSecond.intValue())
                    .setRecordVideoMinSecond(videoRecordMinSecond.intValue())
                    .setLanguage(getLang(language))
                    .setOutputCameraDir(new AppPath(this).getAppVideoDirPath())
                    .setCropEngine((enableCrop) ?
                            new ImageCropEngine(this, buildOptions(selectorStyle), width.intValue(), height.intValue()) : null)
                    .setCompressEngine(new ImageCompressEngine(compressSize.intValue()))
                    .setSandboxFileEngine(new MeSandboxFileEngine()).forResult(new OnResultCallbackListener<LocalMedia>() {
                @Override
                public void onResult(ArrayList<LocalMedia> result) {
                    if (result != null && result.size() > 0){
                        LocalMedia localMedia = result.get(0);
                        if ("video".equals(mimeType)){
                            long videoDuration = localMedia.getDuration()/1000;
                            if(videoDuration < videoRecordMinSecond.intValue() || videoDuration > videoRecordMaxSecond.intValue()){
                                String tips = "";
                                if (videoDuration < videoRecordMinSecond.intValue()){
                                    tips = getString(R.string.str_select_video_min_second,videoRecordMinSecond.intValue());
                                }else if (videoDuration > videoRecordMaxSecond.intValue()){
                                    tips = getString(R.string.str_select_video_max_second,videoRecordMaxSecond.intValue());
                                }
                                RemindDialog tipsDialog = RemindDialog.buildDialog(SelectPicsActivity.this,tips);
                                tipsDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                                    @Override
                                    public void onDismiss(DialogInterface dialog) {
                                        Intent intent = new Intent();
                                        intent.putExtra(COMPRESS_PATHS, new ArrayList<>());
                                        setResult(RESULT_OK, intent);
                                        finish();
                                    }
                                });
                                tipsDialog.show();
                            }else{
                                handlerResult(result);
                            }
                        }else{
                            handlerResult(result);
                        }
                    }else{
                        Intent intent = new Intent();
                        intent.putExtra(COMPRESS_PATHS, new ArrayList<>());
                        setResult(RESULT_OK, intent);
                        finish();
                    }
                }

                @Override
                public void onCancel() {
                    Intent intent = new Intent();
                    intent.putExtra(COMPRESS_PATHS, new ArrayList<>());
                    setResult(RESULT_OK, intent);
                    finish();
                }
            });
        } else {

            int selectMimeType = SelectMimeType.ofImage();
            if("image".equals(mode)){
                selectMimeType = SelectMimeType.ofImage();
            }else if ("video".equals(mode)){
                selectMimeType = SelectMimeType.ofVideo();
            }else{
                selectMimeType = SelectMimeType.ofAll();
            }

            PictureSelector.create(this).openGallery(selectMimeType)
                    .setImageEngine(GlideEngine.getInstance())
                    .setSelectorUIStyle(pictureStyleUtil.getSelectorStyle())
                    .setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
                    .setRecordVideoMaxSecond(videoRecordMaxSecond.intValue())
                    .setRecordVideoMinSecond(videoRecordMinSecond.intValue())
                    .setLanguage(getLang(language))
                    .setOutputCameraDir(new AppPath(this).getAppVideoDirPath())
                    .setCropEngine(enableCrop ?
                            new ImageCropEngine(this, buildOptions(selectorStyle), width.intValue(), height.intValue()) : null)
                    .setCompressEngine(new ImageCompressEngine(compressSize.intValue()))
                    .setSandboxFileEngine(new MeSandboxFileEngine())
                    .isDisplayCamera(showCamera)
                    .isGif(showGif)
                    .setSelectMaxDurationSecond(videoSelectMaxSecond.intValue())
                    .setSelectMinDurationSecond(videoSelectMinSecond.intValue())
                    .setFilterVideoMaxSecond(videoSelectMaxSecond.intValue())
                    .setFilterVideoMinSecond(videoSelectMinSecond.intValue())
                    .setMaxSelectNum(selectCount.intValue())
                    .setMaxVideoSelectNum(selectCount.intValue())
                    .isWithSelectVideoImage(true)
                    .setImageSpanCount(4)// Number of items per row (int)
                    .setSelectionMode(selectCount.intValue() == 1 ? SelectModeConfig.SINGLE : SelectModeConfig.MULTIPLE)// PictureConfig.MULTIPLE or PictureConfig.SINGLE
                    .isDirectReturnSingle(true)
                    .setSkipCropMimeType(new String[]{PictureMimeType.ofGIF(), PictureMimeType.ofWEBP()})
                    .isPreviewImage(true)
                    .isPreviewVideo(true)
                    .forResult(new OnResultCallbackListener<LocalMedia>() {
                        @Override
                        public void onResult(ArrayList<LocalMedia> result) {
                            handlerResult(result);
                        }

                        @Override
                        public void onCancel() {
                            Intent intent = new Intent();
                            intent.putExtra(COMPRESS_PATHS, new ArrayList<>());
                            setResult(RESULT_OK, intent);
                            finish();
                        }
                    });
        }

    }


    private void handlerResult(ArrayList<LocalMedia> selectList) {
        List<Map<String, String>> paths = new ArrayList<>();
        for (int i = 0; i < selectList.size(); i++) {
            LocalMedia localMedia = selectList.get(i);

            if (localMedia.getMimeType().contains("image")){
                String path = localMedia.getAvailablePath();
                if (localMedia.isCut()) {
                    path = localMedia.getCutPath();
                }
                Map<String, String> map = new HashMap<>();
                map.put("thumbPath", path);
                map.put("path", path);
                paths.add(map);

            }else{
                if (localMedia.getAvailablePath() == null) {
                    break;
                }
                Bitmap bitmap = ThumbnailUtils.createVideoThumbnail(localMedia.getAvailablePath(), MediaStore.Video.Thumbnails.FULL_SCREEN_KIND);
                String thumbPath = CommonUtils.saveBitmap(this, new AppPath(this).getAppImgDirPath(), bitmap);
                Map<String, String> map = new HashMap<>();
                map.put("thumbPath", thumbPath);
                map.put("path", localMedia.getAvailablePath());
                paths.add(map);
            }

        }
        Intent intent = new Intent();
        intent.putExtra(COMPRESS_PATHS, (Serializable) paths);
        setResult(RESULT_OK, intent);
        finish();
    }

}
