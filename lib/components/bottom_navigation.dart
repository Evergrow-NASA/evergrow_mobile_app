import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/moisture_icon.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  selectedIndex == 0 ? Colors.white : Colors.white54,
                  BlendMode.srcIn,
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications, size: 28),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}