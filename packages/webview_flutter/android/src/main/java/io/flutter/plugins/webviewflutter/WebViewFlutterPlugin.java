// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tencent.smtt.export.external.TbsCoreSettings;
import com.tencent.smtt.sdk.QbSdk;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Java platform implementation of the webview_flutter plugin.
 *
 * <p>Register this in an add to app scenario to gracefully handle activity and context changes.
 *
 * <p>Call {@link #registerWith(Registrar)} to use the stable {@code io.flutter.plugin.common}
 * package instead.
 */
public class WebViewFlutterPlugin implements FlutterPlugin, ActivityAware,
        MethodChannel.MethodCallHandler {
    private static final String CHANNEL_NAME = "webview_flutter_x5";
    private static Activity mActivity;
    private static WebViewFactory webViewFactory;
    private MethodChannel channel;

    private FlutterCookieManager flutterCookieManager;

    /**
     * Add an instance of this to {@link io.flutter.embedding.engine.plugins.PluginRegistry} to
     * register it.
     *
     * <p>THIS PLUGIN CODE PATH DEPENDS ON A NEWER VERSION OF FLUTTER THAN THE ONE DEFINED IN THE
     * PUBSPEC.YAML. Text input will fail on some Android devices unless this is used with at least
     * flutter/flutter@1d4d63ace1f801a022ea9ec737bf8c15395588b9. Use the V1 embedding with {@link
     * #registerWith(Registrar)} to use this plugin with older Flutter versions.
     *
     * <p>Registration should eventually be handled automatically by v2 of the
     * GeneratedPluginRegistrant. https://github.com/flutter/flutter/issues/42694
     */
    public WebViewFlutterPlugin() {
    }

    /**
     * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
     * package.
     *
     * <p>Calling this automatically initializes the plugin. However plugins initialized this way
     * won't react to changes in activity or context, unlike {@link CameraPlugin}.
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
        mActivity = registrar.activity();
        webViewFactory = new WebViewFactory(registrar.messenger(),
                registrar.view(), mActivity);
        registrar.addActivityResultListener(webViewFactory);
        registrar
                .platformViewRegistry()
                .registerViewFactory(
                        "plugins.flutter.io/webview",
                        webViewFactory);
        new FlutterCookieManager(registrar.messenger());
        final WebViewFlutterPlugin plugin = new WebViewFlutterPlugin();
        plugin.setupChannel(registrar.messenger(), registrar.context().getApplicationContext());
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        if (webViewFactory != null) {
            webViewFactory.setActivity(mActivity);
        }
        binding.addActivityResultListener(webViewFactory);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        mActivity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
        if (webViewFactory != null) {
            webViewFactory.setActivity(mActivity);
        }
    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
    }

    void initX5(Context context) {
        Log.i("X5_webView", "准备初始化");
//        TBS内核首次使用和加载时，ART虚拟机会将Dex文件转为Oat，该过程由系统底层触发且耗时较长，很容易引起anr问题，解决方法是使用TBS的 ”dex2oat优化方案“。
// 在调用TBS初始化、创建WebView之前进行如下配置
        HashMap map = new HashMap();
        map.put(TbsCoreSettings.TBS_SETTINGS_USE_SPEEDY_CLASSLOADER, true);
        map.put(TbsCoreSettings.TBS_SETTINGS_USE_DEXLOADER_SERVICE, true);
        QbSdk.initTbsSettings(map);

        QbSdk.PreInitCallback cb = new QbSdk.PreInitCallback() {
            @Override
            public void onViewInitFinished(boolean arg0) {
                //x5內核初始化完成的回调，为true表示x5内核加载成功，否则表示x5内核加载失败，会自动切换到系统内核。
                Log.i("X5_webView", "onViewInitFinished:" + arg0);
            }

            @Override
            public void onCoreInitFinished() {
                Log.i("X5_webView", "onCoreInitFinished");
            }
        };
        //x5内核初始化接口
        QbSdk.initX5Environment(context, cb);
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        BinaryMessenger messenger = binding.getBinaryMessenger();
        webViewFactory = new WebViewFactory(messenger,
                /*containerView=*/ null, mActivity);
        binding
                .getPlatformViewRegistry()
                .registerViewFactory(
                        "plugins.flutter.io/webview", webViewFactory);
        flutterCookieManager = new FlutterCookieManager(messenger);
        setupChannel(binding.getBinaryMessenger(),
                binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        mActivity = null;
        if (flutterCookieManager == null) {
            return;
        }

        flutterCookieManager.dispose();
        flutterCookieManager = null;
    }

    private void setupChannel(BinaryMessenger messenger, Context context) {
        channel = new MethodChannel(messenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "initX5":
                initX5(mActivity.getApplicationContext());
                result.success("");
                break;
            case "disableSensitiveApi":// 禁用隐私API的获取
                QbSdk.disableSensitiveApi();
                result.success("");
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
