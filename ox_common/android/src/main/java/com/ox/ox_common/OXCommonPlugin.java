package com.ox.ox_common;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.util.Log;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import com.ox.ox_common.activitys.PermissionActivity;
import com.ox.ox_common.activitys.SelectPicsActivity;
import com.ox.ox_common.provides.CustomAnalyzeCallback;
import com.ox.ox_common.utils.ClipboardHelper;
import com.uuzuche.lib_zxing.activity.CodeUtils;

import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterFragmentActivity;
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

    private Result mResult;

    private FlutterFragmentActivity mActivity;

    private ActivityResultLauncher<String> mGetContent;
    private ActivityResultLauncher<String[]> requestPermissionLauncher;

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
                if (mResult != null) {
                    mResult.success(databasefile);
                    mResult = null;
                }
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
                    mResult = null;
                    mActivity.moveTaskToBack(false);
                }
                break;
            case "getPlatformVersion":
                if (mResult != null) {
                    mResult.success("Android ${android.os.Build.VERSION.RELEASE}");
                    mResult = null;
                }
                break;
            case "callSysShare":
                String filePath = call.argument("filePath");
                goSysShare(filePath);
                break;
            case "select34MediaFilePaths":
                int type = call.argument("type");
                select34MediaFilePaths(type);
                break;
            case "request34MediaPermission":
                int mediaType = call.argument("type");
                request34MediaPermission(mediaType);
                break;
            case "hasImages":
                if (mResult != null) {
                    boolean hasImages = ClipboardHelper.hasImages(mContext);
                    mResult.success(hasImages);
                    mResult = null;
                }
                break;
            case "getImages":
                if (mResult != null) {
                    List<String> imagePaths = ClipboardHelper.getImages(mContext);
                    mResult.success(imagePaths);
                    mResult = null;
                }
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
        Activity activity = binding.getActivity();
        mActivity = (FlutterFragmentActivity) activity;
        initializeActivityResultLauncher();
        binding.addActivityResultListener(new ActivityResultListener() {
            @Override
            public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
                if (resultCode != Activity.RESULT_OK) {
                    return false;
                }
                if (requestCode == SELECT) {
                    List<Map<String, String>> paths = (List<Map<String, String>>) data.getSerializableExtra(SelectPicsActivity.COMPRESS_PATHS);
                    if (mResult != null) {
                        mResult.success(paths);
                        mResult = null;
                    }
                } else if (requestCode == READ_IMAGE) {
                    Intent intent1 = new Intent(mActivity, SelectPicsActivity.class);
                    intent1.putExtras(data);
                    mActivity.startActivityForResult(intent1, SELECT);
                }
                return false;
            }
        });
    }

    private void initializeActivityResultLauncher() {
        mGetContent = mActivity.registerForActivityResult(new ActivityResultContracts.GetMultipleContents(),
                uris -> {
//                    Log.d("Michael", "mGetContent----uris ="+uris.toString());
                    List<String> filePaths = urisToFileList(uris);
//                    Log.d("Michael", "mGetContent----filePaths ="+filePaths);
                    if (mResult != null) {
                        mResult.success(filePaths);
                        mResult = null;
                    }
                });
        requestPermissionLauncher = mActivity.registerForActivityResult(
                new ActivityResultContracts.RequestMultiplePermissions(), permissions -> {
                    Boolean readMediaImagesGranted = permissions.getOrDefault(Manifest.permission.READ_MEDIA_IMAGES, false);
                    Boolean readMediaVideoGranted = permissions.getOrDefault(Manifest.permission.READ_MEDIA_VIDEO, false);
                    Boolean readMediaVisualUserSelectedGranted = permissions.getOrDefault(Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED, false);
                    Map<String, Boolean> mediaGranteds = new HashMap<>();
                    mediaGranteds.put("READ_MEDIA_IMAGES", readMediaImagesGranted);
                    mediaGranteds.put("READ_MEDIA_VIDEO", readMediaVideoGranted);
                    mediaGranteds.put("READ_MEDIA_VISUAL_USER_SELECTED", readMediaVisualUserSelectedGranted);
//                    Log.d("oxcommon", "requestPermissionLauncher---------readMediaImagesGranted ="+readMediaImagesGranted+"；readMediaVisualUserSelectedGranted ="+readMediaVisualUserSelectedGranted + "; readMediaVideoGranted ="+readMediaVideoGranted);
                    if (mResult != null) {
                        mResult.success(mediaGranteds);
                        mResult = null;
                    }
                });
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    private String getDatabaseFilePath(String dbName) {
        return mActivity.getDatabasePath(dbName).getPath();
    }

    private void select34MediaFilePaths(int type) {
        String input = "image/*";
        if (type == 1) {
            input = "image/*";
        } else if (type == 2) {
            input = "video/*";
        }
        mGetContent.launch(input);
    }
    private void request34MediaPermission(int type) {
        ///type: 1 - image, 2 - video
        if (Build.VERSION.SDK_INT >= 34) {
            String[] permissions = null;
            if (type == 1) {
                permissions = new String[]{
                        Manifest.permission.READ_MEDIA_IMAGES,
                        Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED
                };
            } else {
                permissions = new String[]{
                        Manifest.permission.READ_MEDIA_VIDEO,
                        Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED
                };
            }
            requestPermissionLauncher.launch(permissions);
        } else {
            if (mResult != null) {
                mResult.success(false);//Unsupported Android version
                mResult = null;
            }
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
            intent.setClass(mContext, SelectPicsActivity.class);
            mActivity.startActivityForResult(intent, SELECT);
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

    private List<String> urisToFileList(List<Uri> uris) {
        List<String> filePaths = new ArrayList<>();
        for (Uri uri : uris) {
            String path = getPathFromUri(mActivity, uri);
            if (path != null) {
                filePaths.add(path);
            }
        }
        return filePaths;
    }

    private String getPathFromUri(Context context, Uri uri) {
        String result = null;
        if ("content".equalsIgnoreCase(uri.getScheme())) {
            String[] projection = { MediaStore.Images.Media.DATA };
            Cursor cursor = null;
            try {
                cursor = context.getContentResolver().query(uri, projection, null, null, null);
                if (cursor != null && cursor.moveToFirst()) {
                    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                    result = cursor.getString(column_index);
                }
            } finally {
                if (cursor != null) {
                    cursor.close();
                }
            }
        }
        return result;
    }
}
