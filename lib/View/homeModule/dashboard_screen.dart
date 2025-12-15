import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lava_dating_app/View/homeModule/home_screen_splash.dart';
import 'package:lava_dating_app/View/homeModule/swipe_screen.dart';
import 'package:lava_dating_app/View/homeModule/match_liked_screen.dart';
import 'package:lava_dating_app/View/myProfileModule/my_profile_screen.dart';

import '../chatModule/chat_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<String> _icons = [
    "assets/icons/dash_home.png",
    "assets/icons/dash_discovery.png",
    "assets/icons/dash_heart.png",
    "assets/icons/dash_message.png",
    "assets/icons/dash_user.png",
  ];

  final List<Widget> _screens = [
    const HomeScreenSplash(),
    const SwipeScreen(),
    const MatchLikedScreen(),
    const ChatListScreen(),
    const MyProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildGlassNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: isSelected
            ? BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.0,
                ),
              )
            : null, // No decoration if not selected
        child: Center(
          child: Image.asset(
            _icons[index],
            width: 32, // Adjust icon size
            height: 32,
            color: isSelected ? const Color(0xFFFF4500) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassNavigationBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.20),
                  Colors.white.withOpacity(0.17),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_icons.length, (index) {
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
