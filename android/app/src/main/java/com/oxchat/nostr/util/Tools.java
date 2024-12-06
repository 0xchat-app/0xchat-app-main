package com.oxchat.nostr.util;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.OpenableColumns;
import android.util.Log;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Objects;

/**
 * Title: Tools
 * Description: Created on 2023-12-04
 * Copyright: Copyright (c) 2023
 *
 * @author Michael
 * @since JDK1.8
 */
public class Tools {

    public static File copyToCache(Context context, Uri uri, String fileName) throws IOException {
        File cacheFile = new File(context.getCacheDir(), fileName);
        try (InputStream input = context.getContentResolver().openInputStream(uri);
             OutputStream output = new FileOutputStream(cacheFile)) {
            if (input != null) {
                byte[] buffer = new byte[1024];
                int length;
                while ((length = input.read(buffer)) > 0) {
                    output.write(buffer, 0, length);
                }
            }
        }
        return cacheFile;
    }

    public static String getFileName(Context context, Uri uri) {
        String result = null;
        if ("content".equals(uri.getScheme())) {
            Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);
            if (cursor != null) {
                try {
                    if (cursor.moveToFirst()) {
                        int index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                        if (index != -1) {
                            result = cursor.getString(index);
                        }
                    }
                } finally {
                    cursor.close();
                }
            }
        }
        return result != null ? result : "shared_file_" + System.currentTimeMillis();
    }
}