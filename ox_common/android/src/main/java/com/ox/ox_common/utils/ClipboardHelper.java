package com.ox.ox_common.utils;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.provider.MediaStore;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class ClipboardHelper {

    public static boolean hasImages(Context context) {
        ClipboardManager clipboard = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
        if (clipboard == null || !clipboard.hasPrimaryClip()) {
            return false;
        }

        ClipData clipData = clipboard.getPrimaryClip();
        if (clipData == null) {
            return false;
        }

        for (int i = 0; i < clipData.getItemCount(); i++) {
            ClipData.Item item = clipData.getItemAt(i);
            Uri uri = item.getUri();
            if (uri != null) {
                String mimeType = context.getContentResolver().getType(uri);
                if (mimeType != null && mimeType.startsWith("image/")) {
                    return true;
                }
            }
        }
        return false;
    }

    public static List<String> getImages(Context context) {
        ClipboardManager clipboard = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
        List<String> filePaths = new ArrayList<>();

        if (clipboard == null || !clipboard.hasPrimaryClip()) {
            return filePaths;
        }

        ClipData clipData = clipboard.getPrimaryClip();
        if (clipData == null) {
            return filePaths;
        }

        for (int i = 0; i < clipData.getItemCount(); i++) {
            ClipData.Item item = clipData.getItemAt(i);
            Uri uri = item.getUri();
            if (uri != null) {
                String filePath = saveImageToLocal(context, uri);
                if (filePath != null) {
                    filePaths.add(filePath);
                }
            }
        }
        return filePaths;
    }

    private static String saveImageToLocal(Context context, Uri uri) {
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(uri);
            if (inputStream == null) {
                return null;
            }

            File file = new File(context.getCacheDir(), "clipboard_image_" + System.currentTimeMillis() + ".png");
            FileOutputStream outputStream = new FileOutputStream(file);

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }

            inputStream.close();
            outputStream.close();

            return file.getAbsolutePath();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}