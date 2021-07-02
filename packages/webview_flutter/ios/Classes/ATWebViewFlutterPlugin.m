// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ATWebViewFlutterPlugin.h"
#import "ATCookieManager.h"
#import "FlutterWebView.h"

@implementation ATWebViewFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  ATWebViewFactory* webviewFactory =
      [[ATWebViewFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:webviewFactory withId:@"plugins.flutter.io.x/webview"];
  [ATCookieManager registerWithRegistrar:registrar];
}

@end
