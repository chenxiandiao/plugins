package io.flutter.plugins.x5webviewflutter;


import io.flutter.plugins.x5webviewflutter.model.PermissionDataInfo;

public interface IPermissionCallback {
    void onNeedPermission(PermissionDataInfo data);
}
