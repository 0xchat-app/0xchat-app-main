package com.ox.ox_common.activitys;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import java.util.ArrayList;
import java.util.List;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.ox.ox_common.R;

@SuppressWarnings("all")
public abstract class BaseActivity extends AppCompatActivity {

    private int REQUEST_CODE_PERMISSION = 0x00001;

    public void requestPermission(String[] permissions, int requestCode) {
        this.REQUEST_CODE_PERMISSION = requestCode;
        if (checkPermissions(permissions)) {
            permissionSuccess(REQUEST_CODE_PERMISSION);
        } else {
            List<String> needPermissions = getDeniedPermissions(permissions);
            ActivityCompat.requestPermissions(this, needPermissions.toArray(new String[needPermissions.size()]), REQUEST_CODE_PERMISSION);
        }
    }

    private boolean checkPermissions(String[] permissions) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    private List<String> getDeniedPermissions(String[] permissions) {
        List<String> needRequestPermissionList = new ArrayList<>();
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) !=
                    PackageManager.PERMISSION_GRANTED ||
                    ActivityCompat.shouldShowRequestPermissionRationale(this, permission)) {
                needRequestPermissionList.add(permission);
            }
        }
        return needRequestPermissionList;
    }



    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_PERMISSION) {
            if (verifyPermissions(grantResults)) {
                permissionSuccess(REQUEST_CODE_PERMISSION);
            } else {
                for (int i = 0; i < permissions.length; i++) {
                    String permission = permissions[i];
                    if (!ActivityCompat.shouldShowRequestPermissionRationale(this, permission)){
//                        当用户设置不在询问，并且勾选拒绝权限后，显示提示对话框
                        permissonNecessity(REQUEST_CODE_PERMISSION);
                        return;
                    }
                }
                permissionFail(REQUEST_CODE_PERMISSION);
            }
        }
    }

    private boolean verifyPermissions(int[] grantResults) {
        for (int grantResult : grantResults) {
            if (grantResult != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    public void showSettingDialog(){
        showTipsDialog();
    }

    /**
     * When the user sets 'Don't ask again' and denies the permission, display a prompt dialog.
     */
    public void showTipsDialog() {
        new AlertDialog.Builder(this)
                .setTitle(getResources().getText(R.string.str_picker_image_tips))
                .setCancelable(false)
                .setMessage(getResources().getText(R.string.str_picker_image_lack_request_and_goto_settings))
                .setNegativeButton(getResources().getText(R.string.str_picker_image_cancel), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                        finish();
                    }
                })
                .setPositiveButton(getResources().getText(R.string.str_picker_image_confirm), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                        startAppSettings();
                        finish();
                    }
                }).show();
    }

    /**
     * Launch the current application Settings page
     */
    public void startAppSettings() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse("package:" + getPackageName()));
        startActivity(intent);
    }

    /**
     * Access permission successful subclass call
     *
     * @param requestCode
     */
    public void permissionSuccess(int requestCode) {

    }

    /**
     * Permission acquisition failed
     * @param requestCode
     */
    public void permissionFail(int requestCode) {
    }
    /**
     * After the necessary permissions fail to obtain (the subclass page can be rewritten to do the corresponding operation)
     */
    public void permissonNecessity(int requestCode){

    }

}
