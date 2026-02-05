package com.ox.ox_common.utils;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.ParcelFileDescriptor;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;

import com.luck.picture.lib.utils.PictureFileUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Locale;


/**
 * Created by lisen on 2019/10/28.
 *
 * @author lisen < 453354858@qq.com >
 */
@SuppressWarnings("all")
public class Saver {
    private Context context;
    private AppPath appPath;

    private MediaScannerConnection mediaScannerConnection;

    public Saver(Context context) {
        this.context = context;
        appPath = new AppPath(context);
    }

    /**
     * @param saveUrl
     * @param iFinishListener
     */
    public void saveImg(final String saveUrl, final IFinishListener iFinishListener) {
        saveToAppPrivate(saveUrl,appPath.getAppImgDirPath(),iFinishListener);
    }
    /**
     * @param saveUrl
     * @param iFinishListener
     */
    public void saveVideo(final String saveUrl, final IFinishListener iFinishListener) {
        saveToAppPrivate(saveUrl,appPath.getAppVideoDirPath(),iFinishListener);
    }

    public void saveAudio(final String saveUrl, final IFinishListener iFinishListener) {
        saveToAppPrivate(saveUrl,appPath.getAppAudioDirPath(),iFinishListener);
    }

    //    public void saveFile(final String saveUrl, final IFinishListener iFinishListener) {
//        saveToAppPrivate(saveUrl,appPath.getAppDownloadDirPath(),iFinishListener);
//    }
    public void saveMusicFile(final String saveUrl, final IFinishListener iFinishListener) {
        saveToAppPrivate(saveUrl,appPath.getAppMusicDirPath(),iFinishListener);
    }
//    public void saveTextFile(final String saveUrl, final IFinishListener iFinishListener) {
//        saveToAppPrivate(saveUrl,appPath.getAppDocumentsDirPath(),iFinishListener);
//    }
//    public void saveLog(final String saveUrl, final IDownload iDownload) {
//        saveToSD(saveUrl,appPath.getAppLogDirPath(),iDownload);
//    }

    private void saveToAppPrivate(final String saveUrl, String destDir,final IFinishListener iFinishListener){
        final String fileName = saveUrl.substring(saveUrl.lastIndexOf("/") + 1);
        final File file = new File(destDir,fileName);
        //访问沙盒中的文件时，file.exists() 是准确的
        if (!file.exists() || file.length() <= 0){
            download(saveUrl, destDir, new IDownload() {
                @Override
                public void onDownloadSuccess(String filePath, String fileName) {
                    if (iFinishListener != null){
                        FileInfo fileInfo = new FileInfo();
                        fileInfo.setBeforeDownload(false);
                        fileInfo.setSize(file.length());
                        fileInfo.setPath(file.getAbsolutePath());
                        fileInfo.setUri(null);
                        iFinishListener.onSuccess(fileInfo);
                    }
                }

                @Override
                public void onDownloadFailed(String errorMsg) {
                    if (iFinishListener != null){
                        iFinishListener.onFailed(errorMsg);
                    }
                }
            });
        }else{
            if (iFinishListener != null){
                FileInfo fileInfo = new FileInfo();
                fileInfo.setBeforeDownload(true);
                fileInfo.setSize(file.length());
                fileInfo.setPath(file.getAbsolutePath());
                fileInfo.setUri(null);
                iFinishListener.onSuccess(fileInfo);
            }
        }
    }

    /**
     * androidQ 保存在 sd/Pictures，非 sd/packageName/Pictures
     * 保存到相册，卸载后不会被删除
     *
     * @param saveUrl
     * @param iDownload
     */

    public void saveImgToGallery(final String saveUrl, final IFinishListener iFinishListener) {
        final String fileName = saveUrl.substring(saveUrl.lastIndexOf("/") + 1);
        String dirPath = appPath.getAppImgDirPath();

        String selection = MediaStore.Images.Media.DISPLAY_NAME + "='" + fileName + "'";
        Uri uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        String columnIdName = MediaStore.Images.Media._ID;
        String size = MediaStore.Images.Media.SIZE;
        String data = MediaStore.Images.Media.DATA;
        String order = MediaStore.Images.Media.SIZE + " DESC";

        FileInfo fileInfo = null;

        //判断文件是否下载过
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            fileInfo = getFileInfo(uri,selection, columnIdName, size, data,order);
        }else{
            //低于android q 数据库中存储的名称不同机型有差异
            final File file = new File(dirPath,fileName);
            if (file.exists() && file.length() > 0){
                fileInfo = new FileInfo();
                fileInfo.setBeforeDownload(true);
                fileInfo.setUri(PictureFileUtils.parUri(context,file));
                fileInfo.setPath(file.getAbsolutePath());
                fileInfo.setSize(file.length());
            }
        }

