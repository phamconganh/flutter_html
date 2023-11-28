import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/src/anchor.dart';
import 'package:flutter_html/src/css_box_widget.dart';
import 'package:flutter_html/src/css_parser.dart';
import 'package:flutter_html/src/extension/html_extension.dart';
import 'package:flutter_html/src/style.dart';
import 'package:flutter_html/src/tree/styled_element.dart';
import 'package:html/dom.dart' as dom;

class StyledElementBuiltIn extends HtmlExtension {
  const StyledElementBuiltIn();

  @override
  Set<String> get supportedTags => {
        "a",
        "abbr",
        "acronym",
        "address",
        "b",
        "bdi",
        "bdo",
        "big",
        "cite",
        "code",
        "data",
        "del",
        "dfn",
        "em",
        "font",
        "i",
        "ins",
        "kbd",
        "mark",
        "q",
        "rt",
        "s",
        "samp",
        "small",
        "span",
        "strike",
        "strong",
        "sub",
        "sup",
        "time",
        "tt",
        "u",
        "var",
        "wbr",

        //BLOCK ELEMENTS
        "article",
        "aside",
        "blockquote",
        "body",
        "center",
        "dd",
        "div",
        "dl",
        "dt",
        "figcaption",
        "figure",
        "footer",
        "h1",
        "h2",
        "h3",
        "h4",
        "h5",
        "h6",
        "header",
        "hr",
        "html",
        "li",
        "main",
        "nav",
        "noscript",
        "ol",
        "p",
        "pre",
        "section",
        "summary",
        "ul",
      };

