import 'package:flutter/material.dart';
import 'home_screen_splash.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenSplash(),
    const Center(child: Text('Tab 2')),
    const Center(child: Text('Tab 3')),
    const Center(child: Text('Tab 4')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/dashboard_back.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.black);
            },
          ),
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home, // Placeholder - user will replace with home icon
              isSelected: _selectedIndex == 0,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.search, // Placeholder - user will replace
              isSelected: _selectedIndex == 1,
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.favorite, // Placeholder - user will replace
              isSelected: _selectedIndex == 2,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.person, // Placeholder - user will replace
              isSelected: _selectedIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Round background when selected - white with orange tint
          color: isSelected
              ? const Color(0xffF33F02).withOpacity(0.1) // Light orange background
              : Colors.transparent,
          border: isSelected
              ? Border.all(
                  color: const Color(0xffF33F02).withOpacity(0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected
                ? const Color(0xffF33F02) // Orange color when selected
                : Colors.grey.withOpacity(0.6), // Grey when not selected
            size: 24,
          ),
        ),
      ),
    );
  }
}
