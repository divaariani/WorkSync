import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'app_colors.dart';
import 'dashboard_page.dart';
import 'salary_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const DashboardPage(),
    AttendancePage(),
    const SalaryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        domeCircleColor: AppColors.greenOne,
        barColor: AppColors.greenFour,
        selectedIndex: _currentIndex,
        onTabChange: (clickedIndex) {
          setState(() {
            _currentIndex = clickedIndex;
          });
        },
        tabs: [
          MoltenTab(
            icon: const Icon(Icons.home, color: AppColors.greenFour)
          ),
          MoltenTab(
            icon: const Icon(Icons.calendar_today, color: AppColors.greenFour)
          ),
          MoltenTab(
            icon: const Icon(Icons.wallet, color: AppColors.greenFour)
          ),
          MoltenTab(
            icon: const Icon(Icons.person, color: AppColors.greenFour)
          ),
        ],
      ),
    );
  }
}

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Attendance Page'),
    );
  }
}
