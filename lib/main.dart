// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sprintf/sprintf.dart';
import 'package:barcode_scan/barcode_scan.dart';
void main() => runApp(MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final LocalAuthentication auth = LocalAuthentication();
  @override
  Widget build(BuildContext context) {
    //_captureController.pause();
    return Scaffold(
      extendBody: true,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return WebView(
                initialUrl: 'https://tobi.oetiker.ch/HelloPatient/',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                javascriptChannels: <JavascriptChannel>[
                  _appChannelJavascriptChannel(context),
                  _alertChannelJavascriptChannel(context),
                ].toSet(),
                gestureNavigationEnabled: true,
              );
            }
          ),
          //QRCaptureView(controller: _captureController),
        ]
      )
    );
  }
  JavascriptChannel _alertChannelJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Alert',
      onMessageReceived: (JavascriptMessage message) async {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(message.message),
        ));
      }
    );
  }

  JavascriptChannel _appChannelJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'AppChannel',
        onMessageReceived: (JavascriptMessage message) async {
          var controller = await _controller.future;
          //_captureController.pause();
          Map<String, dynamic> req;
          try {
              req = jsonDecode(message.message);
          } on FormatException catch (e) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(e.message),
              ));
          }
          switch(req['method']) {
            case 'auth': {
              var authenticated = false;
              try {
                authenticated = await auth.authenticateWithBiometrics(
                  localizedReason: 'Scan your fingerprint to authenticate',
                  useErrorDialogs: true,
                  stickyAuth: true
                );
                controller.evaluateJavascript(sprintf(req['cb'],[authenticated]));
              } on PlatformException catch (e) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(e.message),
                ));
              }
            }
            break;
            case 'scan': {
              var options = ScanOptions(
                autoEnableFlash: true
              );
              var result = await BarcodeScanner.scan(options: options);
              controller.evaluateJavascript(sprintf(req['cb'],[result.rawContent]));
            }
            break;
            default: {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Unknown Method ${req['method']}"),
              ));
            }
            break;
          }
        }
    );
  }
}
