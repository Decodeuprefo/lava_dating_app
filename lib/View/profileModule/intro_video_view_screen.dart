import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import 'about_me_screen.dart';

class IntroVideoViewScreen extends StatefulWidget {
  final File videoFile;

  const IntroVideoViewScreen({super.key, required this.videoFile});

  @override
  State<IntroVideoViewScreen> createState() => _IntroVideoViewScreenState();
}

class _IntroVideoViewScreenState extends State<IntroVideoViewScreen> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpace(13),
                    InkWell(
                      onTap: Get.back,
                      child: SvgPicture.asset(
                        "assets/icons/back_arrow.svg",
                        height: 30,
                        width: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                    heightSpace(90),
                    const CommonTextWidget(
                      text: 'VIBE CHECK! 🤙🏼',
                      textType: TextType.head,
                    ),
                    const CommonTextWidget(
                      text: 'Tell us more about you & what you’re looking for.',
                      textType: TextType.des,
                    ),
                    heightSpace(70),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return Container(
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            );
                          },
                        ),
                        Positioned.fill(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (_controller == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Video controller not available')),
                                  );
                                  return;
                                }
                                if (!_controller!.value.isInitialized) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Video is not yet initialized')),
                                  );
                                  return;
                                }

                                _controller!.play();
                                setState(() {});
                                Get.to(() => FullScreenVideoPlayer(controller: _controller!));
                              },
                              child: Image.asset(
                                "assets/icons/video_play_icon.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ).marginSymmetric(horizontal: 20),
              ),
              AppButton(
                text: "Continue",
                textStyle: CommonTextStyle.regular16w500,
                onPressed: () {
                  Get.to(() => const AboutMeScreen());
                },
              ).marginSymmetric(horizontal: 20, vertical: 20)
            ],
          ),
        ),
      ),
    );
  }
}

/// Fullscreen player screen — uses the existing VideoPlayerController (does NOT dispose it)
class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  ChewieController? _chewie;

  @override
  void initState() {
    super.initState();

    _chewie = ChewieController(
      videoPlayerController: widget.controller,
      autoPlay: true,
      looping: false,
      aspectRatio: 16 / 9,
      allowFullScreen: false,
      allowPlaybackSpeedChanging: false,
    );
  }

  @override
  void dispose() {
    _chewie?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _chewie != null
                    ? Chewie(controller: _chewie!)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () {
                  widget.controller.pause();
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
