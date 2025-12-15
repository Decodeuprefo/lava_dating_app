import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lava_dating_app/Common/constant/common_text_style.dart';
import 'package:lava_dating_app/Common/constant/custom_tools.dart';
import 'package:lava_dating_app/Common/constant/color_constants.dart';
import 'package:lava_dating_app/Common/widgets/custom_background.dart';

class MatchLikedScreen extends StatefulWidget {
  const MatchLikedScreen({super.key});

  @override
  State<MatchLikedScreen> createState() => _MatchLikedScreenState();
}

class _MatchLikedScreenState extends State<MatchLikedScreen> {
  String _selectedTab = "Liked";

  List<Map<String, dynamic>> _likedProfiles = [];
  final List<Map<String, dynamic>> _dislikedProfiles = [];
  final List<Map<String, dynamic>> _reallyLikedProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() {
    _likedProfiles = [
      {
        'name': 'Liam Johnson',
        'location': 'New York City',
        'imageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        'isAvailable': true,
      },
      {
        'name': 'Noah Smith',
        'location': 'Los Angeles, California',
        'imageUrl': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
        'isAvailable': true,
      },
      {
        'name': 'Oliver Brown',
        'location': 'Chicago, Illinois',
        'imageUrl': 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=400',
        'isAvailable': false,
      },
      {
        'name': 'Elijah Davis',
        'location': 'Houston, Texas',
        'imageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
        'isAvailable': true,
      },
      {
        'name': 'James Wilson',
        'location': 'Miami, Florida',
        'imageUrl': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400',
        'isAvailable': false,
      },
      {
        'name': 'Benjamin Miller',
        'location': 'Dallas, Texas',
        'imageUrl': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
        'isAvailable': false,
      },
    ];
  }

  List<Map<String, dynamic>> get _currentProfiles {
    switch (_selectedTab) {
      case "Liked":
        return _likedProfiles;
      case "Disliked":
        return _dislikedProfiles;
      case "Really Liked":
        return _reallyLikedProfiles;
      default:
        return _likedProfiles;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              heightSpace(20),
              _buildSegmentedControl(),
              Expanded(
                child: _buildProfileGrid(),
              ),
              heightSpace(90)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0x752A1F3A),
              border: Border.all(
                color: const Color(0x66A898B8),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSegment("Liked", 0),
                _buildSegment("Disliked", 1),
                _buildSegment("Really Liked", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(String label, int index) {
    final bool isSelected = _selectedTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: isSelected ? ColorConstants.lightOrange : Colors.transparent,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: CommonTextStyle.regular16w400,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileGrid() {
    final profiles = _currentProfiles;

    if (profiles.isEmpty) {
      return const Center(
        child: Text(
          "No profiles found",
          style: CommonTextStyle.regular18w500,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return _buildProfileCard(profiles[index]);
      },
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    final String name = profile['name'] ?? '';
    final String location = profile['location'] ?? '';
    final String? imageUrl = profile['imageUrl'];
    final bool isAvailable = profile['isAvailable'] ?? false;

    return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade900,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: ColorConstants.lightOrange,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade900,
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade900,
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                      ),

                // Bottom Gradient Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),

                // Availability Status (Top-Left)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      widthSpace(6),
                      Text(
                        isAvailable ? "Available" : "Not Available",
                        style: CommonTextStyle.regular12w400,
                      ),
                    ],
                  ),
                ),

                // Name and Location (Bottom-Left)
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: CommonTextStyle.bold15w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      heightSpace(4),
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/HomeSplash/location_pin_icon.png",
                            height: 14,
                            width: 14,
                          ),
                          widthSpace(5),
                          Expanded(
                            child: Text(
                              location,
                              style: CommonTextStyle.regular12w400,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
