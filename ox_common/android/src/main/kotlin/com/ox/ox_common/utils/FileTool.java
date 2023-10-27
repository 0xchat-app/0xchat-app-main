package com.ox.ox_common.utils;

import android.content.ContentUris;
import android.content.Context;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;


import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;


public class FileTool {

    private static final String TAG = "FileUtils";
    private static boolean isSaveSucc;

    private FileTool() {
        throw new Error("￣﹏￣");
    }

    /**
     * SEPARATOR .
     */
    public final static String FILE_EXTENSION_SEPARATOR = ".";

    /**
     * "/"
     */
    public final static String SEP = File.separator;


    public static String getFileSavedDir(Context context, String dirName) {
        String dir = null;
        if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
                || !Environment.isExternalStorageRemovable()) {

            dir = context.getExternalFilesDir(dirName).getAbsolutePath();
        }else {
            dir = context.getFilesDir().getAbsolutePath()+dirName;
        }
        return dir;
    }

    /**
     * Read the content of a file.
     * <br>
     * Default UTF-8 encoding.
     *
     * @param filePath File path
     * @return String content
     * @throws IOException
     */
    public static String readFile(String filePath) throws IOException {
        return readFile(filePath, "utf-8");
    }

    /**
     * Read the content of a file.
     *
     * @param filePath    File path
     * @param charsetName Character encoding
     * @return String content
     */
    public static String readFile(String filePath, String charsetName)
            throws IOException {
        if (TextUtils.isEmpty(filePath))
            return null;
        if (TextUtils.isEmpty(charsetName))
            charsetName = "utf-8";
        File file = new File(filePath);
        StringBuilder fileContent = new StringBuilder("");
        if (file == null || !file.isFile())
            return null;
        BufferedReader reader = null;
        try {
            InputStreamReader is = new InputStreamReader(new FileInputStream(
                    file), charsetName);
            reader = new BufferedReader(is);
            String line = null;
            while ((line = reader.readLine()) != null) {
                if (!fileContent.toString().equals("")) {
                    fileContent.append("\r\n");
                }
                fileContent.append(line);
            }
            return fileContent.toString();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Read a text file into a List of strings.
     * Default character encoding is UTF-8.
     *
     * @param filePath File path
     * @return Returns null if the file doesn't exist, otherwise returns a List of strings.
     * @throws IOException
     */
    public static List<String> readFileToList(String filePath)
            throws IOException {
        return readFileToList(filePath, "utf-8");
    }

    /**
     * Read a text file into a List of string.
     *
     * @param filePath    File path
     * @param charsetName Character encoding
     * @return Returns null if the file doesn't exist, otherwise returns a List of strings.
     */
    public static List<String> readFileToList(String filePath,
                                              String charsetName) throws IOException {
        if (TextUtils.isEmpty(filePath))
            return null;
        if (TextUtils.isEmpty(charsetName))
            charsetName = "utf-8";
        File file = new File(filePath);
        List<String> fileContent = new ArrayList<String>();
        if (file == null || !file.isFile()) {
            return null;
        }
        BufferedReader reader = null;
        try {
            InputStreamReader is = new InputStreamReader(new FileInputStream(
                    file), charsetName);
            reader = new BufferedReader(is);
            String line = null;
            while ((line = reader.readLine()) != null) {
                fileContent.add(line);
            }
            return fileContent;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Write data to a file.
     *
     * @param filePath File path
     * @param content  Content to write
     * @param append   If true, data will be written to the end of the file, instead of the beginning
     * @return Returns true if writing is successful, false otherwise
     */
    public static boolean writeFile(String filePath, String content,
                                    boolean append) throws IOException {
        if (TextUtils.isEmpty(filePath))
            return false;
        if (TextUtils.isEmpty(content))
            return false;
        FileWriter fileWriter = null;
        try {
            createFile(filePath);
            fileWriter = new FileWriter(filePath, append);
            fileWriter.write(content);
            fileWriter.flush();
            return true;
        } finally {
            if (fileWriter != null) {
                try {
                    fileWriter.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


    /**
     * Write data to a file.
     * By default, the data is written from the beginning of the file.
     *
     * @param filePath File path
     * @param stream   Byte input stream
     * @return Returns true if writing is successful, false otherwise
     * @throws IOException
     */
    public static boolean writeFile(String filePath, InputStream stream)
            throws IOException {
        return writeFile(filePath, stream, false);
    }

    /**
     * Write data to a file.
     *
     * @param filePath File path
     * @param stream   Byte input stream
     * @param append   If true, the data will be written to the end of the file;
     *                 If false, the original data will be cleared, and writing will start from the beginning
     * @return Returns true if writing is successful, false otherwise
     * @throws IOException
     */
    public static boolean writeFile(String filePath, InputStream stream,
                                    boolean append) throws IOException {
        if (TextUtils.isEmpty(filePath))
            throw new NullPointerException("filePath is Empty");
        if (stream == null)
            throw new NullPointerException("InputStream is null");
        return writeFile(new File(filePath), stream,
                append);
    }

    /**
     * Write data to a file.
     * By default, the data is rewritten at the beginning of the file.
     *
     * @param file   Specified file
     * @param stream Byte input stream
     * @return Returns true if writing is successful, false otherwise
     * @throws IOException
     */
    public static boolean writeFile(File file, InputStream stream)
            throws IOException {
        return writeFile(file, stream, false);
    }

    /**
     * Write data to a file.
     *
     * @param file   Specified file
     * @param stream Byte input stream
     * @param append If true, rewrite the data at the beginning of the file;
     *               if false, clear the original data and start writing from the beginning
     * @return Returns true if writing is successful, false otherwise
     * @throws IOException
     */
    public static boolean writeFile(File file, InputStream stream,
                                    boolean append) throws IOException {
        if (file == null)
            throw new NullPointerException("file = null");
        OutputStream out = null;
        try {
            createFile(file.getAbsolutePath());
            out = new FileOutputStream(file, append);
            byte data[] = new byte[1024];
            int length = -1;
            while ((length = stream.read(data)) != -1) {
                out.write(data, 0, length);
            }
            out.flush();
            return true;
        } finally {
            if (out != null) {
                try {
                    out.close();
                    stream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Copy a file.
     *
     * @param sourceFilePath Source file path (the file to be copied)
     * @param destFilePath   Destination file path (the directory for the copied file)
     * @return Returns true if copying the file is successful, false otherwise
     * @throws IOException
     */
    public static boolean copyFile(String sourceFilePath, String destFilePath)
            throws IOException {
        InputStream inputStream = null;
        inputStream = new FileInputStream(sourceFilePath);
        return writeFile(destFilePath, inputStream);
    }


    /**
     * Get the names of files in a specific directory.
     *
     * @param dirPath    Directory path
     * @param fileFilter File filter
     * @return Names of all files in a specific directory
     */
    public static List<String> getFileNameList(String dirPath,
                                               FilenameFilter fileFilter) {
        if (fileFilter == null)
            return getFileNameList(dirPath);
        if (TextUtils.isEmpty(dirPath))
            return Collections.emptyList();
        File dir = new File(dirPath);

        File[] files = dir.listFiles(fileFilter);
        if (files == null)
            return Collections.emptyList();

        List<String> conList = new ArrayList<String>();
        for (File file : files) {
            if (file.isFile())
                conList.add(file.getName());
        }
        return conList;
    }

    /**
     * Get the names of files in a specific directory.
     *
     * @param dirPath Directory path
     * @return Names of all files in a specific directory
     */
    public static List<String> getFileNameList(String dirPath) {
        if (TextUtils.isEmpty(dirPath))
            return Collections.emptyList();
        File dir = new File(dirPath);
        File[] files = dir.listFiles();
        if (files == null)
            return Collections.emptyList();
        List<String> conList = new ArrayList<String>();
        for (File file : files) {
            if (file.isFile())
                conList.add(file.getName());
        }
        return conList;
    }

    public static List<String> getFileNameList(String dirPath,
                                               final String extension) {
        if (TextUtils.isEmpty(dirPath))
            return Collections.emptyList();
        File dir = new File(dirPath);
        File[] files = dir.listFiles(new FilenameFilter() {

            @Override
            public boolean accept(File dir, String filename) {
                if (filename.indexOf("." + extension) > 0)
                    return true;
                return false;
            }
        });
        if (files == null)
            return Collections.emptyList();
        List<String> conList = new ArrayList<String>();
        for (File file : files) {
            if (file.isFile())
                conList.add(file.getName());
        }
        return conList;
    }

    public static String getFileExtension(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return filePath;
        }
        int extenPosi = filePath.lastIndexOf(FILE_EXTENSION_SEPARATOR);
        int filePosi = filePath.lastIndexOf(File.separator);
        if (extenPosi == -1) {
            return "";
        }
        return (filePosi >= extenPosi) ? "" : filePath.substring(extenPosi + 1);
    }

    public static boolean createFile(String path) {
        if (TextUtils.isEmpty(path))
            return false;
        return createFile(new File(path));
    }

    public static boolean createFile(File file) {
        if (file == null || !makeDirs(getFolderName(file.getAbsolutePath())))
            return false;
        if (!file.exists())
            try {
                return file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        return false;
    }

    public static boolean makeDirs(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return false;
        }
        File folder = new File(filePath);
        return (folder.exists() && folder.isDirectory()) ? true : folder
                .mkdirs();
    }

    public static boolean makeDirs(File dir) {
        if (dir == null)
            return false;
        return (dir.exists() && dir.isDirectory()) ? true : dir.mkdirs();
    }

    public static boolean isFileExist(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return false;
        }
        File file = new File(filePath);
        return (file.exists() && file.isFile());
    }

    public static String getFileNameWithoutExtension(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return filePath;
        }
        int extenPosi = filePath.lastIndexOf(FILE_EXTENSION_SEPARATOR);
        int filePosi = filePath.lastIndexOf(File.separator);
        if (filePosi == -1) {
            return (extenPosi == -1 ? filePath : filePath.substring(0,
                    extenPosi));
        }
        if (extenPosi == -1) {
            return filePath.substring(filePosi + 1);
        }
        return (filePosi < extenPosi ? filePath.substring(filePosi + 1,
                extenPosi) : filePath.substring(filePosi + 1));
    }

    public static String getFileName(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return filePath;
        }
        int filePosi = filePath.lastIndexOf(File.separator);
        return (filePosi == -1) ? filePath : filePath.substring(filePosi + 1);
    }

    public static String getFolderName(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return filePath;
        }
        int filePosi = filePath.lastIndexOf(File.separator);
        return (filePosi == -1) ? "" : filePath.substring(0, filePosi);
    }

    public static boolean isFolderExist(String directoryPath) {
        if (TextUtils.isEmpty(directoryPath)) {
            return false;
        }
        File dire = new File(directoryPath);
        return (dire.exists() && dire.isDirectory());
    }

    public static boolean deleteFile(String path) {
        if (TextUtils.isEmpty(path)) {
            return false;
        }
        return deleteFile(new File(path));
    }

    public static boolean deleteFile(File file) {
        if (file == null)
            throw new NullPointerException("file is null");
        if (!file.exists()) {
            return true;
        }
        if (file.isFile()) {
            return file.delete();
        }
        if (!file.isDirectory()) {
            return false;
        }

        File[] files = file.listFiles();
        if (files == null)
            return true;
        for (File f : files) {
            if (f.isFile()) {
                f.delete();
            } else if (f.isDirectory()) {
                deleteFile(f.getAbsolutePath());
            }
        }
        return file.delete();
    }

    public static void delete(String dir, FilenameFilter filter) {
        if (TextUtils.isEmpty(dir))
            return;
        File file = new File(dir);
        if (!file.exists())
            return;
        if (file.isFile())
            file.delete();
        if (!file.isDirectory())
            return;

        File[] lists = null;
        if (filter != null)
            lists = file.listFiles(filter);
        else
            lists = file.listFiles();

        if (lists == null)
            return;
        for (File f : lists) {
            if (f.isFile()) {
                f.delete();
            }
        }
    }

    public static long getFileSize(String path) {
        if (TextUtils.isEmpty(path)) {
            return -1;
        }
        File file = new File(path);
        return (file.exists() && file.isFile() ? file.length() : -1);
    }

    public static String get4Assets(Context context, String fileName, String... params) {
        AssetManager manager = context.getResources().getAssets();
        try {
            InputStream inputStream = manager.open(fileName);
            InputStreamReader isr = new InputStreamReader(inputStream,
                    params.length > 0 ? params[0] : "UTF-8");
            BufferedReader br = new BufferedReader(isr);
            StringBuilder sb = new StringBuilder();
            String length;
            while ((length = br.readLine()) != null) {
                sb.append(length + "\n");
            }
            br.close();
            isr.close();
            inputStream.close();

            return sb.toString();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }

    public static File getSDdir(Context context, String newDir) {
        String dir = "";
        if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
                || !Environment.isExternalStorageRemovable()) {

            dir = context.getExternalFilesDir("").getAbsolutePath();
        }else {
            dir = context.getFilesDir().getAbsolutePath();
        }
        String dirPath = dir + File.separator + newDir + File.separator;
        final File resultFile = new File(dirPath);
        if (!resultFile.exists()) {
            resultFile.mkdirs();
        }
        return resultFile;
    }

    public static String getPath(Context context,String fileName) {
        String dir = "";
        if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())
                || !Environment.isExternalStorageRemovable()) {

            dir = context.getExternalFilesDir("").getAbsolutePath();
        }else {
            dir = context.getFilesDir().getAbsolutePath();
        }
        String dirPath = dir + File.separator + fileName ;

        return dirPath;
    }

    public List<String> getFiledName(Object o) {
        Field[] fields = o.getClass().getDeclaredFields();
        List<String> fieldNames = new ArrayList<String>();
        for (int i = 0; i < fields.length; i++) {
            fieldNames.add(fields[i].getName());
            // fields[i].getType();
        }

        return fieldNames;
    }

    public Object getFieldValueByName(String fieldName, Object o) {
        try {
            String firstLetter = fieldName.substring(0, 1).toUpperCase(Locale.CHINA);
            String getter = "get" + firstLetter + fieldName.substring(1);
            Method method = o.getClass().getMethod(getter, new Class[]{});
            Object value = method.invoke(o, new Object[]{});
            return value;
        } catch (Exception e) {
            return null;
        }
    }

    public static boolean saveBitmap(Bitmap bitmap, File f) {
        if (f.exists()) {
            f.delete();
        }
        try {
            FileOutputStream out = new FileOutputStream(f);
            isSaveSucc = bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
            out.flush();
            out.close();
        } catch (Exception e) { 
            Log.e("ox_debug", e.getMessage());
        }
        return isSaveSucc;
    }

    public static boolean saveBitmap(Bitmap bitmap, File f, Bitmap.CompressFormat format, int quality) {
        try {
            FileOutputStream out = new FileOutputStream(f);
            isSaveSucc = bitmap.compress(format, quality, out);
            out.flush();
            out.close();
        } catch (Exception e) {
            Log.e("ox_debug", e.getMessage());
        }
        return isSaveSucc;
    }

    public static void copyFile2(String oldPath, String newPath) {
        try {
            int bytesum = 0;
            int byteread = 0;
            File oldfile = new File(oldPath);
            if (oldfile.exists()) {
                InputStream inStream = new FileInputStream(oldPath);
                FileOutputStream fs = new FileOutputStream(newPath);
                byte[] buffer = new byte[14440];
                while ((byteread = inStream.read(buffer)) != -1) {
                    bytesum += byteread;
                    fs.write(buffer, 0, byteread);
                }
                inStream.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void deleteFileByFile(File file) {
        if (file.exists()) {
            if (file.isFile()) {
                file.delete();
            } else if (file.isDirectory()) {
                File files[] = file.listFiles();
                for (int i = 0; i < files.length; i++) {
                    deleteFileByFile(files[i]);
                }
            }
            file.delete();
        }
    }

    public static long getFileSize(File f) {
        long size = 0;
        File flist[] = f.listFiles();
        if (flist != null) {
            for (int i = 0; i < flist.length; i++) {
                if (flist[i].isDirectory()) {
                    size = size + getFileSize(flist[i]);
                } else {
                    size = size + flist[i].length();
                }
            }
        }
        return size;
    }

    public static String readFromAssets(Context context, String fileName, String... params) {
        String content = "";
        try {
            InputStream is = context.getAssets().open(fileName);
            content = AnalysisInputStream(is, params.length > 0 ? params[0] : "UTF-8");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
//        content = content.replace(",", "\n");
        return content;
    }

    private static String AnalysisInputStream(InputStream iso, String... params) throws Exception {
        InputStreamReader ireader = new InputStreamReader(iso, params.length > 0 ? params[0] : "UTF-8");
        BufferedReader bd = new BufferedReader(ireader);
        StringBuffer sbr = new StringBuffer("");
        String str;
        while ((str = bd.readLine()) != null) {
            sbr.append(str);
            sbr.append(",");
            //sbr.append("\n");
        }
        return sbr.toString();
    }

    public static void writeFile(Context context, String fileName, String content) {
        File file = new File(getPath(context, fileName));
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        if (TextUtils.isEmpty(content)) {
            return;
        }
        OutputStream out = null;
        try {
            out = new FileOutputStream(file);
            out.write(content.getBytes());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void writeFile(Context context, String fileName, byte[] data) {
        File file = new File(getPath(context, fileName));
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                Log.e("yl_debug", e.getMessage());
            }
        }
        if (data == null) {
            return;
        }
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            fos.write(data, 0, data.length);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void save(Context context, String fileName, String content) {
        FileOutputStream outStream = null;
        try {
            outStream = context.openFileOutput(fileName, Context.MODE_PRIVATE);
            outStream.write(content.getBytes());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (outStream != null)
                    outStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    public static String read(Context context, String filename) {
//        if (!checkFileExist(filename))
//            return "";
        FileInputStream inStream = null;
        ByteArrayOutputStream outStream = null;
//        LogUtils.i(context+"---------------------------"+filename);
        try {
            inStream = context.openFileInput(filename);
            outStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int len = 0;
            while ((len = inStream.read(buffer)) != -1)
                outStream.write(buffer, 0, len);
            byte[] data = outStream.toByteArray();
            return new String(data);
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        } finally {
            try {
                if (inStream != null)
                    inStream.close();
                if (outStream != null)
                    outStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void saveAppend(Context context, String filename, String content) {
        FileOutputStream outStream = null;
        try {
            outStream = context.openFileOutput(filename, Context.MODE_APPEND);
            outStream.write(content.getBytes());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (outStream != null)
                    outStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void checkDirectory(File file) {
        if (file == null)
            return;
        if (!file.getParentFile().exists())
            checkDirectory(file.getParentFile());
        file.mkdir();
    }

    public static boolean checkFileExist(String path) {
        if (path == null || path.isEmpty())
            return true;
        File file = new File(path);
        return file.exists();
    }

    public static boolean hasSdcard() {
        return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
    }

    public static List<File> getDirFiles(String path) {
//        String path = "/data/data/com.integrated.edu.kpad/files";
        File file = new File(path);
        File[] files = file.listFiles();
        List<File> filesList = Arrays.asList(files);
        return filesList;
    }

    public static List<String> clrFileSuffix(List<File> files, String suffixName){
        List<String> lists = new ArrayList<>();
        for(File file : files){
            Log.i("Path: ",file.getName()+"==="+file.getAbsolutePath());
            if (!TextUtils.isEmpty(file.getName())) {
//                int indexOf = file.getName().indexOf(".txt");
                int indexOf = file.getName().indexOf(suffixName);
                if (indexOf > -1)
                    lists.add(file.getName().substring(0, indexOf));
                else
                 ;
            }
        }
        return lists;
    }

    public static String getPath(final Context context, final Uri uri) {
        final boolean isKitKat = Build.VERSION.SDK_INT >= 19;//Build.VERSION_CODES.KITKAT;

        Class documentsContractClass = ReflectHelper.getClass("android.provider.DocumentsContract");
        // DocumentProvider
        if (isKitKat && documentsContractClass != null && (
                ((Boolean) (ReflectHelper.invokeMethod(
                        documentsContractClass
                        , documentsContractClass, "isDocumentUri"
                        , new Class[]{Context.class, Uri.class}
                        , new Object[]{context, uri}))).booleanValue()
        )
        ) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId =
                        getDocumentId_DocumentsContract_SDK19(documentsContractClass, uri);
                final String[] split = docId.split(":");
                final String type = split[0];

                if ("primary".equalsIgnoreCase(type)) {
                    return getFileSavedDir(context, split[1]);
                }
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {
                final String id =
                        getDocumentId_DocumentsContract_SDK19(documentsContractClass, uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));

                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId =
                        getDocumentId_DocumentsContract_SDK19(documentsContractClass, uri);
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
                final String[] selectionArgs = new String[]{split[1]};

                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }

        return null;
    }

    private static String getDocumentId_DocumentsContract_SDK19(Class documentsContractClass, Uri uri) {
        return (String) ReflectHelper.invokeMethod(
                documentsContractClass
                , documentsContractClass, "getDocumentId"
                , new Class[]{Uri.class}
                , new Object[]{uri});
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
     */
    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {column};

        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs, null);
            if (cursor != null && cursor.moveToFirst()) {
                final int column_index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(column_index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }

    public static String uri2File(Context context, Uri uri) {
        String img_path = null;
        try {
            img_path = getPath(context, uri);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
        return img_path;
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is ExternalStorageProvider.
     */
    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is DownloadsProvider.
     */
    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    /**
     * @param uri The Uri to check.
     * @return Whether the Uri authority is MediaProvider.
     */
    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    public static void autoClear(String dirPath, final int autoClearDay) {
        FileTool.delete(dirPath, new FilenameFilter() {

            @Override
            public boolean accept(File file, String filename) {
                String s = getFileNameWithoutExtension(filename);
                int day = autoClearDay < 0 ? autoClearDay : -1 * autoClearDay;
                String date = DateUtils.getOtherDay(day);
                if (s.contains("Screenshot_")) {
                    s = s.substring(s.indexOf("_") + 1, s.indexOf("-"));
                    String ss = DateUtils.dateSimpleFormat(DateUtils.getOtherFormat(day), DateUtils.SHORT_DATE_FORMAT);
                    return ss.compareTo(s) >= 0;
                }
                if (FormatUtil.isNumeric(s)) {
                    String newStr = DateUtils.getNormalDateString(Long.valueOf(s));
                    return date.compareTo(newStr) >= 0;
                } else
                    return false;
            }
        });
    }

}