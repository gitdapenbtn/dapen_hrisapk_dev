import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/on_will_pop_exit.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/screens/attendance/attendance_screen.dart';
import 'package:dpbtn_absen/screens/home/home_screen.dart';
import 'package:dpbtn_absen/screens/setting/setting_screen.dart';
import 'package:unicons/unicons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const AttendanceScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScopeExit(
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 20,
          selectedItemColor: LayoutColor.textPrimary,
          unselectedItemColor: LayoutColor.textSecondary,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(UniconsLine.home_alt),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(UniconsLine.calendar_alt),
              label: 'Absensi',
            ),
            BottomNavigationBarItem(
              icon: Icon(UniconsLine.setting),
              label: 'Lainnya',
            ),
          ],
        ),
      ),
    );
  }
}
