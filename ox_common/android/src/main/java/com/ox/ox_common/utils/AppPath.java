package com.ox.ox_common.utils;

import android.content.Context;

import java.io.File;
import java.io.IOException;

@SuppressWarnings("all")
public class AppPath {
    private Context context;
    private String packageName;
    public AppPath(Context context) {
        this.context = context;
        packageName = context.getPackageName();
        packageName = packageName.substring(packageName.lastIndexOf(".")+1);
    }

    public String getPackageName() {
        return packageName;
    }

    /**
     *
     * @return  sd/->/android/data/packageName/files/
     */
    public String getAppDirPath() {
        File privatePicDir = context.getExternalFilesDir(null);
        if (privatePicDir != null) {
            return privatePicDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     *
     * @return Q : sd/->/android/data/packageName/files/Download
     */
    public String getAppDownloadDirPath() {
        File privatePicDir = context.getExternalFilesDir("Download");
        if (privatePicDir != null) {
            return privatePicDir.getAbsolutePath();
        }
        return context.getFilesDir().getPath();
    }

    /**
     * Retrieve the path where the APP saves camera images
     *
     * @return  sd/->/android/data/packageName/files/DCIM
     */
    public String getAppDCIMDirPath() {
        File picDir = context.getExternalFilesDir("DCIM");
        if (picDir != null) {
            return picDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     *
     * @return  sd/->/android/data/packageName/files/Pictures
     */
    public String getAppImgDirPath() {
        File picDir = context.getExternalFilesDir("Pictures");
        if (picDir != null) {
            createNomedia(picDir.getAbsolutePath());
            return picDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }

    private void createNomedia(String path) {
        File nomedia = new File(path,".nomedia");
        if (!nomedia.exists()){
            try {
                nomedia.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     *
     * @return sd/->/android/data/packageName/files/Movies
     */
    public String getAppVideoDirPath() {

        File videoDir = context.getExternalFilesDir("Movies");
        if (videoDir != null) {
            createNomedia(videoDir.getAbsolutePath());
            return videoDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }

    /**
     * Saved audio recording file
     * The field Environment.DIRECTORY_AUDIOBOOKS is only available for 29 seconds
     * @return sd/->/android/data/packageName/files/Audiobooks
     */
    public String getAppAudioDirPath() {
        File audioDir = context.getExternalFilesDir("Audiobooks");
        if (audioDir != null) {
            return audioDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     * Saved music file
     *
     * @return sd/->/android/data/packageName/files/Music
     */
    public String getAppMusicDirPath() {
        File dir = context.getExternalFilesDir("Music");
        if (dir != null) {
            return dir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }

    /**
     * saved text file
     * @return sd/->/android/data/packageName/files/Documents
     */
    public String getAppDocumentsDirPath() {
        File dir = context.getExternalFilesDir("Documents");
        if (dir != null) {
            return dir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     * saved logs file
     * @return sd/->/android/data/packageName/files/Documents/logs
     */
    public String getAppLogDirPath() {
        return getAppDocumentsDirPath() + "/logs/";
    }
}
