library flutter_html_video;

import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';
import 'package:html/dom.dart' as dom;
import 'dart:io';

/// [VideoHtmlExtension] adds support for the <video> tag to the flutter_html
/// library.
class VideoHtmlExtension extends HtmlExtension {
  final VideoControllerCallback? videoControllerCallback;
  final OptionsTranslation? optionsTranslation;
  final BoxConstraints? constraints;

  const VideoHtmlExtension({
    this.videoControllerCallback,
    this.optionsTranslation,
    this.constraints,
  });

  @override
  Set<String> get supportedTags => {"video"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
        child: VideoWidget(
      context: context,
      callback: videoControllerCallback,
      optionsTranslation: optionsTranslation,
    ));
  }
}

typedef VideoControllerCallback = void Function(
    dom.Element?, ChewieController, VideoPlayerController);

/// A VideoWidget for displaying within the HTML tree.
class VideoWidget extends StatefulWidget {
  final ExtensionContext context;
  final VideoControllerCallback? callback;
  final List<DeviceOrientation>? deviceOrientationsOnEnterFullScreen;
  final List<DeviceOrientation> deviceOrientationsAfterFullScreen;
  final OptionsTranslation? optionsTranslation;
  final BoxConstraints? constraints;

  const VideoWidget({
    Key? key,
    required this.context,
    this.callback,
    this.deviceOrientationsOnEnterFullScreen,
    this.deviceOrientationsAfterFullScreen = DeviceOrientation.values,
    this.optionsTranslation,
    this.constraints,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoController;
  late final List<String?> sources;
  double? _width;
  double? _height;

  @override
  void initState() {
    final attributes = widget.context.attributes;
    final src = attributes['src'];

    sources = <String?>[
      if (src != null) src,
      ...ReplacedElement.parseMediaSources(widget.context.node.children),
    ];

    final givenWidth = double.tryParse(attributes['width'] ?? "");
    final givenHeight = double.tryParse(attributes['height'] ?? "");

    if (sources.isNotEmpty && sources.first != null) {
      final src = sources.first!;
      Uri? sourceUri = Uri.tryParse(src);
      if (sourceUri != null) {
        final constraints = widget.constraints;
        if (constraints != null) {
          _width = min(
              max(givenWidth ?? (givenHeight ?? 150) * 2, constraints.minWidth),
              constraints.maxWidth);
          _height = min(
              max(givenHeight ?? (givenWidth ?? 300) / 2,
                  constraints.minHeight),
              constraints.maxHeight);
        } else {
          _width = givenWidth ?? (givenHeight ?? 150) * 2;
          _height = givenHeight ?? (givenWidth ?? 300) / 2;
        }
        switch (sourceUri.scheme) {
          case 'asset':
            _videoController = VideoPlayerController.asset(sourceUri.path);
            break;
          case 'file':
            _videoController =
                VideoPlayerController.file(File.fromUri(sourceUri));
            break;
          default:
            _videoController = VideoPlayerController.networkUrl(sourceUri);
            break;
        }
        final poster = attributes['poster'];
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          placeholder: poster != null && poster.isNotEmpty
              ? Image.network(poster)
              : Container(color: Colors.black),
          autoPlay: attributes['autoplay'] != null,
          looping: attributes['loop'] != null,
          showControls: attributes['controls'] != null,
          autoInitialize: true,
          aspectRatio:
              _width == null || _height == null ? null : _width! / _height!,
          deviceOrientationsOnEnterFullScreen:
              widget.deviceOrientationsOnEnterFullScreen,
          deviceOrientationsAfterFullScreen:
              widget.deviceOrientationsAfterFullScreen,
          optionsTranslation: widget.optionsTranslation,
        );
        widget.callback?.call(
          widget.context.element,
          _chewieController!,
          _videoController!,
        );
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext bContext) {
    if (_chewieController == null) {
      return const SizedBox(height: 0, width: 0);
    }

    return AspectRatio(
      aspectRatio: _width! / _height!,
      child: Chewie(
        controller: _chewieController!,
      ),
    );
  }
}
