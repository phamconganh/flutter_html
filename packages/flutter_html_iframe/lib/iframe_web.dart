import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/shims/dart_ui.dart' as ui;
import 'package:web/helpers.dart';

import 'package:webview_flutter/webview_flutter.dart';

class IframeWidget extends StatelessWidget {
  final NavigationDelegate? navigationDelegate;
  final ExtensionContext extensionContext;

  const IframeWidget({
    Key? key,
    required this.extensionContext,
    this.navigationDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attributes = extensionContext.attributes;
    final givenWidth = double.tryParse(attributes['width'] ?? "");
    final givenHeight = double.tryParse(attributes['height'] ?? "");

    final width = givenWidth ?? (givenHeight ?? 150) * 2;
    final height = givenHeight ?? (givenWidth ?? 300) / 2;

    final iframe = createElementTag('iframe')
      ..setAttribute('width', width.toString())
      ..setAttribute('height', height.toString())
      ..setAttribute('src', attributes['src'] ?? '')
      // ..width = width.toString()
      // ..height = height.toString()
      // ..src = attributes['src']
      ..style.border = 'none';
    final String createdViewId = _getRandString(10);
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => iframe);
    return SizedBox(
      width: width,
      height: height,
      child: CssBoxWidget(
        style: extensionContext.styledElement!.style,
        childIsReplaced: true,
        child: Directionality(
          textDirection: extensionContext.styledElement!.style.direction!,
          child: HtmlElementView(
            viewType: createdViewId,
          ),
        ),
      ),
    );
  }
}

String _getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
