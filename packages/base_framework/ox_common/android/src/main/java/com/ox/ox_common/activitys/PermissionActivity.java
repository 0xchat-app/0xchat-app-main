package com.ox.ox_common.activitys;

import android.os.Bundle;


public class PermissionActivity extends BaseActivity {

    public static final String PERMISSIONS = "PERMISSIONS";

    private final int CODE = 505;
    private String[] strings;

    @Override
    public void onCreate(Bundle savedInstanceState ) {
        super.onCreate(savedInstanceState);
        strings = getIntent().getStringArrayExtra(PERMISSIONS);
        requestPermission(strings,CODE);
    }

    @Override
    public void permissionFail(int requestCode) {
        super.permissionFail(requestCode);
        setResult(RESULT_CANCELED);
        finish();
    }

    @Override
    public void permissionSuccess(int requestCode) {
        super.permissionSuccess(requestCode);
        setResult(RESULT_OK,getIntent());
        finish();
    }

    @Override
    public void permissonNecessity(int requestCode) {
        super.permissonNecessity(requestCode);
        setResult(RESULT_CANCELED);
        finish();
//        showSettingDialog();
    }
}
