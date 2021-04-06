import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter_x5/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Webview demp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title = ''});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () {
                WebviewFlutterX5.initX5();
              },
              child: Container(
                width: 100.0,
                height: 45.0,
                color: Colors.blue[200],
                alignment: Alignment.center,
                child: Text(
                  'X5初始化',
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('X5内核加载状态'),
                    ),
                    body: SafeArea(child: WebviewPage('http://soft.imtt.qq.com/browser/tes/feedback.html')),
                  );
                }));
              },
              child: Container(
                width: 100.0,
                height: 45.0,
                color: Colors.blue[200],
                alignment: Alignment.center,
                child: Text(
                  'X5内核加载状态',
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('x5内核加载测试'),
                    ),
                    body: SafeArea(child: WebviewPage('http://debugtbs.qq.com/')),
                  );
                }));
              },
              child: Container(
                width: 100.0,
                height: 45.0,
                color: Colors.blue[200],
                alignment: Alignment.center,
                child: Text(
                  'x5内核加载测试',
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            GestureDetector(
              onTap: () async {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                }
                String url2 = 'https://www.baidu.com/';
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('测试'),
                    ),
                    body: SafeArea(child: WebviewPage(url2)),
                  );
                }));
              },
              child: Container(
                width: 100.0,
                height: 45.0,
                color: Colors.blue[200],
                alignment: Alignment.center,
                child: Text(
                  '测试',
                ),
              ),
            ),
            TextField(
              // horizonMargin: 0.0,
              // placeHolderString: '请输入兑换码',
              focusNode: _focusNode,
              // onChanged: _inputChange,
              // controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}

class WebviewPage extends StatefulWidget {
  WebviewPage(this.url);

  final String url;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final Completer<WebViewController> _completer = Completer<WebViewController>();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: widget.url,
          onWebViewCreated: _completer.complete,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) {
            print('web view page test: start url:$url');
          },
          onPageFinished: (url) {
            print('web view page test: finish url:$url');
            setState(() {
              loading = false;
            });
          },
          navigationDelegate: (request) {
            print('web view page test: url:${widget.url}');
            if (request.url.startsWith('http://')) {
              request.url.replaceFirst('http://', 'https://');
            }
            print('web view page test: url:${widget.url}');
            return NavigationDecision.navigate;
          },
        ),
        loading ? Center(child: CircularProgressIndicator()) : Container(),
      ],
    );
  }
}