  @override
  StyledElement prepare(
      ExtensionContext context, List<StyledElement> children) {
    StyledElement styledElement = StyledElement(
      name: context.elementName,
      elementId: context.id,
      elementClasses: context.classes.toList(),
      node: context.node as dom.Element,
      children: children,
      style: Style(),
    );

    LinkedHashMap<String, String>? attributes;

    /// TODO: https://www.w3schools.com/jsref/ -> HTML Elements with Examples -> get other inline css property. (example: 'align' in 'div', 'p' )
    switch (context.elementName) {
      case "abbr":
      case "acronym":
        styledElement.style = Style(
          textDecoration: TextDecoration.underline,
          textDecorationStyle: TextDecorationStyle.dotted,
        );
        break;
      case "address":
        continue italics;
      case "article":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "aside":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      bold:
      case "b":
        styledElement.style = Style(
          fontWeight: FontWeight.bold,
        );
        break;
      case "bdo":
        attributes ??= context.attributes;
        TextDirection textDirection = ((attributes["dir"] ?? "ltr") == "rtl")
            ? TextDirection.rtl
            : TextDirection.ltr;
        styledElement.style = Style(
          direction: textDirection,
        );
        break;
      case "big":
        styledElement.style = Style(
          fontSize: FontSize.larger,
        );
        break;
      case "blockquote":
        styledElement.style = Style(
          margin: Margins.symmetric(horizontal: 40.0, vertical: 14.0),
          display: Display.block,
        );
        break;
      case "body":
        styledElement.style = Style(
          margin: Margins.all(8.0),
          display: Display.block,
        );
        break;
      case "center":
        styledElement.style = Style(
          alignment: Alignment.center,
          display: Display.block,
        );
        break;
      case "cite":
        continue italics;
      monospace:
      case "code":
        styledElement.style = Style(
          fontFamily: 'Monospace',
        );
        break;
      case "dd":
        styledElement.style = Style(
          margin: Margins.only(left: 40.0),
          display: Display.block,
        );
        break;
      strikeThrough:
      case "del":
        styledElement.style = Style(
          textDecoration: TextDecoration.lineThrough,
        );
        break;
      case "dfn":
        continue italics;
      case "div":
        attributes ??= context.attributes;
        styledElement.style = Style(
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "dl":
        styledElement.style = Style(
          margin: Margins.symmetric(vertical: 14.0),
          display: Display.block,
        );
        break;
      case "dt":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "em":
        continue italics;
      case "figcaption":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "figure":
        styledElement.style = Style(
          margin: Margins(
            top: Margin(1, Unit.em),
            bottom: Margin(1, Unit.em),
            left: Margin(40, Unit.px),
            right: Margin(40, Unit.px),
          ),
          display: Display.block,
        );
        break;
      case "footer":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "font":
        attributes ??= context.attributes;
        String? color = attributes['color'];
        String? size = attributes['size'];
        styledElement.style = Style(
          color: color != null
              ? color.startsWith("#")
                  ? ExpressionMapping.stringToColor(color)
                  : ExpressionMapping.namedColorToColor(color)
              : null,
          fontFamily: attributes['face']?.split(",").first,
          fontSize: size != null ? numberToFontSize(size) : null,
        );
        break;
      case "h1":
        attributes ??= context.attributes;
        styledElement.style = Style(
          fontSize: FontSize(2, Unit.em),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 0.67, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "h2":
        attributes ??= context.attributes;
        styledElement.style = Style(
          fontSize: FontSize(1.5, Unit.em),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 0.83, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "h3":
        attributes ??= context.attributes;
        styledElement.style = Style(
          fontSize: FontSize(1.17, Unit.em),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 1, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "h4":
        attributes ??= context.attributes;
        styledElement.style = Style(
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 1.33, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "h5":
        attributes ??= context.attributes;
        styledElement.style = Style(
          fontSize: FontSize(0.83, Unit.em),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 1.67, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "h6":
        attributes ??= context.attributes;
        styledElement.style = Style(
          fontSize: FontSize(0.67, Unit.em),
          fontWeight: FontWeight.bold,
          margin: Margins.symmetric(vertical: 2.33, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "header":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "hr":
        styledElement.style = Style(
          margin: Margins(
            top: Margin(0.5, Unit.em),
            bottom: Margin(0.5, Unit.em),
            left: Margin.auto(),
            right: Margin.auto(),
          ),
          border: Border.all(),
          display: Display.block,
        );
        break;
      case "html":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      italics:
      case "i":
        styledElement.style = Style(
          fontStyle: FontStyle.italic,
        );
        break;
      case "ins":
        continue underline;
      case "kbd":
        continue monospace;
      case "li":

        /// TODO: value
        styledElement.style = Style(
          display: Display.listItem,
        );
        break;
      case "main":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "mark":
        styledElement.style = Style(
          color: Colors.black,
          backgroundColor: Colors.yellow,
        );
        break;
      case "nav":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "noscript":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "ol":

        /// TODO: compact, reversed, start, type
        styledElement.style = Style(
          display: Display.block,
          listStyleType: ListStyleType.decimal,
          padding: HtmlPaddings.only(inlineStart: 40),
          margin: Margins(
            blockStart: Margin(1, Unit.em),
            blockEnd: Margin(1, Unit.em),
          ),
        );
        break;
      case "ul":

        /// TODO: compact, type
        styledElement.style = Style(
          display: Display.block,
          listStyleType: ListStyleType.disc,
          padding: HtmlPaddings.only(inlineStart: 40),
          margin: Margins(
            blockStart: Margin(1, Unit.em),
            blockEnd: Margin(1, Unit.em),
          ),
        );
        break;
      case "p":
        attributes ??= context.attributes;
        styledElement.style = Style(
          margin: Margins.symmetric(vertical: 1, unit: Unit.em),
          display: Display.block,
          alignment: attributes.containsKey('align')
              ? ExpressionMapping.alignmentFromString(attributes['align'])
              : null,
        );
        break;
      case "pre":
        styledElement.style = Style(
          fontFamily: 'monospace',
          margin: Margins.symmetric(vertical: 14.0),
          whiteSpace: WhiteSpace.pre,
          display: Display.block,
        );
        break;
      case "q":
        styledElement.style = Style(
          before: "\"",
          after: "\"",
        );
        break;
      case "s":
        continue strikeThrough;
      case "samp":
        continue monospace;
      case "section":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "small":
        styledElement.style = Style(
          fontSize: FontSize.smaller,
        );
        break;
      case "strike":
        continue strikeThrough;
      case "strong":
        continue bold;
      case "sub":
        styledElement.style = Style(
          fontSize: FontSize.smaller,
          verticalAlign: VerticalAlign.sub,
        );
        break;
      case "summary":
        styledElement.style = Style(
          display: Display.block,
        );
        break;
      case "sup":
        styledElement.style = Style(
          fontSize: FontSize.smaller,
          verticalAlign: VerticalAlign.sup,
        );
        break;
      case "tt":
        continue monospace;
      underline:
      case "u":
        styledElement.style = Style(
          textDecoration: TextDecoration.underline,
        );
        break;
      case "var":
        continue italics;
    }

    return styledElement;
  }

  @override
  InlineSpan build(ExtensionContext context) {
    final styledElement = context.styledElement!;

    if (styledElement.style.display == Display.listItem ||
        ((styledElement.style.display == Display.block ||
                styledElement.style.display == Display.inlineBlock) &&
            (styledElement.children.isNotEmpty ||
                context.elementName == "hr"))) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: CssBoxWidget.withInlineSpanChildren(
          key: AnchorKey.of(context.parser.key, context.styledElement),
          style: styledElement.style,
          shrinkWrap: context.parser.shrinkWrap,
          childIsReplaced:
              ["iframe", "img", "video", "audio"].contains(styledElement.name),
          children: context.builtChildrenMap!.entries
              .expandIndexed((i, child) => [
                    child.value,
                    if (context.parser.shrinkWrap &&
                        i != styledElement.children.length - 1 &&
                        (child.key.style.display == Display.block ||
                            child.key.style.display == Display.listItem) &&
                        child.key.element?.localName != "html" &&
                        child.key.element?.localName != "body")
                      const TextSpan(text: "\n", style: TextStyle(fontSize: 0)),
                  ])
              .toList(),
        ),
      );
    }

    return TextSpan(
      style: styledElement.style.generateTextStyle(),
      children: context.builtChildrenMap!.entries
          .expandIndexed((index, child) => [
                child.value,
                if (context.parser.shrinkWrap &&
                    child.key.style.display == Display.block &&
                    index != styledElement.children.length - 1 &&
                    child.key.element?.parent?.localName != "th" &&
                    child.key.element?.parent?.localName != "td" &&
                    child.key.element?.localName != "html" &&
                    child.key.element?.localName != "body")
                  const TextSpan(text: "\n", style: TextStyle(fontSize: 0)),
              ])
          .toList(),
    );
  }
}
