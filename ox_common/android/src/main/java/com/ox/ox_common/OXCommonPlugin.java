package com.ox.ox_common;
import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;

import androidx.core.app.ActivityCompat;
import androidx.core.content.FileProvider;
import com.ox.ox_common.activitys.PermissionActivity;
import com.ox.ox_common.activitys.SelectPicsActivity;
import com.ox.ox_common.provides.CustomAnalyzeCallback;
import com.ox.ox_common.utils.LocalTools;
import com.uuzuche.lib_zxing.activity.CodeUtils;
import java.io.File;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

/**
 * Title: OXCommonPlugin
 * Description: TODO(Fill in by oneself)
 * Copyright: Copyright (c) 2022
 * Company:  0xchat Teachnology
 * CreateTime: 2023/12/21 16:46
 *
 * @author Michael
 * @since JDK1.8
 */

public class OXCommonPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Context mContext;
    private final String TAG = "OXCommonPlugin";

    private final int SELECT = 601;
    private final int READ_IMAGE = 603;
    private final int MEDIA_34 = 801;

    private Result mResult;

    private Activity mActivity;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ox_common");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        mResult = result;
        switch (call.method) {
            case "getDatabaseFilePath":
                String dbName = call.argument("dbName");
                String databasefile = getDatabaseFilePath(dbName);
                result.success(databasefile);
                break;
            case "scan_path":
                String path = call.argument("path");
                CodeUtils.AnalyzeCallback analyzeCallback = new CustomAnalyzeCallback(result, mActivity.getIntent());
                CodeUtils.analyzeBitmap(path, analyzeCallback);
                break;
            case "getPickerPaths":
                getPickPaths(call);
                break;
            case "backToDesktop":
                if (mResult != null) {
                    mResult.success(true);
                    mActivity.moveTaskToBack(false);
                }
                break;
            case "getPlatformVersion":
                result.success("Android ${android.os.Build.VERSION.RELEASE}");
                break;
            case "callSysShare":
                String filePath = call.argument("filePath");
                goSysShare(filePath);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mActivity = binding.getActivity();

        binding.addActivityResultListener(new ActivityResultListener() {
            @Override
            public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
                // 处理 onActivityResult 逻辑
                return false;
            }
        });
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    // ... 其他私有方法 ...

    private String getDatabaseFilePath(String dbName) {
        return mActivity.getDatabasePath(dbName).getPath();
    }

    private void requestMediaPermissions(Result result) {
        if (Build.VERSION.SDK_INT >= 34) {
            String[] permissions = new String[]{
                    Manifest.permission.READ_MEDIA_IMAGES,
                    Manifest.permission.READ_MEDIA_VIDEO,
                    Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED
            };

            ActivityCompat.requestPermissions(mActivity, permissions, MEDIA_34);
        } else {
            result.success("Unsupported Android version");
        }
    }

    private void getPickPaths(MethodCall call){
        String galleryMode = call.argument("galleryMode");
        boolean showGif = call.argument("showGif");
        Map<String, Number> uiColor = call.argument("uiColor");
        Number selectCount = call.argument("selectCount");
        boolean showCamera = call.argument("showCamera");
        boolean enableCrop = call.argument("enableCrop");
        Number width = call.argument("width");
        Number height = call.argument("height");
        Number compressSize = call.argument("compressSize");
        String cameraMimeType = call.argument("cameraMimeType");
        Number videoRecordMaxSecond = call.argument("videoRecordMaxSecond");
        Number videoRecordMinSecond = call.argument("videoRecordMinSecond");
        Number videoSelectMaxSecond = call.argument("videoSelectMaxSecond");
        Number videoSelectMinSecond = call.argument("videoSelectMinSecond");
        String language = call.argument("language");

        Intent intent = new Intent();
        intent.putExtra(SelectPicsActivity.GALLERY_MODE, galleryMode);
        intent.putExtra(SelectPicsActivity.UI_COLOR, (Serializable) uiColor);
        intent.putExtra(SelectPicsActivity.SELECT_COUNT, selectCount);
        intent.putExtra(SelectPicsActivity.SHOW_GIF, showGif);
        intent.putExtra(SelectPicsActivity.SHOW_CAMERA, showCamera);
        intent.putExtra(SelectPicsActivity.ENABLE_CROP, enableCrop);
        intent.putExtra(SelectPicsActivity.WIDTH, width);
        intent.putExtra(SelectPicsActivity.HEIGHT, height);
        intent.putExtra(SelectPicsActivity.COMPRESS_SIZE, compressSize);
        intent.putExtra(SelectPicsActivity.CAMERA_MIME_TYPE, cameraMimeType);
        intent.putExtra(SelectPicsActivity.VIDEO_RECORD_MAX_SECOND, videoRecordMaxSecond);
        intent.putExtra(SelectPicsActivity.VIDEO_RECORD_MIN_SECOND, videoRecordMinSecond);
        intent.putExtra(SelectPicsActivity.VIDEO_SELECT_MAX_SECOND, videoSelectMaxSecond);
        intent.putExtra(SelectPicsActivity.VIDEO_SELECT_MIN_SECOND, videoSelectMinSecond);
        intent.putExtra(SelectPicsActivity.LANGUAGE, language);

        if (cameraMimeType != null) {
            intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.CAMERA}
            );
            intent.setClass(mContext, PermissionActivity.class);
            mActivity.startActivityForResult(intent, READ_IMAGE);
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{
                                Manifest.permission.READ_MEDIA_IMAGES,
                                Manifest.permission.READ_MEDIA_VIDEO
                        }
                );
                intent.setClass(mContext, PermissionActivity.class);
                mActivity.startActivityForResult(intent, READ_IMAGE);
            } else {
                intent.setClass(mContext, SelectPicsActivity.class);
                mActivity.startActivityForResult(intent, SELECT);
            }
        }
    }

    private void goSysShare(String filePath) {
        Uri shareFileURI = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            shareFileURI = FileProvider.getUriForFile(mActivity,
                    mActivity.getPackageName() + ".fileprovider",
                    new File(filePath));
        } else {
            shareFileURI = Uri.fromFile(new File(filePath));
        }
        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        if (shareFileURI != null) {
            shareIntent.putExtra(Intent.EXTRA_STREAM, shareFileURI);
            shareIntent.setType("image/*");
            // Use sms_body to get text when the user selects SMS
            shareIntent.putExtra("sms_body", "");
        } else {
            shareIntent.setType("text/plain");
        }
        shareIntent.putExtra(Intent.EXTRA_TEXT, "");
        // Customize the title of the selection box
        mActivity.startActivity(Intent.createChooser(shareIntent, "Share"));
    }

}
