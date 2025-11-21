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
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';
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
                    const CommonTextWidget(
                      text: 'Hey Lava, you\u2019re glowing!',
                      textType: TextType.head,
                    ),
                    const CommonTextWidget(
                      text: 'Let\'s flow, drop a 30 second intro here',
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
                                  const Color(0x9BF5F3F2).withOpacity(0.95),
                                  const Color(0xAEF5F3F2).withOpacity(0.88),
                                  const Color(0xB0F5F3F2).withOpacity(0.00),
                                  const Color(0xAEA6A6A6).withOpacity(0.25),
                                  const Color(0xB8F5F3F2).withOpacity(0.00),
                                  const Color(0xABF5F3F2).withOpacity(0.68),
                                  const Color(0x9BF5F3F2).withOpacity(0.90),
                                ],
                                stops: const [0.00, 0.12, 0.22, 0.55, 0.70, 0.85, 1.00],
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
                                    ? const Center(
                                        child: Text(
                                          "The video is uploaded",
                                          style: CommonTextStyle.regular14w400,
                                        ),
                                      )
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
                    Get.to(() => IntroVideoViewScreen(
                          videoFile: _videoFile!,
                        ));
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
      if (_videoFile != null) {
        // generateThumbnail(_videoFile!.path.toString());
      }
      _isLoading = false;
    });
    _controller!.setLooping(true);
    _controller!.pause();
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

  /*  Future<void> generateThumbnail(String videoPath) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.PNG,
        maxHeight: 150,
        maxWidth: 150,
        quality: 75,
      );

      if (uint8list != null) {
        setState(() {
          _thumbnailData = uint8list;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/

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
        _thumbnail = null; // optional
      });
    } catch (e) {
      debugPrint("Error removing video: $e");
    }
  }
}
