import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'app_colors.dart';
import 'dashboard_page.dart';
import 'attendance_page.dart';
import 'salary_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardPage(),
    const AttendancePage(),
    const SalaryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        domeCircleColor: Colors.white,
        barColor: AppColors.deepGreen,
        selectedIndex: _currentIndex,
        onTabChange: (clickedIndex) {
          setState(() {
            _currentIndex = clickedIndex;
          });
        },
        tabs: [
          MoltenTab(icon: const Icon(Icons.home, color: AppColors.mainGreen)),
          MoltenTab(icon: const Icon(Icons.calendar_today, color: AppColors.mainGreen)),
          MoltenTab(icon: const Icon(Icons.wallet, color: AppColors.mainGreen)),
          MoltenTab(icon: const Icon(Icons.person, color: AppColors.mainGreen)),
        ],
      ),
    );
  }
}
