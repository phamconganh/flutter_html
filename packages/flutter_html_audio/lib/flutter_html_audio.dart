library flutter_html_audio;

// import 'dart:math';

import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';
import 'package:html/dom.dart' as dom;
import 'dart:io';

/// [AudioHtmlExtension] adds support for the <audio> tag to the flutter_html
/// library.
class AudioHtmlExtension extends HtmlExtension {
  final AudioControllerCallback? audioControllerCallback;
  final OptionsTranslation? optionsTranslation;
  // final BoxConstraints? constraints;

  const AudioHtmlExtension({
    this.audioControllerCallback,
    this.optionsTranslation,
    // this.constraints,
  });

  @override
  Set<String> get supportedTags => {"audio"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
        child: AudioWidget(
      context: context,
      callback: audioControllerCallback,
      optionsTranslation: optionsTranslation,
      // constraints: constraints,
    ));
  }
}

typedef AudioControllerCallback = void Function(
    dom.Element?, ChewieAudioController, VideoPlayerController);

/// A widget used for rendering an audio player in the HTML tree
class AudioWidget extends StatefulWidget {
  final ExtensionContext context;
  final AudioControllerCallback? callback;
  final OptionsTranslation? optionsTranslation;
  final BoxConstraints? constraints;

  const AudioWidget({
    Key? key,
    required this.context,
    this.callback,
    this.optionsTranslation,
    this.constraints,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  ChewieAudioController? _chewieController;
  VideoPlayerController? _audioController;
  late final List<String?> sources;
  // double? _width;
  // double? _height;

  @override
  void initState() {
    final attributes = widget.context.attributes;
    final src = attributes['src'];
    sources = <String?>[
      if (src != null) src,
      ...ReplacedElement.parseMediaSources(widget.context.node.children),
    ];

    // final givenWidth = double.tryParse(attributes['width'] ?? "");
    // final givenHeight = double.tryParse(attributes['height'] ?? "");

    if (sources.isNotEmpty && sources.first != null) {
      final src = sources.first!;
      Uri? sourceUri = Uri.tryParse(src);
      if (sourceUri != null) {
        // final constraints = widget.constraints;
        // if (constraints != null) {
        //   _width = min(
        //       max(givenWidth ?? (givenHeight ?? 150) * 2, constraints.minWidth),
        //       constraints.maxWidth);
        //   _height = min(
        //       max(givenHeight ?? (givenWidth ?? 300) / 2,
        //           constraints.minHeight),
        //       constraints.maxHeight);
        // } else {
        //   _width = givenWidth ?? (givenHeight ?? 150) * 2;
        //   _height = givenHeight ?? (givenWidth ?? 300) / 2;
        // }
        switch (sourceUri.scheme) {
          case 'asset':
            _audioController = VideoPlayerController.asset(sourceUri.path);
            break;
          case 'file':
            _audioController =
                VideoPlayerController.file(File.fromUri(sourceUri));
            break;
          default:
            _audioController = VideoPlayerController.networkUrl(sourceUri);
            break;
        }
        _chewieController = ChewieAudioController(
          videoPlayerController: _audioController!,
          autoPlay: attributes['autoplay'] != null,
          looping: attributes['loop'] != null,
          showControls: attributes['controls'] != null,
          autoInitialize: true,
          optionsTranslation: widget.optionsTranslation,
        );
        widget.callback?.call(
          widget.context.element,
          _chewieController!,
          _audioController!,
        );
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext bContext) {
    if (sources.isEmpty || sources.first == null) {
      return const SizedBox(height: 0, width: 0);
    }

    return CssBoxWidget(
      style: widget.context.styledElement!.style,
      childIsReplaced: true,
      child: ChewieAudio(controller: _chewieController!),
    );
    // return AspectRatio(
    //   aspectRatio: _width! / _height!,
    //   child: ChewieAudio(
    //     controller: _chewieController!,
    //   ),
    // );
  }
}
