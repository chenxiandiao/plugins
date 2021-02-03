// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.view.View;

import com.tencent.smtt.sdk.ValueCallback;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

import static android.app.Activity.RESULT_OK;

public final class WebViewFactory extends PlatformViewFactory implements PluginRegistry.ActivityResultListener {
  private final BinaryMessenger messenger;
  private final View containerView;
  public ValueCallback<Uri> mUploadMessage;
  public ValueCallback<Uri[]> mUploadMessageArray;
  private Activity mActivity;
  public final int FILECHOOSER_RESULTCODE = 1;

  WebViewFactory(BinaryMessenger messenger, View containerView, Activity mActivity) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
    this.containerView = containerView;
    this.mActivity = mActivity;
  }

  @SuppressWarnings("unchecked")
  @Override
  public PlatformView create(Context context, int id, Object args) {
    Map<String, Object> params = (Map<String, Object>) args;
    return new FlutterWebView(context, messenger, id, params, containerView, this);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
    boolean handled = false;
    if (Build.VERSION.SDK_INT >= 21) {
      Uri[] results = null;
      // check result
      if (resultCode == RESULT_OK) {
        if (requestCode == FILECHOOSER_RESULTCODE) {
          if (mUploadMessageArray != null) {
            String dataString = intent.getDataString();
            if (dataString != null) {
              results = new Uri[]{Uri.parse(dataString)};
            }
          }
          handled = true;
        }
      }
      if (mUploadMessageArray != null) {
        mUploadMessageArray.onReceiveValue(results);
      }
      mUploadMessageArray = null;
    } else {
      if (requestCode == FILECHOOSER_RESULTCODE) {
        if (null != mUploadMessage) {
          Uri result = intent == null || resultCode != RESULT_OK ? null
                  : intent.getData();
          mUploadMessage.onReceiveValue(result);
          mUploadMessage = null;
        }
        handled = true;
      }
    }
    return handled;
  }

  public void setActivity(Activity mActivity){
    this.mActivity = mActivity;
  }

  public Activity getActivity(){
    return mActivity;
  }
}
