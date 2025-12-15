import 'dart:io';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/constant/custom_tools.dart';
import '../../Common/constant/color_constants.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
import 'about_me_screen.dart';
import 'intro_video_view_screen.dart';

class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  static const Duration minAllowed = Duration(seconds: 30);
  File? _videoFile;
  File? _thumbnail;
  Uint8List? _thumbnailData;

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _thumbnailData = null;
    super.initState();
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
                    CommonTextWidget(
                      text: _chewieController != null
                          ? 'VIBE CHECK! 🤙🏼'
                          : 'Hey Lava, you\u2019re glowing!',
                      textType: TextType.head,
                    ),
                    CommonTextWidget(
                      text: _chewieController != null
                          ? 'Tell us more about you & what you’re looking for.'
                          : 'Let\'s flow, drop a 30 second intro here',
                      textType: TextType.des,
                    ),
                    heightSpace(70),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return GlassmorphicContainer(
                              width: constraints.maxWidth,
                              height: 200.0,
                              borderRadius: 10.0,
                              blur: 8.0,
                              border: 0.8,
                              alignment: Alignment.center,
                              linearGradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0x66BBA8A8),
                                  Color(0x55AFA0A0),
                                ],
                                stops: [0.0, 1.0],
                              ),
                              borderGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                  const Color.fromRGBO(255, 255, 255, 0.1).withOpacity(0.2),
                                ],
                                stops: const [0.0, 0.5, 1.0, 0.55, 0.70, 0.85, 1.00],
                              ),
                              child: const SizedBox.shrink(),
                            );
                          },
                        ),

                        /// Center Content
                        Positioned.fill(
                          child: Center(
                            child: !_isLoading
                                ? (_chewieController != null && _controller != null
                                    ? _buildVideoThumbnail()
                                    : InkWell(
                                        onTap: _pickFromGallery,
                                        child: SvgPicture.asset(
                                          "assets/icons/add_item.svg",
                                          height: 50,
                                          width: 50,
                                        ),
                                      ))
                                : const CircularProgressIndicator(),
                          ),
                        ),

                        /// Close Button
                        if (_chewieController != null && _controller != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: removeSelectedVideo,
                              child: Image.asset(
                                "assets/icons/close_icon.png",
                                height: 20,
                                width: 20,
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
                  setState(() {});
                  if (_chewieController != null && _controller != null && _videoFile != null) {
                    Get.to(() => const AboutMeScreen());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select first video')),
                    );
                  }
                },
              ).marginSymmetric(horizontal: 20, vertical: 20)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      setState(() => _isLoading = true);
      final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
      if (picked == null) {
        setState(() => _isLoading = false);
        return; // cancelled
      }
      await _handlePickedVideo(picked);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    } finally {
      if (mounted && !_isLoading) {}
    }
  }

  Future<void> _handlePickedVideo(XFile picked) async {
    final File file = File(picked.path);
    final VideoPlayerController vpc = VideoPlayerController.file(file);

    try {
      await vpc.initialize();
    } catch (e) {
      await vpc.dispose();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to read video: $e')),
      );
      return;
    }

    final Duration duration = vpc.value.duration;

    if (duration > minAllowed) {
      await vpc.dispose();
      _showWarning();
      _isLoading = false;
      setState(() {});
      return;
    }

    _chewieController?.dispose();
    _controller?.dispose();
    setState(() {
      _videoFile = file;
      _controller = vpc;
      _chewieController = ChewieController(
        videoPlayerController: vpc,
        autoPlay: false,
        looping: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: false,
      );
    });
    _controller!.setLooping(true);
    _controller!.pause();

    // Generate thumbnail after video is initialized
    if (_videoFile != null && _controller != null) {
      await _generateThumbnail();
    }

    setState(() {
      _isLoading = false;
    });
  }

  /*Future<File?> generateThumbnail(String videoPath) async {
    try {
      final String? thumbPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
        maxHeight: 200,
        quality: 80,
      );

      if (thumbPath != null) {
        return File(thumbPath);
      }
    } catch (e) {
      debugPrint("Thumbnail error: $e");
    }
    return null;
  }*/

  /*Future<void> generateThumbnail(String videoPath) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String outputPath = '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.png';

      final session = await FFmpegKit.execute(
          '-i "$videoPath" -ss 00:00:01 -vframes 1 -vf scale=200:200 "$outputPath"'
      );

      final ReturnCode? returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final File thumbFile = File(outputPath);
        if (thumbFile.existsSync()) {
          final bytes = await thumbFile.readAsBytes();
          setState(() {
            _thumbnailData = bytes;
          });
        }
      } else {
        print('FFmpeg error: ${returnCode?.getValue()}');
      }
    } catch (e) {
      print('Error generating thumbnail: $e');
    }
  }*/

  /*Future<void> generateThumbnail(String videoPath) async {
    try {
      // Extract first frame as thumbnail using Dart
      final File videoFile = File(videoPath);

      // For now, use a placeholder - you can show video duration or file info
      setState(() {
        _thumbnailData = null; // Will show placeholder
      });
    } catch (e) {
      print('Error: $e');
    }
  }*/

  Future<void> _generateThumbnail() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        return;
      }

      // Seek to first frame (0 seconds) to show thumbnail
      await _controller!.seekTo(Duration.zero);
      await Future.delayed(const Duration(milliseconds: 100));

      setState(() {
        // Thumbnail will be shown via VideoPlayer widget
      });
    } catch (e) {
      debugPrint("Error generating thumbnail: $e");
    }
  }

  Widget _buildVideoThumbnail() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _playVideo,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video thumbnail frame
            VideoPlayer(_controller!),
            // Dark overlay for better play button visibility
            Container(
              // color: Colors.black.withOpacity(0.2),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
            // Orange circular play button
            Center(
              child: Image.asset(
                "assets/icons/video_play_icon.png",
                height: 50,
                width: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playVideo() {
    if (_controller == null || !_controller!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video is not ready')),
      );
      return;
    }

    // Navigate to fullscreen video player
    Get.to(() => FullScreenVideoPlayer(controller: _controller!));
  }

  void _showWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'The minimum video length should be 30 seconds.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        // position from top
        dismissDirection: DismissDirection.startToEnd,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> removeSelectedVideo() async {
    try {
      if (_videoFile != null && await _videoFile!.exists()) {
        await _videoFile!.delete();
      }

      _chewieController?.dispose();
      _chewieController = null;

      _controller?.dispose();
      _controller = null;

      setState(() {
        _videoFile = null;
        _thumbnail = null;
        _thumbnailData = null;
      });
    } catch (e) {
      debugPrint("Error removing video: $e");
    }
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
