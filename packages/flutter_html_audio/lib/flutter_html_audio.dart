library flutter_html_audio;

import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';
import 'package:html/dom.dart' as dom;

/// [AudioHtmlExtension] adds support for the <audio> tag to the flutter_html
/// library.
class AudioHtmlExtension extends HtmlExtension {
  final AudioControllerCallback? audioControllerCallback;
  final OptionsTranslation? optionsTranslation;

  const AudioHtmlExtension({
    this.audioControllerCallback,
    this.optionsTranslation,
  });

  @override
  Set<String> get supportedTags => {"audio"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
        child: AudioWidget(
            context: context,
            callback: audioControllerCallback,
            optionsTranslation: optionsTranslation));
  }
}

typedef AudioControllerCallback = void Function(
    dom.Element?, ChewieAudioController, VideoPlayerController);

/// A widget used for rendering an audio player in the HTML tree
class AudioWidget extends StatefulWidget {
  final ExtensionContext context;
  final AudioControllerCallback? callback;
  final OptionsTranslation? optionsTranslation;

  const AudioWidget({
    Key? key,
    required this.context,
    this.callback,
    this.optionsTranslation,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  ChewieAudioController? chewieAudioController;
  VideoPlayerController? audioController;
  late final List<String?> sources;

  @override
  void initState() {
    final attributes = widget.context.attributes;
    final src = attributes['src'];
    sources = <String?>[
      if (src != null) src,
      ...ReplacedElement.parseMediaSources(widget.context.node.children),
    ];

    if (sources.isNotEmpty && sources.first != null) {
      final src = sources.first!;
      final uri = Uri.tryParse(src);
      if (uri != null) {
        audioController = VideoPlayerController.networkUrl(uri);
        chewieAudioController = ChewieAudioController(
          videoPlayerController: audioController!,
          autoPlay: attributes['autoplay'] != null,
          looping: attributes['loop'] != null,
          showControls: attributes['controls'] != null,
          autoInitialize: true,
          optionsTranslation: widget.optionsTranslation,
        );
        widget.callback?.call(
          widget.context.element,
          chewieAudioController!,
          audioController!,
        );
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    chewieAudioController?.dispose();
    audioController?.dispose();
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
      child: ChewieAudio(
        controller: chewieAudioController!,
      ),
    );
  }
}
