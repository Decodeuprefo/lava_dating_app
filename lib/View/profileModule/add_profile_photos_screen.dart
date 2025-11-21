import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/View/profileModule/intro_video_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Common/constant/common_text_style.dart';
import '../../Common/widgets/custom_background.dart';
import '../../Common/widgets/custom_button.dart';

class AddProfilePhotosScreen extends StatefulWidget {
  const AddProfilePhotosScreen({super.key});

  @override
  State<AddProfilePhotosScreen> createState() => _AddProfilePhotosScreenState();
}

class _AddProfilePhotosScreenState extends State<AddProfilePhotosScreen> {
  final List<File?> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final int _maxImages = 6;

  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted ||
          await Permission.mediaLibrary.isGranted) {
        return true;
      }

      PermissionStatus status;
      if (Platform.isAndroid && Platform.version.compareTo('33') >= 0) {
        // Android 13+ (API 33+)
        status = await Permission.photos.request();
      } else {
        // Android 12 and below
        status = await Permission.storage.request();
      }

      return status.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  Future<void> _pickImage() async {
    final hasPermission = await _requestPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. Please allow photo access.'),
        ),
      );
      return;
    }
    if (_selectedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum $_maxImages images allowed'),
          backgroundColor: Colors.deepOrange,
        ),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      text: 'Get your shine on, add your photos.',
                      textType: TextType.head,
                    ),
                    const CommonTextWidget(
                      text:
                          'Let’s add 1 to start. Profiles with more than 3 photos are more likely to match',
                      textType: TextType.des,
                    ),
                    heightSpace(50),
                    _selectedImages.isEmpty ? selectImagePlaceholder() : _buildGridView(),
                  ],
                ).marginSymmetric(horizontal: 20),
              ),
              AppButton(
                text: "Continue",
                textStyle: CommonTextStyle.regular16w500,
                onPressed: () {
                  Get.to(() => const IntroVideoScreen());
                },
              ).marginSymmetric(horizontal: 20, vertical: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        // removes side padding completely
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10, // spacing between columns
          mainAxisSpacing: 30, // spacing between rows
          childAspectRatio: 0.75,
        ),
        itemCount: _selectedImages.length < _maxImages
            ? _selectedImages.length + 1
            : _selectedImages.length,
        itemBuilder: (context, index) {
          if (index < _selectedImages.length) {
            return _buildImageCard(_selectedImages[index]!, index);
          } else {
            return _buildAddMoreCard();
          }
        },
      ),
    );
  }

  Widget _buildImageCard(File imageFile, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, // allows the icon to go outside the container
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              imageFile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: -20, // moved slightly lower to appear outside
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (image != null) {
                  setState(() {
                    _selectedImages[index] = File(image.path);
                  });
                }
              },
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/add_item.svg",
                  height: 36,
                  width: 36,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: () {
                _removeImage(index);
              },
              child: Image.asset(
                "assets/icons/close_icon.png",
                height: 18,
                width: 18,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none, // allow the add button to overflow
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GlassmorphicContainer(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
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
                        const Color(0xFFF5F3F2).withOpacity(0.95),
                        const Color(0xFFF5F3F2).withOpacity(0.88),
                        const Color(0xFFF5F3F2).withOpacity(0.00),
                        const Color(0xFFF5F3F2).withOpacity(0.25),
                        const Color(0xFFF5F3F2).withOpacity(0.00),
                        const Color(0xFFF5F3F2).withOpacity(0.68),
                        const Color(0xFFF5F3F2).withOpacity(0.90),
                      ],
                      stops: const [0.00, 0.12, 0.22, 0.55, 0.70, 0.85, 1.00],
                    ),
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
              Positioned(
                bottom: -15,
                child: InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(18),
                  child: SvgPicture.asset(
                    "assets/icons/add_item.svg",
                    height: 36,
                    width: 36,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget selectImagePlaceholder() {
    return Stack(
      clipBehavior: Clip.none, // allow the add button to overflow
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 114.0,
              height: 150.0,
              child: GlassmorphicContainer(
                width: 114.0,
                height: 150.0,
                borderRadius: 10.0,
                blur: 8.0,
                border: 0.8,
                alignment: Alignment.center,
                linearGradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x66BBA8A8), // semi-transparent mauve-ish
                    Color(0x55AFA0A0), // slightly different tone for depth
                  ],
                  stops: [0.0, 1.0],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFF5F3F2).withOpacity(0.95),
                    const Color(0xFFF5F3F2).withOpacity(0.88),
                    const Color(0xFFF5F3F2).withOpacity(0.00),
                    const Color(0xFFF5F3F2).withOpacity(0.25),
                    const Color(0xFFF5F3F2).withOpacity(0.00),
                    const Color(0xFFF5F3F2).withOpacity(0.68),
                    const Color(0xFFF5F3F2).withOpacity(0.90),
                  ],
                  stops: const [0.00, 0.12, 0.22, 0.55, 0.70, 0.85, 1.00],
                ),
                child: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: -15,
          child: InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(18),
            child: SvgPicture.asset(
              "assets/icons/add_item.svg",
              height: 36,
              width: 36,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

}
