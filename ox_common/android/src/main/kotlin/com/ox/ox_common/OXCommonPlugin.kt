package com.ox.ox_common

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import androidx.core.content.FileProvider
import com.ox.ox_common.activitys.PermissionActivity
import com.ox.ox_common.activitys.SelectPicsActivity
import com.ox.ox_common.provides.CustomAnalyzeCallback
import com.ox.ox_common.utils.BitmapUtils
import com.ox.ox_common.utils.FileTool
import com.ox.ox_common.utils.LocalConst
import com.ox.ox_common.utils.LocalTools
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.io.File
import java.io.Serializable
import com.uuzuche.lib_zxing.activity.CodeUtils


/** OXCommonPlugin */
class OXCommonPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var mContext: Context
    private val TAG: String = "OXCommonPlugin";

    private val SELECT = 601
    private val READ_IMAGE = 603

    private var mResult: Result? = null
    private var mIsNeedCrop = false
    private var _tempImageFileLocation: String? = null
    private var _mCropImgPath: String? = null
    private var _mFileName: String? = null

    private lateinit var mActivity: Activity

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ox_common")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.hasArgument("isNeedTailor")) {
            mIsNeedCrop = call.argument<Boolean>("isNeedTailor")!!
        }
        mResult = result
        _tempImageFileLocation = null
        when (call.method) {
            "scan_path" -> {
                val path = call.argument<String>("path")
                val analyzeCallback: CodeUtils.AnalyzeCallback =
                    CustomAnalyzeCallback(result, mActivity.getIntent())
                CodeUtils.analyzeBitmap(path, analyzeCallback)
            }
            "getPickerPaths" -> {
                val galleryMode: String? = call.argument("galleryMode")
                val showGif: Boolean? = call.argument("showGif")
                val uiColor: Map<String, Number>? = call.argument("uiColor")
                val selectCount: Number? = call.argument("selectCount")
                val showCamera: Boolean? = call.argument("showCamera")
                val enableCrop: Boolean? = call.argument("enableCrop")
                val width: Number? = call.argument("width")
                val height: Number? = call.argument("height")
                val compressSize: Number? = call.argument("compressSize")
                val cameraMimeType: String? = call.argument("cameraMimeType")
                val videoRecordMaxSecond: Number? = call.argument("videoRecordMaxSecond")
                val videoRecordMinSecond: Number? = call.argument("videoRecordMinSecond")
                val videoSelectMaxSecond: Number? = call.argument("videoSelectMaxSecond")
                val videoSelectMinSecond: Number? = call.argument("videoSelectMinSecond")
                val language: String? = call.argument("language")

                val intent = Intent()

                intent.putExtra(SelectPicsActivity.GALLERY_MODE, galleryMode)
                intent.putExtra(SelectPicsActivity.UI_COLOR, uiColor as Serializable)
                intent.putExtra(SelectPicsActivity.SELECT_COUNT, selectCount)
                intent.putExtra(SelectPicsActivity.SHOW_GIF, showGif)
                intent.putExtra(SelectPicsActivity.SHOW_CAMERA, showCamera)
                intent.putExtra(SelectPicsActivity.ENABLE_CROP, enableCrop)
                intent.putExtra(SelectPicsActivity.WIDTH, width)
                intent.putExtra(SelectPicsActivity.HEIGHT, height)
                intent.putExtra(SelectPicsActivity.COMPRESS_SIZE, compressSize)
                //直接调用拍照或拍视频时有效
                //直接调用拍照或拍视频时有效
                intent.putExtra(SelectPicsActivity.CAMERA_MIME_TYPE, cameraMimeType)
                intent.putExtra(SelectPicsActivity.VIDEO_RECORD_MAX_SECOND, videoRecordMaxSecond)
                intent.putExtra(SelectPicsActivity.VIDEO_RECORD_MIN_SECOND, videoRecordMinSecond)
                intent.putExtra(SelectPicsActivity.VIDEO_SELECT_MAX_SECOND, videoSelectMaxSecond)
                intent.putExtra(SelectPicsActivity.VIDEO_SELECT_MIN_SECOND, videoSelectMinSecond)
                intent.putExtra(SelectPicsActivity.LANGUAGE, language)
                if (cameraMimeType != null) {
                    intent.putExtra(
                        PermissionActivity.PERMISSIONS,
                        arrayOf<String>(Manifest.permission.CAMERA)
                    )
                    intent.setClass(mContext, PermissionActivity::class.java)
                    mActivity.startActivityForResult(
                        intent,
                        READ_IMAGE
                    )
                } else {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        intent.putExtra(
                            PermissionActivity.PERMISSIONS, arrayOf<String>(
                                Manifest.permission.READ_MEDIA_IMAGES,
                                Manifest.permission.READ_MEDIA_VIDEO
                            )
                        )
                        intent.setClass(mContext, PermissionActivity::class.java)
                        mActivity.startActivityForResult(
                            intent,
                            READ_IMAGE
                        )
                    } else {
                        intent.setClass(mContext, SelectPicsActivity::class.java)
                        mActivity.startActivityForResult(
                            intent,
                            SELECT
                        )
                    }
                }
            }
            "backToDesktop" -> {
                if (mResult != null) {
                    mResult!!.success(true)
                    mActivity.moveTaskToBack(false)
                }
            }
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "getDeviceId" -> result.success(LocalTools.getAndroidId(mContext))
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity


        binding.addActivityResultListener(ActivityResultListener { requestCode, resultCode, data ->
            if (resultCode != Activity.RESULT_OK) {
                return@ActivityResultListener false
            } else {
                if (requestCode == SELECT) {
                    val paths =
                        data?.getSerializableExtra(SelectPicsActivity.COMPRESS_PATHS) as List<Map<String, String>>
                    mResult?.success(paths)
                    return@ActivityResultListener true
                } else if (requestCode == READ_IMAGE) {
                    if (resultCode == Activity.RESULT_OK) {
                        var intent1 = Intent(mActivity, SelectPicsActivity::class.java)
                        intent1.putExtras(data!!)
                        mActivity.startActivityForResult(
                            intent1,
                            SELECT
                        )
                    }
                }
                false
            }
        })
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    private fun processResult(content: String) {
        if (mResult == null) return
        mResult!!.success(content)
        mResult = null
    }


    fun takePhoto(activity: Activity, requestCode: Int, uriToBeSave: Uri?) {
        if (uriToBeSave == null) {
            Log.e(TAG, "uriToBeSave is null!")
            return
        }
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val photoURI = FileProvider.getUriForFile(mActivity, mActivity.getPackageName().toString() + ".fileprovider",
                    File(_tempImageFileLocation))
            intent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI)
        } else {
            intent.putExtra(MediaStore.EXTRA_OUTPUT, uriToBeSave)
        }
        intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
        activity.startActivityForResult(intent, requestCode)
    }

    fun takeVideo(activity: Activity, requestCode: Int, uriToBeSave: Uri?) {
        val takeVideoIntent = Intent(MediaStore.ACTION_VIDEO_CAPTURE)
        if (takeVideoIntent.resolveActivity(mActivity!!.packageManager) != null) {
            takeVideoIntent.putExtra("camerasensortype", 2) // Invoke the front camera
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                val videoURI = FileProvider.getUriForFile(mActivity, mActivity.getPackageName().toString() + ".fileprovider",
                        File(_tempImageFileLocation))
                takeVideoIntent.putExtra(MediaStore.EXTRA_OUTPUT, videoURI)
            } else {
                takeVideoIntent.putExtra(MediaStore.EXTRA_OUTPUT, getTempImageFileUri(".mp4"))
            }
            mActivity!!.startActivityForResult(takeVideoIntent, requestCode)
        }
    }

    fun choosePhoto(activity: Activity, requestCode: Int) {
        val intent = Intent()
        if (Build.VERSION.SDK_INT >= 30) {
            intent.action = Intent.ACTION_OPEN_DOCUMENT
            intent.addCategory(Intent.CATEGORY_OPENABLE)
        } else {
            intent.action = Intent.ACTION_GET_CONTENT
        }
        intent.type = "image/*"
        activity.startActivityForResult(intent, requestCode)
    }

    private fun getTempImageFileUri(fileSuffix: String): Uri? {
        val tempImageFileLocation = getTempImageFileLocation(fileSuffix)
        return if (tempImageFileLocation != null) {
            Uri.parse("file://$tempImageFileLocation")
        } else null
    }


    private fun getTempImageFileLocation(fileSuffix: String): String? {
        try {
            if (_tempImageFileLocation == null) {
                val avatarTempDirStr = getPicSavedDir()
                val avatarTempDir = File(avatarTempDirStr)
                if (avatarTempDir != null) {
                    // Create the directory if it doesn't exist.
                    if (!avatarTempDir.exists()) avatarTempDir.mkdirs()

                    // Temporary file name
                    _mFileName = System.currentTimeMillis().toString() + fileSuffix
                    _tempImageFileLocation = avatarTempDir.absolutePath + "/" + _mFileName
                    if (Build.VERSION.SDK_INT >= 30) {
                        val tempFile = File(_tempImageFileLocation)
                        if (!tempFile.exists()) {
                            if (tempFile.createNewFile()) {
                                _tempImageFileLocation = tempFile.absolutePath
                            }
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "【Pic】Encountered an error while trying to read the temporary storage path for local user images," + e.message, e)
        }
        Log.d(TAG, "【Pic】Currently retrieving the temporary storage path for local user images: $_tempImageFileLocation")
        return _tempImageFileLocation
    }

    private fun getPicSavedDir(): String? {
        var dir: String? = null
        dir = if (Environment.MEDIA_MOUNTED == Environment.getExternalStorageState() || !Environment.isExternalStorageRemovable()) {
            if (mIsNeedCrop && Build.VERSION.SDK_INT >= 30) {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).absolutePath
            } else {
                mActivity!!.getExternalFilesDir(LocalConst.DIR_YLNEW_APP_FILES_PIC_DIR)!!.absolutePath
            }
        } else {
            //External storage is not available
            mActivity!!.filesDir.absolutePath + LocalConst.DIR_YLNEW_APP_FILES_PIC_DIR
        }
        //        LogUtils.e("dir = " + dir);
        return dir
    }

    /**
     * Initiate photo cropping
     */
    private fun startPhotoCrop(srcUri: Uri, cropUri: Uri, outputX: Int, outputY: Int, requestCode: Int) {
        val intent = Intent("com.android.camera.action.CROP")
        intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        //Set source URI
        intent.setDataAndType(srcUri, "image/*")
        intent.putExtra("crop", "true")
        intent.putExtra("aspectX", 1)
        intent.putExtra("aspectY", 1)
        //        intent.putExtra("outputX", outputX);
//        intent.putExtra("outputY", outputY);
        intent.putExtra("scale", true)
        //        //Set image format
//        intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
        intent.putExtra("return-data", false) //No need to return data to avoid exceptions due to large images
        intent.putExtra("noFaceDetection", true) // no face detection
        //Set destination URI
        intent.putExtra(MediaStore.EXTRA_OUTPUT, cropUri)
        mActivity!!.startActivityForResult(intent, requestCode)
    }

    private fun getSDK30PictureUri(): Uri? {
        val pictureDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        if (!pictureDirectory.exists()) {
            pictureDirectory.mkdirs()
        }
        val imgFile = File(pictureDirectory.absolutePath + File.separator + _mFileName)
        try {
            if (!imgFile.exists()) {
                imgFile.createNewFile()
            }
        } catch (e: Exception) {
            Log.e("ox_debug", e.message, e)
        }
        _mCropImgPath = imgFile.absolutePath
        // Insert the file using the MediaStore API to obtain the URI where the system crop should be saved (since the app doesn't have permission to access public storage and needs to use the MediaStore API for operations)
        val values = ContentValues()
        values.put(MediaStore.Images.Media.DATA, _mCropImgPath)
        values.put(MediaStore.Images.Media.DISPLAY_NAME, _mFileName)
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/*")
        return mActivity!!.contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
    }

    private fun getCompressionImg(filePath: String, quality: Int) {
        var bitmap: Bitmap? = null
        try {
            val opts = BitmapFactory.Options()
            opts.inJustDecodeBounds = false
            bitmap = BitmapUtils.loadLocalBitmap(filePath, opts)
        } catch (e: Exception) {
            Log.e("ox_debug", e.message, e)
        }
        if (bitmap == null) mResult!!.success(null)
        val path: String = FileTool.getFileSavedDir(mActivity, LocalConst.DIR_YLNEW_APP_FILES_PIC_DIR).toString() + "/" + System.currentTimeMillis() + ".png"
        val isSaveSucc: Boolean = FileTool.saveBitmap(bitmap, File(path), Bitmap.CompressFormat.JPEG, quality)
        if (isSaveSucc) {
            mResult!!.success(path)
        } else {
            mResult!!.success(null)
        }
    }

    private fun goSysShare(filePath: String) {
        var shareFileURI: Uri? = null
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            shareFileURI = FileProvider.getUriForFile(mActivity, mActivity.getPackageName().toString() + ".fileprovider",
                    File(filePath))
        } else {
            shareFileURI = Uri.fromFile(File(filePath))
        }
        var shareIntent: Intent = Intent(Intent.ACTION_SEND);
        if (shareFileURI != null) {
            shareIntent.putExtra(Intent.EXTRA_STREAM, shareFileURI)
            shareIntent.type = "image/*"
            //Use sms_body to get text when the user selects SMS
            shareIntent.putExtra("sms_body", "")
        } else {
            shareIntent.type = "text/plain"
        }
        shareIntent.putExtra(Intent.EXTRA_TEXT, "")
        //Customize the title of the selection box
        mActivity.startActivity(Intent.createChooser(shareIntent, "Share"))
    }

}