        if (fileInfo != null && fileInfo.size > 0) {
            fileInfo = copyImgToPicture(fileInfo.getPath(), fileName);
            notifyGallery(fileInfo.getPath());
            if (iFinishListener != null) {
                iFinishListener.onSuccess(fileInfo);
            }
        } else {
            download(saveUrl,dirPath , new IDownload() {
                @Override
                public void onDownloadSuccess(String filePath, String fileName) {
                    //下载到私有目录成功并复制到公有目录
                    FileInfo fileInfo  = copyImgToPicture(filePath, fileName);
                    notifyGallery(fileInfo.getPath());
                        /*File originFile = new File(filePath);
                        originFile.delete();*/
                    if (iFinishListener != null) {
                        iFinishListener.onSuccess(fileInfo);
                    }
                }

                @Override
                public void onDownloadFailed(String errorMsg) {
                    if (iFinishListener != null) {
                        iFinishListener.onFailed(errorMsg);
                    }
                }
            });
        }



    }

    /**
     * androidQ 保存在 sd/Movies，非 sd/packageName/Movies
     * 保存到相册，卸载后不会被删除
     *
     * @param saveUrl
     * @param iDownload
     */
    public void saveVideoToGallery(final String saveUrl, final IFinishListener iFinishListener) {
        final String fileName = saveUrl.substring(saveUrl.lastIndexOf("/") + 1);
        String dirPath = appPath.getAppVideoDirPath();

        String selection = MediaStore.Video.Media.DISPLAY_NAME + "='" + fileName + "'";
        Uri uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        String columnIdName = MediaStore.Video.Media._ID;
        String size = MediaStore.Video.Media.SIZE;
        String data = MediaStore.Video.Media.DATA;
        String order = MediaStore.Video.Media.SIZE + " DESC";

        FileInfo fileInfo = null;

        //判断文件是否下载过
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            fileInfo = getFileInfo(uri,selection, columnIdName, size, data,order);
        }else{
            //低于android q 数据库中存储的名称不同机型有差异
            final File file = new File(dirPath,fileName);
            if (file.exists() && file.length() > 0){
                fileInfo = new FileInfo();
                fileInfo.setBeforeDownload(true);
                fileInfo.setUri(PictureFileUtils.parUri(context,file));
                fileInfo.setPath(file.getAbsolutePath());
                fileInfo.setSize(file.length());
            }
        }
        if (fileInfo != null) {
            fileInfo = copyToMovies(fileInfo.getPath(), fileName);
            notifyGallery(fileInfo.getPath());
            if (iFinishListener != null) {
                iFinishListener.onSuccess(fileInfo);
            }
        }else{
            download(saveUrl,dirPath , new IDownload() {
                @Override
                public void onDownloadSuccess(String filePath, String fileName) {

                    //下载到私有目录成功并复制到公有目录
                    FileInfo fileInfo = copyToMovies(filePath, fileName);
                    notifyGallery(fileInfo.getPath());
                    /*File originFile = new File(filePath);
                    originFile.delete();*/
                    if (iFinishListener != null){
                        iFinishListener.onSuccess(fileInfo);
                    }
                }
                @Override
                public void onDownloadFailed(String errorMsg) {
                    if (iFinishListener != null) {
                        iFinishListener.onFailed(errorMsg);
                    }
                }
            });
        }
    }

    /**
     * androidQ 保存在 sd/Download，非 sd/packageName/Download
     * 下载文件到公有目录，卸载后不会被删除
     *
     * 只有29 才有 MediaStore.Downloads
     * @param saveUrl
     * @param iDownload
     */
    public void saveFileToDownload(final String saveUrl, final IFinishListener iFinishListener) {
        final String fileName = saveUrl.substring(saveUrl.lastIndexOf("/") + 1);
        String dirPath = appPath.getAppDownloadDirPath();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){

            String selection = MediaStore.Downloads.DISPLAY_NAME + "='" + fileName + "'";
            Uri uri = MediaStore.Downloads.EXTERNAL_CONTENT_URI;
            String columnIdName = MediaStore.Downloads._ID;
            String size = MediaStore.Downloads.SIZE;
            String data = MediaStore.Downloads.DATA;
            String order = MediaStore.Downloads.SIZE + " DESC";
            FileInfo fileInfo = getFileInfo(uri,selection, columnIdName, size, data,order);
            if (fileInfo != null && fileInfo.size > 0) {
                if (iFinishListener != null) {
                    iFinishListener.onSuccess(fileInfo);
                }
            }else{
                File dir = new File(dirPath);
                if (!dir.exists()){
                    dir.mkdirs();
                }
                download(saveUrl, dirPath, new IDownload() {
                    @Override
                    public void onDownloadSuccess(String filePath, String fileName) {
                        FileInfo fileInfo = copyToDownload(filePath, fileName);
                        notifyGallery(fileInfo.getPath());
                        /*File originFile = new File(filePath);
                        originFile.delete();*/
                        if (iFinishListener != null){
                            iFinishListener.onSuccess(fileInfo);
                        }
                    }

                    @Override
                    public void onDownloadFailed(String errorMsg) {
                        if (iFinishListener != null) {
                            iFinishListener.onFailed(errorMsg);
                        }
                    }
                });
            }
        }else{
            dirPath = Environment.getExternalStorageDirectory()+"/"+ appPath.getPackageName()+"/Download";
            File dir = new File(dirPath);
            if (!dir.exists()){
                dir.mkdirs();
            }
            checkOrDownload(saveUrl,dirPath,fileName,iFinishListener);
        }

    }

    /**
     * @param saveUrl
     * @param iFinishListener
     */
    public void saveMusicFileToMusic(final String saveUrl, final IFinishListener iFinishListener) {

        final String fileName = saveUrl.substring(saveUrl.lastIndexOf("/") + 1);
        String dirPath = appPath.getAppMusicDirPath();
        String selection = MediaStore.Audio.Media.DISPLAY_NAME + "='" + fileName + "'";
        Uri uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
        String columnIdName = MediaStore.Audio.Media._ID;
        String size = MediaStore.Audio.Media.SIZE;
        String data = MediaStore.Audio.Media.DATA;
        String order = MediaStore.Audio.Media.SIZE + " DESC";

        FileInfo fileInfo = null;

        //判断文件是否下载过
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            fileInfo = getFileInfo(uri,selection, columnIdName, size, data,order);
        }else{
            //低于android q 数据库中存储的名称不同机型有差异
            final File file = new File(dirPath,fileName);
            if (file.exists() && file.length() > 0){
                fileInfo = new FileInfo();
                fileInfo.setBeforeDownload(true);
                fileInfo.setUri(PictureFileUtils.parUri(context,file));
                fileInfo.setPath(file.getAbsolutePath());
                fileInfo.setSize(file.length());
            }
        }


        if (fileInfo != null && fileInfo.size > 0) {
            if (iFinishListener != null) {
                iFinishListener.onSuccess(fileInfo);
            }
        }else{
            download(saveUrl, dirPath, new IDownload() {
                @Override
                public void onDownloadSuccess(String filePath, String fileName) {
                    //下载到私有目录成功并复制到公有目录
                    FileInfo fileInfo = copyToMusic(filePath, fileName);
                    notifyGallery(fileInfo.getPath());
                    /*File originFile = new File(filePath);
                    originFile.delete();*/
                    if (iFinishListener != null){
                        iFinishListener.onSuccess(fileInfo);
                    }
                }

                @Override
                public void onDownloadFailed(String errorMsg) {
                    if (iFinishListener != null) {
                        iFinishListener.onFailed(errorMsg);
                    }
                }
            });
        }
    }

    private void checkOrDownload(String saveUrl, String dirPath, final String fileName,final IFinishListener iFinishListener){
        final FileInfo fileInfo = new FileInfo();
        final File file = new File(dirPath,fileName);
        if (file.exists() && file.length() > 0){
            fileInfo.setBeforeDownload(true);
            fileInfo.setUri(null);
            fileInfo.setPath(file.getAbsolutePath());
            fileInfo.setSize(file.length());
            if (iFinishListener != null) {
                iFinishListener.onSuccess(fileInfo);
            }
            notifyGallery(fileInfo.getPath());
        }else{
            download(saveUrl,dirPath , new IDownload() {
                @Override
                public void onDownloadSuccess(String filePath, String fileName) {
                    fileInfo.setBeforeDownload(false);
                    fileInfo.setUri(null);
                    fileInfo.setPath(file.getAbsolutePath());
                    fileInfo.setSize(file.length());
                    notifyGallery(fileInfo.getPath());
                    if (iFinishListener != null) {
                        iFinishListener.onSuccess(fileInfo);
                    }
                }

                @Override
                public void onDownloadFailed(String errorMsg) {
                    if (iFinishListener != null) {
                        iFinishListener.onFailed(errorMsg);
                    }
                }
            });
        }

    }
    /**
     * androidQ 保存在 sd/Pictures，非 sd/packageName/Pictures
     * @param saveUrl
     * @param iFinishListener
     */
    public void saveByteDataToGallery(final byte[] data, final IFinishListener iFinishListener) {

        new Thread(new Runnable() {
            @Override
            public void run() {
                try{
                    File dir = new File(appPath.getAppImgDirPath());
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    String suffix = ".png";
                    final String fileName = System.currentTimeMillis() + suffix;
                    final File imageFile = new File(dir, fileName);

                    FileOutputStream out = null;
                    out = new FileOutputStream(imageFile, false);
                    out.write(data, 0, data.length);
                    out.flush();
                    out.close();

                    new Handler(context.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            FileInfo fileInfo = copyImgToPicture(imageFile.getAbsolutePath(),fileName);
                            notifyGallery(fileInfo.getPath());
                            //这里是为了点击查看大图，android q 无法访问其他目录
                            fileInfo.setPath(imageFile.getAbsolutePath());
                            if (iFinishListener != null){
                                iFinishListener.onSuccess(fileInfo);
                            }
                        }
                    });
                }catch (Exception e){
                    e.printStackTrace();
                    new Handler(context.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            if (iFinishListener != null){
                                iFinishListener.onFailed(e.getMessage());
                            }
                        }
                    });

                }
            }
        }).start();

    }

    public void saveBase64ToToGallery(String base64Img, final IFinishListener iFinishListener){
        byte[] bytes = Base64.decode(base64Img.split(",")[1], Base64.DEFAULT);
        saveByteDataToGallery(bytes,iFinishListener);
    }
    public void saveViewToToGallery(View view, final IFinishListener iFinishListener){
        saveBitmapToToGallery(createViewBitmap(view),iFinishListener);
    }
    public Bitmap createViewBitmap(View v) {
        Bitmap bitmap = Bitmap.createBitmap(v.getWidth(), v.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        v.draw(canvas);
        return bitmap;
    }
    public void saveBitmapToToGallery(Bitmap bitmap, final IFinishListener iFinishListener){
        File dir = new File(appPath.getAppImgDirPath());
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String suffix = bitmap.hasAlpha() ? ".png" : ".jpg";
        final String fileName = System.currentTimeMillis() + suffix;
        final File imageFile = new File(dir, fileName);

        FileOutputStream out = null;
        try {
            out = new FileOutputStream(imageFile, false);
            bitmap.compress(bitmap.hasAlpha() ? Bitmap.CompressFormat.PNG : Bitmap.CompressFormat.JPEG, 100, out);
            out.flush();
            out.close();
            bitmap = null;
        } catch (Exception e) {
            e.printStackTrace();
        }

        new Handler(context.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                FileInfo fileInfo = new FileInfo();
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
                    fileInfo = copyImgToPicture(imageFile.getAbsolutePath(),fileName);
                }else{
                    fileInfo.setBeforeDownload(false);
                    fileInfo.setUri(null);
                    fileInfo.setPath(imageFile.getAbsolutePath());
                    fileInfo.setSize(imageFile.length());
                }
                notifyGallery(fileInfo.getPath());
                if (iFinishListener != null){
                    iFinishListener.onSuccess(fileInfo);
                }
            }
        });

    }

    /**
     * @param saveUrl
     * @param saveDir   使用 AppPath 类中定义的数据
     * @param iDownload
     */
    public void download(final String saveUrl, String saveDir, final IDownload iDownload) {
        if (TextUtils.isEmpty(saveUrl)) {
            return;
        }
        File dir = new File(saveDir);

        if (!dir.exists()){
            dir.mkdirs();
        }
        final String fileName = saveUrl.substring(saveUrl.lastIndexOf("/") + 1);

        final File downFile = new File(saveDir, fileName);
        if (!downFile.exists()){
            try {
                downFile.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        new Thread(new Runnable() {
            InputStream inputStream = null;
            FileOutputStream fileOutputStream = null;

            @Override
            public void run() {
                try {
                    //防止中文名称
                    String substringUrl = saveUrl.substring(0,saveUrl.lastIndexOf("/") + 1)+ URLEncoder.encode(fileName,"utf-8");

                    URL url = new URL(URLDecoder.decode(substringUrl,"utf-8"));
                    final HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("GET");
                    connection.setDoInput(true);
                    connection.connect();
                    int responseCode = connection.getResponseCode();
                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        inputStream = connection.getInputStream();
                        fileOutputStream = new FileOutputStream(downFile);
                        int len;
                        byte[] b = new byte[1024 * 5];
                        while ((len = inputStream.read(b)) != -1) {
                            fileOutputStream.write(b, 0, len);
                        }
                        fileOutputStream.close();
                        inputStream.close();

                        new Handler(context.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                if (iDownload != null) {
                                    iDownload.onDownloadSuccess(downFile.getAbsolutePath(), fileName);
                                }
                            }
                        });
                    } else {
                        new Handler(context.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                if (iDownload != null) {
                                    iDownload.onDownloadFailed("下载失败");
                                }
                            }
                        });
                    }

                } catch (final Exception e) {
                    e.printStackTrace();
                    new Handler(context.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            if (iDownload != null) {
                                iDownload.onDownloadFailed(e.getMessage());
                            }
                        }
                    });
                    try {
                        if (fileOutputStream != null) {
                            fileOutputStream.close();
                        }
                        if (inputStream != null) {
                            inputStream.close();
                        }
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }).start();
    }


    private FileInfo copyImgToPicture(String originFilePath, String fileName) {
        ContentValues values = new ContentValues();
        // Generate unique file name to avoid conflicts
        String uniqueFileName = generateUniqueFileName(fileName, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        values.put(MediaStore.Images.Media.DISPLAY_NAME, uniqueFileName);
        values.put(MediaStore.Images.Media.TITLE, uniqueFileName);
        values.put(MediaStore.Images.Media.DESCRIPTION, uniqueFileName);
        values.put(MediaStore.Images.Media.MIME_TYPE, getMIMEType(fileName));
        return copy(originFilePath, values, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
    }

    private FileInfo copyToMovies(String originFilePath, String fileName) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Video.Media.DISPLAY_NAME, fileName);
        values.put(MediaStore.Video.Media.TITLE, fileName);
        values.put(MediaStore.Video.Media.DESCRIPTION, fileName);
        values.put(MediaStore.Video.Media.MIME_TYPE, getMIMEType(fileName));
        return copy(originFilePath, values, MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
    }

    //只有29 才有 MediaStore.Downloads
    private FileInfo copyToDownload(String originFilePath, String fileName) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Downloads.DISPLAY_NAME, fileName);
        values.put(MediaStore.Downloads.TITLE, fileName);
        values.put(MediaStore.Downloads.MIME_TYPE, getMIMEType(fileName));
        return copy(originFilePath, values, MediaStore.Downloads.EXTERNAL_CONTENT_URI);
    }
    private FileInfo copyToMusic(String originFilePath, String fileName) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Audio.Media.DISPLAY_NAME, fileName);
        values.put(MediaStore.Audio.Media.TITLE, fileName);
        values.put(MediaStore.Audio.Media.MIME_TYPE, getMIMEType(fileName));
        return copy(originFilePath, values, MediaStore.Audio.Media.EXTERNAL_CONTENT_URI);
    }


    /**
     * Generate unique file name to avoid conflicts
     * @param originalFileName Original file name
     * @param uri MediaStore URI
     * @return Unique file name with number suffix if needed
     */
    private String generateUniqueFileName(String originalFileName, Uri uri) {
        ContentResolver resolver = context.getContentResolver();
        String displayNameColumn = null;
        String selectionColumn = null;
        
        // Determine column name based on URI type
        if (uri.equals(MediaStore.Images.Media.EXTERNAL_CONTENT_URI)) {
            displayNameColumn = MediaStore.Images.Media.DISPLAY_NAME;
            selectionColumn = MediaStore.Images.Media.DISPLAY_NAME;
        } else if (uri.equals(MediaStore.Video.Media.EXTERNAL_CONTENT_URI)) {
            displayNameColumn = MediaStore.Video.Media.DISPLAY_NAME;
            selectionColumn = MediaStore.Video.Media.DISPLAY_NAME;
        } else if (uri.equals(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI)) {
            displayNameColumn = MediaStore.Audio.Media.DISPLAY_NAME;
            selectionColumn = MediaStore.Audio.Media.DISPLAY_NAME;
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && uri.equals(MediaStore.Downloads.EXTERNAL_CONTENT_URI)) {
            displayNameColumn = MediaStore.Downloads.DISPLAY_NAME;
            selectionColumn = MediaStore.Downloads.DISPLAY_NAME;
        }
        
        if (displayNameColumn == null) {
            return originalFileName;
        }
        
        // Extract file name and extension
        int lastDot = originalFileName.lastIndexOf('.');
        String baseName = lastDot > 0 ? originalFileName.substring(0, lastDot) : originalFileName;
        String extension = lastDot > 0 ? originalFileName.substring(lastDot) : "";
        
        // Check if file name already exists
        String selection = selectionColumn + "=?";
        String[] selectionArgs = {originalFileName};
        Cursor cursor = resolver.query(uri, new String[]{displayNameColumn}, selection, selectionArgs, null);
        
        if (cursor == null || cursor.getCount() == 0) {
            if (cursor != null) {
                cursor.close();
            }
            return originalFileName;
        }
        cursor.close();
        
        // File name exists, generate unique name with number suffix
        int counter = 1;
        String uniqueFileName;
        do {
            uniqueFileName = baseName + " (" + counter + ")" + extension;
            selectionArgs[0] = uniqueFileName;
            cursor = resolver.query(uri, new String[]{displayNameColumn}, selection, selectionArgs, null);
            boolean exists = cursor != null && cursor.getCount() > 0;
            if (cursor != null) {
                cursor.close();
            }
            if (!exists) {
                return uniqueFileName;
            }
            counter++;
        } while (counter < 1000); // Safety limit
        
        // Fallback: use timestamp
        return baseName + "_" + System.currentTimeMillis() + extension;
    }

    private FileInfo copy(String originFilePath, ContentValues values, Uri uri) {

        FileInfo fileInfo = new FileInfo();
        fileInfo.setBeforeDownload(false);
        String outPath = "";
        ContentResolver resolver = context.getContentResolver();
        Uri insertUri = resolver.insert(uri, values);

        InputStream inputStream = null;
        OutputStream outputStream = null;
        try {
            inputStream = new FileInputStream(new File(originFilePath));
            if (insertUri != null) {
                fileInfo.setUri(insertUri);
                outputStream = resolver.openOutputStream(insertUri);
                outPath = getPath(context, insertUri);

                fileInfo.setPath(outPath);
            }
            if (outputStream != null) {
                byte[] buffer = new byte[1024 * 5];
                long totalCount = 0;
                int byteCount = 0;
                while ((byteCount = inputStream.read(buffer)) != -1) {  // 循环从输入流读取 buffer字节
                    totalCount += byteCount;
                    outputStream.write(buffer, 0, byteCount);        // 将读取的输入流写入到输出流
                }
                fileInfo.setSize(totalCount);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return fileInfo;
    }

    private void test(Uri mediaStoreUri) {
        ContentResolver resolver = context.getContentResolver();
        Cursor cursor = resolver.query(mediaStoreUri,null, null, null, null);
        if (cursor != null && cursor.moveToFirst()) {

            while (cursor.moveToNext()){

                Log.e("cursor", "getFileInfo: cursor= > "+cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA))+"==: "+cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)) );
            }

            cursor.close();
        }
    }

    /**
     * @param mediaStoreUri MediaStore.Images.Media.EXTERNAL_CONTENT_URI
     * @param selection     String selection = MediaStore.Images.Media.BUCKET_DISPLAY_NAME + "='" + fileName + "'";
     * @param columnIdName  MediaStore.Images.Media._ID
     * @return
     */
    private FileInfo getFileInfo(Uri mediaStoreUri, String selection, String columnIdName, String columnSizeName, String columnPathName, String order) {
        ContentResolver resolver = context.getContentResolver();
        if (resolver == null) {
            return null;
        }
        Cursor cursor = resolver.query(mediaStoreUri, new String[]{columnIdName, columnSizeName, columnPathName}, selection, null, order);
        if (cursor != null && cursor.moveToFirst()) {

            FileInfo fileInfo = new FileInfo();
            fileInfo.setBeforeDownload(true);
            int columnId = cursor.getColumnIndex(columnIdName);
            int mediaId = cursor.getInt(columnId);
            Uri itemUri = Uri.withAppendedPath(mediaStoreUri, "" + mediaId);
            fileInfo.setUri(itemUri);
            fileInfo.setSize(cursor.getLong(cursor.getColumnIndex(columnSizeName)));
            fileInfo.setPath(cursor.getString(cursor.getColumnIndex(columnPathName)));
            cursor.close();
            return fileInfo;
        }
        return null;
    }

    /**
     * FileInfo fileInfo = getFileInfo(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,selection,columnIdName,MediaStore.Images.Media.SIZE,MediaStore.Images.Media.DATA,MediaStore.Images.Media.DATE_MODIFIED + " DESC");
     * boolean exists = isFileExists(fileUri);
     *
     * @param uri
     * @return
     */
    public boolean isFileExists(Uri uri) {
        if (uri == null) {
            return false;
        }
        ContentResolver cr = context.getContentResolver();
        try {
            ParcelFileDescriptor descriptor = cr.openFileDescriptor(uri, "r");
            if (null == descriptor) {
                return false;
            } else {
                try {
                    descriptor.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        return true;
    }

    public static class FileInfo {
        private long size;
        private Uri uri;
        private String path;
        //是否是以前下载，true : 以前下载, false :刚刚下载的新文件
        private boolean isBeforeDownload;

        public boolean isBeforeDownload() {
            return isBeforeDownload;
        }

        public void setBeforeDownload(boolean beforeDownload) {
            isBeforeDownload = beforeDownload;
        }

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }

        public long getSize() {
            return size;
        }

        public void setSize(long size) {
            this.size = size;
        }

        public Uri getUri() {
            return uri;
        }

        public void setUri(Uri uri) {
            this.uri = uri;
        }

        @Override
        public String toString() {
            return "FileInfo{" +
                    "size=" + size +
                    ", uri=" + uri +
                    ", path='" + path + '\'' +
                    ", isBeforeDownload=" + isBeforeDownload +
                    '}';
        }
    }

    private void notifyGallery(final String path) {
        MediaScannerConnection.MediaScannerConnectionClient client = new MediaScannerConnection.MediaScannerConnectionClient() {
            @Override
            public void onMediaScannerConnected() {
                mediaScannerConnection.scanFile(path, null);
            }

            @Override
            public void onScanCompleted(String path, Uri uri) {
                mediaScannerConnection.disconnect();
            }
        };
        mediaScannerConnection = new MediaScannerConnection(context, client);
        mediaScannerConnection.connect();
    }


    public interface IFinishListener{
        void onSuccess(FileInfo fileInfo);
        void onFailed(String errorMsg);
    }

    public interface IDownload {
        /**
         *
         * @param filePath
         * @param fileName
         */
        void onDownloadSuccess(String filePath, String fileName);

        /**
         * 失败
         *
         * @param errorMsg
         */
        void onDownloadFailed(String errorMsg);
    }


    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    public static boolean isGooglePhotosUri(Uri uri) {
        return "com.google.android.apps.photos.content".equals(uri.getAuthority());
    }

    /**
     * Get the value of the data column for this Uri. This is useful for
     * MediaStore Uris, and other file-based ContentProviders.
     *
     * @param context       The context.
     * @param uri           The Uri to query.
     * @param selection     (Optional) Filter used in the query.
     * @param selectionArgs (Optional) Selection arguments used in the query.
     * @return The value of the _data column, which is typically a file path.
     * @author paulburke
     */
    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {

        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {
                column
        };

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } catch (IllegalArgumentException ex) {
            Log.i("==>", String.format(Locale.getDefault(), "getDataColumn: _data - [%s]", ex.getMessage()));
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return null;
    }

    public String getPath(final Context context, final Uri uri) {
        final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;

        // DocumentProvider
        if (isKitKat && DocumentsContract.isDocumentUri(context, uri)) {
            if (isDownloadsDocument(uri)) {

                final String id = DocumentsContract.getDocumentId(uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }

                final String selection = "_id=?";
                final String[] selectionArgs = new String[]{
                        split[1]
                };

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {

            // Return the remote address
            if (isGooglePhotosUri(uri)) {
                return uri.getLastPathSegment();
            }

            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }


    private final String[][] MIME_MapTable = {
            //{后缀名，    MIME类型}
            {".3gp", "video/3gpp"},
            {".apk", "application/vnd.android.package-archive"},
            {".asf", "video/x-ms-asf"},
            {".avi", "video/x-msvideo"},
            {".bin", "application/octet-stream"},
            {".bmp", "image/bmp"},
            {".c", "text/plain"},
            {".class", "application/octet-stream"},
            {".conf", "text/plain"},
            {".cpp", "text/plain"},
            {".doc", "application/msword"},
            {".exe", "application/octet-stream"},
            {".gif", "image/gif"},
            {".gtar", "application/x-gtar"},
            {".gz", "application/x-gzip"},
            {".h", "text/plain"},
            {".htm", "text/html"},
            {".html", "text/html"},
            {".jar", "application/java-archive"},
            {".java", "text/plain"},
            {".jpeg", "image/jpeg"},
            {".jpg", "image/jpeg"},
            {".js", "application/x-javascript"},
            {".log", "text/plain"},
            {".m3u", "audio/x-mpegurl"},
            {".m4a", "audio/mp4a-latm"},
            {".m4b", "audio/mp4a-latm"},
            {".m4p", "audio/mp4a-latm"},
            {".m4u", "video/vnd.mpegurl"},
            {".m4v", "video/x-m4v"},
            {".mov", "video/quicktime"},
            {".mp2", "audio/x-mpeg"},
            {".mp3", "audio/x-mpeg"},
            {".mp4", "video/mp4"},
            {".mpc", "application/vnd.mpohun.certificate"},
            {".mpe", "video/mpeg"},
            {".mpeg", "video/mpeg"},
            {".mpg", "video/mpeg"},
            {".mpg4", "video/mp4"},
            {".mpga", "audio/mpeg"},
            {".msg", "application/vnd.ms-outlook"},
            {".ogg", "audio/ogg"},
            {".pdf", "application/pdf"},
            {".png", "image/png"},
            {".pps", "application/vnd.ms-powerpoint"},
            {".ppt", "application/vnd.ms-powerpoint"},
            {".prop", "text/plain"},
            {".rar", "application/x-rar-compressed"},
            {".rc", "text/plain"},
            {".rmvb", "audio/x-pn-realaudio"},
            {".rtf", "application/rtf"},
            {".sh", "text/plain"},
            {".tar", "application/x-tar"},
            {".tgz", "application/x-compressed"},
            {".txt", "text/plain"},
            {".wav", "audio/x-wav"},
            {".wma", "audio/x-ms-wma"},
            {".wmv", "audio/x-ms-wmv"},
            {".wps", "application/vnd.ms-works"},
            //{".xml",    "text/xml"},
            {".xml", "text/plain"},
            {".z", "application/x-compress"},
            {".zip", "application/zip"},

            {".xlm", "application/vnd.ms-excel"},
            {".xls", "application/vnd.ms-excel"},
            {".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"},
            {".xlt", "application/vnd.ms-excel"},
            {".xlw", "application/vnd.ms-excel"},
            {".xm", "audio/x-mod"},
            {".xml", "text/plain"},
            {".xml", "application/xml"},
            {".xmz", "audio/x-mod"},
            {".xof", "x-world/x-vrml"},
            {".xpi", "application/x-xpinstall"},
            {".xpm", "image/x-xpixmap"},
            {".xsit", "text/xml"},
            {".xsl", "text/xml"},
            {".xul", "text/xul"},
            {".xwd", "image/x-xwindowdump"},
            {".xyz", "chemical/x-pdb"},
            {".yz1", "application/x-yz1"},
            {".z", "application/x-compress"},
            {".zac", "application/x-zaurus-zac"},
            {".docx", "application/msword"},
            {".1", "application/vnd.android.package-archive"}
    };

    public String getMIMEType(String fileName) {

        String type = "*/*";
        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex < 0){
            return type;
        }
        String fileType = fileName.substring(dotIndex).toLowerCase();
        if (TextUtils.isEmpty(fileType)){
            return type;
        }
        for (int i = 0; i < MIME_MapTable.length; i++) {
            if (fileType.equals(MIME_MapTable[i][0])){
                return MIME_MapTable[i][1];
            }
        }
        return type;
    }
}
