package com.ox.ox_common.utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;


public class BitmapUtils {
    static String TAG = "BitmapUtils";
    public static String ScreenshotPrefixName = "OXApp_";

    /**
     * Set the prefix name for screenshot images (default activity, )
     *
     * @param screenshotPrefixName
     */
    public static void setScreenshotPrefixName(String screenshotPrefixName) {
        ScreenshotPrefixName = screenshotPrefixName + "_";
    }

    /**
     * Image zooming
     *
     * @param view
     */
    static boolean num;
    static Bitmap baseBitmap, newBitmap;

    public static void viewZoom(Activity activity, final ImageView ivPic, Bitmap bitmap, @DrawableRes final int resImgId) {
        if (bitmap == null)
            baseBitmap = getResBitmap(activity, resImgId);
        else
            baseBitmap = bitmap;
        DisplayMetrics dm = new DisplayMetrics();//Create a matrix
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
        final int width = baseBitmap.getWidth();
        final int height = baseBitmap.getHeight();
        int w = dm.widthPixels; //Get the screen width
        int h = dm.heightPixels; //Get the screen width
        final float scaleWidth = ((float) w) / width;
        final float scaleHeight = ((float) h) / height;

        ivPic.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                switch (motionEvent.getAction()) {

                    case MotionEvent.ACTION_DOWN:  //This event is triggered as soon as the screen detects the first touch point being pressed
                        Matrix matrix = new Matrix();
                        if (num == false) {
                            matrix.postScale(scaleWidth, scaleHeight);
                            num = true;
                        } else {
                            matrix.postScale(1.0f, 1.0f);
                            num = false;
                        }
                        newBitmap = Bitmap.createBitmap(baseBitmap, 0, 0, baseBitmap.getWidth(), baseBitmap.getHeight(), matrix, true);
                        ivPic.setImageBitmap(newBitmap);
                        break;
                }

                return false;
            }
        });
    }

    // Capture the screen of the specified Activity and save it to a PNG file
    @RequiresApi(api = Build.VERSION_CODES.CUPCAKE)
    public static Bitmap takeScreenShot(Activity activity) {

        //The "View" is the one you need to take a screenshot of
        View view = activity.getWindow().getDecorView();// Retrieve the top-level View of the entire window for the Activity
        view.setDrawingCacheEnabled(true);// Set the control to allow drawing cache
        view.buildDrawingCache();
        Bitmap b1 = view.getDrawingCache();// Retrieve the drawing cache (snapshot) of the control

        //Get the status bar height
        Rect frame = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        int statusBarHeight = frame.top;
        System.out.println(statusBarHeight);

        //Get the screen width and height
        int width = activity.getWindowManager().getDefaultDisplay().getWidth();
        int height = activity.getWindowManager().getDefaultDisplay().getHeight();

        //Remove the title bar
        //Bitmap b = Bitmap.createBitmap(b1, 0, 25, 320, 455);
        Bitmap baseBitmap = Bitmap.createBitmap(b1, 0, statusBarHeight, width, height - statusBarHeight);
        view.destroyDrawingCache();

        return baseBitmap;
    }

    /**
     * Save with watermark
     *
     * @param srcBitmap bitmap of the current screenshot
     * @return
     */
    public static Bitmap addMarkPic(Bitmap srcBitmap, Bitmap markBitmap) {

        if (markBitmap.getWidth() < srcBitmap.getWidth())
            srcBitmap = scaleWithWH(srcBitmap, markBitmap.getWidth(), srcBitmap.getHeight());
        Bitmap photoMark = Bitmap.createBitmap(srcBitmap.getWidth(), srcBitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(photoMark);
        canvas.drawBitmap(srcBitmap, 0, 0, null);
        Bitmap bitmapMark = markBitmap.copy(Bitmap.Config.ARGB_8888, true);
//        bitmapMark = scaleWithWH(bitmapMark, srcBitmap.getWidth(), bitmapMark.getHeight());
        canvas.drawBitmap(bitmapMark, srcBitmap.getWidth() - bitmapMark.getWidth(), srcBitmap.getHeight() - bitmapMark.getHeight(), null);
        canvas.save();
        canvas.restore();
        Bitmap new_bitmap = scaleWithWH(photoMark, photoMark.getWidth(), photoMark.getHeight());
        return new_bitmap;
    }

    public static Bitmap addMarkPic2(Bitmap srcBitmap, Bitmap markBitmap) {

        Bitmap photoMark = Bitmap.createBitmap(srcBitmap.getWidth(), srcBitmap.getHeight() + markBitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(photoMark);
        canvas.drawBitmap(srcBitmap, 0, 0, null);
        Bitmap bitmapMark = markBitmap.copy(Bitmap.Config.ARGB_8888, true);
        canvas.drawBitmap(bitmapMark, 0, srcBitmap.getHeight(), null);
        canvas.save();
        canvas.restore();
        Bitmap new_bitmap = scaleWithWH(photoMark, photoMark.getWidth(), photoMark.getHeight());
        return new_bitmap;
    }

    public static Bitmap addNewsPic(Bitmap srcBitmap, Bitmap markBitmap, int topHeight) {

        Bitmap photoMark = Bitmap.createBitmap(srcBitmap.getWidth(), srcBitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(photoMark);
        canvas.drawBitmap(srcBitmap, 0, 0, null);
        Bitmap bitmapMark = markBitmap.copy(Bitmap.Config.ARGB_8888, true);
        canvas.drawBitmap(bitmapMark, 0, topHeight, null);
        canvas.save();
        canvas.restore();
        Bitmap new_bitmap = scaleWithWH(photoMark, photoMark.getWidth(), photoMark.getHeight());
        return new_bitmap;
    }

    public static Bitmap addYLNewsPic(Bitmap topBitmap, Bitmap middleBitmap, Bitmap bottomBitmap) {

        Bitmap photoMark = Bitmap.createBitmap(topBitmap.getWidth(), topBitmap.getHeight() + middleBitmap.getHeight() + bottomBitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(photoMark);
        canvas.drawBitmap(topBitmap, 0, 0, null);
        canvas.drawBitmap(middleBitmap, 0, topBitmap.getHeight(), null);
        canvas.drawBitmap(bottomBitmap, 0, topBitmap.getHeight() + middleBitmap.getHeight(), null);
        canvas.save();
        canvas.restore();
        Bitmap new_bitmap = scaleWithWH(photoMark, photoMark.getWidth(), photoMark.getHeight());
        return new_bitmap;
    }

    /**
     * Convert a layout to a bitmap object
     */
    public static Bitmap getViewBitmap(View view) {

        int me = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);

        view.measure(me, me);

        view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());

        view.buildDrawingCache();

        return view.getDrawingCache();
    }

    static Bitmap bitmap;

    public static Bitmap getUrl2BitMap(final String url) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                URL imageurl = null;

                try {
                    imageurl = new URL(url);
                } catch (MalformedURLException e) {
                    e.printStackTrace();
                }
                try {
                    HttpURLConnection conn = (HttpURLConnection) imageurl.openConnection();
                    conn.setDoInput(true);
                    conn.connect();
                    InputStream is = conn.getInputStream();
                    bitmap = BitmapFactory.decodeStream(is);
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        return bitmap;
    }

    /**
     * Convert the image to a bitmap object
     *
     * @param context
     * @param vectorDrawableId
     * @return
     */
    public static Bitmap getResBitmap(Context context, @DrawableRes int vectorDrawableId) {
        Bitmap bitmap = null;
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            Drawable vectorDrawable = context.getDrawable(vectorDrawableId);
            bitmap = Bitmap.createBitmap(vectorDrawable.getIntrinsicWidth(),
                    vectorDrawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            vectorDrawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
            vectorDrawable.draw(canvas);
        } else {
            bitmap = BitmapFactory.decodeResource(context.getResources(), vectorDrawableId);
        }
        return bitmap;
    }

    /**
     * Get a Bitmap object of a picture through the pic path.
     *
     * @param pathString : Path of the picture
     * @return Bitmap object of the picture
     */
    @RequiresApi(api = Build.VERSION_CODES.HONEYCOMB)
    public static Bitmap getDiskBitmap(String pathString) {
        Bitmap getBitmap = null;
        // Reuse Bitmap to reduce memory consumption
        try {
            File file = new File(pathString);
            if (file.exists()) {
                BitmapFactory.Options options = new BitmapFactory.Options();
                if (getBitmap == null) {
                    options.inMutable = true;
                    getBitmap = BitmapFactory.decodeFile(pathString, options);
                } else {
                    // Use inBitmap attribute, this attribute must be set;
                    options.inBitmap = getBitmap;
                    options.inMutable = true;
                    getBitmap = BitmapFactory.decodeFile(pathString, options);
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
//                System.out.println(getBitmap + "========bitmap=====1=======" + getBitmap.getAllocationByteCount());
                } else {
//                System.out.println(getBitmap + "========bitmap=====2=======" + getBitmap.getByteCount());
                }
            }
        } catch (Exception e) {
        }
        return getBitmap;
    }

    public static Bitmap compressScale(Bitmap bitmap, float scale) {
        Matrix matrix = new Matrix();
        matrix.setScale(scale, scale);
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, false);

    }

    /**
     * Scale an image.
     *
     * @param src : Source bitmap
     * @param w   : New width
     * @param h   : New height
     * @return Scaled Bitmap object
     */
    public static Bitmap scaleWithWH(Bitmap src, double w, double h) {
        if (w == 0 || h == 0 || src == null) {
            return src;
        } else {
            // Record the width and height of src
            int width = src.getWidth();
            int height = src.getHeight();
            // Create a matrix container
            Matrix matrix = new Matrix();
            // Calculate the scaling ratio
            float scaleWidth = (float) (w / width);
            float scaleHeight = (float) (h / height);
            // Start scaling
            matrix.postScale(scaleWidth, scaleHeight);
            // Create the scaled image
            return Bitmap.createBitmap(src, 0, 0, width, height, matrix, true);
        }
    }

    /**
     * Image scaling method.
     *
     * @param bitmap  : Source image resource
     * @param maxSize : Maximum allowed space for the image, in KB
     * @return Scaled Bitmap object
     */
    public static Bitmap getZoomImage(Bitmap bitmap, double maxSize) {
        if (null == bitmap) {
            return null;
        }
        if (bitmap.isRecycled()) {
            return null;
        }

        // Convert size from Byte to KB
        double currentSize = bitmapToByteArray(bitmap, false).length / 1024;
        // Check if bitmap size exceeds the maximum allowed space, if yes, compress it
        while (currentSize > maxSize) {
            // Calculate how many times the bitmap size exceeds maxSize
            double multiple = currentSize / maxSize;
            // Start compression: compress width and height proportionally
            // 1. Maintain new width and height with the same aspect ratio as the original bitmap
            // 2. Compress to achieve the best display effect for the new bitmap with maximum size
            bitmap = getZoomImage(bitmap, bitmap.getWidth() / Math.sqrt(multiple), bitmap.getHeight() / Math.sqrt(multiple));
            currentSize = bitmapToByteArray(bitmap, false).length / 1024;
        }
        return bitmap;
    }

    /**
     * Image scaling method.
     *
     * @param orgBitmap : Source image resource
     * @param newWidth  : Scaled width
     * @param newHeight : Scaled height
     * @return Scaled Bitmap object
     */
    public static Bitmap getZoomImage(Bitmap orgBitmap, double newWidth, double newHeight) {
        if (null == orgBitmap) {
            return null;
        }
        if (orgBitmap.isRecycled()) {
            return null;
        }
        if (newWidth <= 0 || newHeight <= 0) {
            return null;
        }

        // Get the width and height of the image
        float width = orgBitmap.getWidth();
        float height = orgBitmap.getHeight();
        // Create a matrix object to manipulate the image
        Matrix matrix = new Matrix();
        // Calculate width and height scaling ratios
        float scaleWidth = ((float) newWidth) / width;
        float scaleHeight = ((float) newHeight) / height;
        // Apply the scaling transformation to the image
        matrix.postScale(scaleWidth, scaleHeight);

        Bitmap bitmap = Bitmap.createBitmap(orgBitmap, 0, 0, (int) width, (int) height, matrix, true);
        return bitmap;
    }

    /**
     * Quality compression.
     *
     * @param bitmap
     * @param quality Range from 0 to 100
     * @return Compressed Bitmap object
     */
    public static Bitmap qualityCompress(Bitmap bitmap, int quality) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        if (bitmap == null)
            return null;
        baos.reset();
        bitmap.compress(Bitmap.CompressFormat.JPEG, quality, baos);
        if (bitmap != null && !bitmap.isRecycled()) {
            bitmap.recycle();
            bitmap = null;
            System.gc();
        }

//        LogUtils.e("gj", "====>>"+baos.toByteArray().length);
        // Store the compressed data from baos into ByteArrayInputStream
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());
        // Generate a Bitmap from the ByteArrayInputStream data
        Bitmap bit = BitmapFactory.decodeStream(isBm, null, null);
        if (baos != null) {
            try {
                baos.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        if (isBm != null) {
            try {
                isBm.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }

        return bit;
    }

    /**
     * bitmap is converted to byte array
     *
     * @param bitmap
     * @param needRecycle
     * @return
     */
    public static byte[] bitmapToByteArray(Bitmap bitmap, boolean needRecycle) {
        if (null == bitmap) {
            return null;
        }
        if (bitmap.isRecycled()) {
            return null;
        }

        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);
        if (needRecycle) {
            bitmap.recycle();
        }

        byte[] result = output.toByteArray();
        try {
            output.close();
        } catch (Exception e) {
            Log.e("ox_debug", e.getMessage());
        }
        return result;
    }

    /**
     * Convert dip (density-independent pixels) to pixels
     *
     * @param context
     * @param dp
     * @return Equivalent value in pixels
     */
    public static int dp2px(Context context, float dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }

    /**
     * @param bitmap
     * @param width
     * @param height
     * @return Cropped and divided long image as a list of bitmaps
     */
    public static List<Bitmap> cropBitmap(@NonNull Bitmap bitmap, int width, int height) {
        List<Bitmap> newBitmaps = new ArrayList<>();
        int w = bitmap.getWidth(); // Get the width and height of the image
        int h = bitmap.getHeight();
        int cropWidth = width; // The edge length of the square area to be cropped
        int cropHeight = height;
        for (int i = 0; i < h; i += cropHeight) {
            newBitmaps.add(Bitmap.createBitmap(bitmap, 0, i, cropWidth, ((h - i) < cropHeight ? (h - i) : cropHeight), null, false));
        }
        return newBitmaps;
    }

    public static Bitmap cropBitmap2(@NonNull Bitmap bitmap, int topHeight, int bottomHeight) {
        Bitmap newBitmap = null;
        int w = bitmap.getWidth(); // Get the width and height of the image
        int h = bitmap.getHeight();
        int cropWidth = w; // The edge length of the square area to be cropped
        int cropHeight = h - topHeight - bottomHeight;
        newBitmap = Bitmap.createBitmap(bitmap, 0, topHeight, w, cropHeight, null, false);
        return newBitmap;
    }


    /**
     * Save a bitmap object to local storage.
     * By default, it is saved in the Pictures directory.
     *
     * @return The path to the saved image.
     */
    public static String createSaveBitmapPath() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd-HHmmss", Locale.CHINA);
        File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/OX/Screenshots/");
        FileUtils.checkDirectory(file);
        return file.getAbsolutePath() + "/" + ScreenshotPrefixName + sdf.format(new Date()) + ".jpg";
    }

    public static String createSaveBitmapPath(Context context,  String dir, String imageName) {
        File file = new File(FileUtils.getFileSavedDir(context, dir));
        FileUtils.checkDirectory(file);
        String path = file.getAbsolutePath() + "/" + imageName;
        file = new File(path);
        if(!file.exists()){
            try {
                file.createNewFile();
            } catch (IOException e) {
                Log.e("ox_debug", e.getMessage());
            }
        }
        return path;
    }


    /**
     * Save to the application directory, not visible in the gallery.
     *
     * @param activity The activity context.
     * @param bitmap   The bitmap image to be saved.
     * @param isTip    Boolean flag indicating whether to show a toast message.
     * @return         The path to the saved image.
     */
    @RequiresApi(api = Build.VERSION_CODES.FROYO)
    public static String saveBitmap(Context activity, Bitmap bitmap, boolean isTip) {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd-HHmmss", Locale.CHINA);
        File file = new File(activity.getExternalFilesDir(null).getAbsolutePath() + "/OX/Screenshots/");
        FileUtils.checkDirectory(file);
        String path = file.getAbsolutePath() + "/" + ScreenshotPrefixName + sdf.format(new Date()) + ".jpg";
        file = new File(path);
        boolean b = FileUtils.saveBitmap(bitmap, file);
        if (isTip)
            Toast.makeText(activity, "save failed", Toast.LENGTH_SHORT).show();
//        notifyImageMedia(activity, file);
        return path;
    }

    public static String saveBitmap(Context context, Bitmap bitmap, String dir, String imageName) {

        File file = new File(FileUtils.getFileSavedDir(context, dir));
        FileUtils.checkDirectory(file);
        String path = file.getAbsolutePath() + "/" + imageName;
        file = new File(path);
        FileUtils.checkDirectory(file);
        FileUtils.saveBitmap(bitmap, file);
        return path;
    }


    /**
     * Save image to local storage and notify the system's media gallery.
     *
     * @param context The context of the application.
     * @param file    The file to be saved.
     */
    public static void notifyImageMedia(Context context, File file, boolean showMsg) {
        // Insert the file into the system's media gallery
        try {
            MediaStore.Images.Media.insertImage(context.getContentResolver(),
                    file.getAbsolutePath(), file.getName(), null);
            if (showMsg)
                Toast.makeText(context, "Save success", Toast.LENGTH_SHORT).show();
        } catch (FileNotFoundException e) {
            if (showMsg)
                Toast.makeText(context, "Save failed", Toast.LENGTH_SHORT).show();
            e.printStackTrace();
        }
        // Notify the media gallery to update
        context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE,
                Uri.fromFile(file)));
    }


    public static void actionSendApp(Activity activity) {

        Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("image/*");
        shareIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        PackageManager packageManager = activity.getPackageManager();
        List<ResolveInfo> resolveInfo = packageManager.queryIntentActivities(shareIntent, 0);
        if (!resolveInfo.isEmpty()) {
            List<Intent> targetedShareIntents = new ArrayList<Intent>();
            for (ResolveInfo info : resolveInfo) {
                Log.e("dysen", info.activityInfo.packageName + "====" + info.activityInfo.name);
            }
        }
    }

    public static Bitmap compressImage(Bitmap image, int quality) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 70, baos); // Quality compression method, 100 here means no compression, compressed data is stored in baos
        int options = 100;
        while (baos.toByteArray().length / 1024 > quality) { // Loop to check if the compressed image is larger than 100kb, if yes, continue compressing
            baos.reset(); // Reset baos, i.e., clear baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos); // Here, compress with options%, and store compressed data in baos
            options -= 10; // Decrease by 10 each time
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray()); // Store compressed data from baos into ByteArrayInputStream
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null); // Generate an image from ByteArrayInputStream data
        return bitmap;
    }

    public static Bitmap getImage(String srcPath) {
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        // Start reading the image, set options.inJustDecodeBounds back to true
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(srcPath, newOpts); // At this point, bm is null
        newOpts.inJustDecodeBounds = false; // After reading, set options.inJustDecodeBounds back to false
        int w = newOpts.outWidth;
        int h = newOpts.outHeight;
        // Nowadays, most smartphones have resolutions around 800*480, so we set height and width to
        float hh = 800f; // Set height to 800f
        float ww = 480f; // Set width to 480f
        // Scaling ratio. Since we are performing fixed ratio scaling, we only need to calculate one of the dimensions, height or width
        int be = 1; // be=1 means no scaling
        if (w > h && w > ww) { // If width is greater, scale according to width
            be = (int) (newOpts.outWidth / ww);
        } else if (w < h && h > hh) { // If height is greater, scale according to height
            be = (int) (newOpts.outHeight / hh);
        }
        if (be <= 0)
            be = 1;
        newOpts.inSampleSize = be; // Set scaling ratio
        bitmap = BitmapFactory.decodeFile(srcPath, newOpts); // Read image again, note that options.inJustDecodeBounds has been set back to false
        return bitmap; // Return the scaled image
        // return compressImage(bitmap, 300); // Optionally, you can compress the image further after scaling to the desired size
    }

    /*
     * Rotate an image.
     * @param angle The angle of rotation.
     * @param bitmap The original bitmap.
     * @return The rotated Bitmap.
     */
    public static Bitmap rotaingImageView(Bitmap bitmap, int angle) {
        // Rotation action for the image
        Matrix matrix = new Matrix();
        matrix.postRotate(angle);
        // Create a new image
        Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0,
                bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        return resizedBitmap;
    }

    /**
     * Read the rotation angle from the EXIF information of a photo.
     *
     * @param path The path of the photo.
     * @return The rotation angle in degrees.
     */
    public static int readPictureDegree(String path) {
        // Provide the image path
        int degree = 0;
        try {
            ExifInterface exifInterface = new ExifInterface(path);
            int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    degree = 90;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    degree = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    degree = 270;
                    break;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return degree;
    }

    // Save image to the specified path in the gallery
    public static String saveImageToGallery(Context context, Bitmap bmp, boolean showMsg) {
        String storePath = FileUtils.getFileSavedDir(context, Const.DIR_YLNEW_ROOT);
        File appDir = new File(storePath);
        if (!appDir.exists()) {
            appDir.mkdir();
        }
        String fileName = System.currentTimeMillis() + ".jpg";
        File file = new File(appDir, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            // Compress and save the image using I/O streams
            boolean isSuccess = bmp.compress(Bitmap.CompressFormat.JPEG, 60, fos);
            fos.flush();
            fos.close();
            // Notify the media scanner about the new image
            notifyImageMedia(context, file, showMsg);
            if (isSuccess) {
                return file.getAbsolutePath();
            } else {
                return "";
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * Read a local image.
     *
     * @param localUrl The physical address of the local image file.
     * @param opts Options for decoding the image. Can be null.
     * @return Bitmap If successful, returns the image object; otherwise, returns null.
     * @throws Exception If an exception occurs during the process.
     */
    public static Bitmap loadLocalBitmap(String localUrl, BitmapFactory.Options opts) throws Exception {
        try {
            return BitmapFactory.decodeFile(localUrl, opts);
        } catch (Exception e) {
            throw e;
        }
    }
}
