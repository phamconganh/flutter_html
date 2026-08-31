library;

import 'package:flutter_html/flutter_html.dart';

export 'src/builtins/details_element_builtin.dart';

import 'src/builtins/details_element_builtin.dart';

void registerAllBuiltIns() {
  HtmlParser.registerBuiltIns(const DetailsElementBuiltIn());
}

void unregisterAllBuiltIns() {
  HtmlParser.unregisterBuiltIns(const DetailsElementBuiltIn());
}