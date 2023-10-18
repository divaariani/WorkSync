import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
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
    const SalaryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        domeCircleColor: const Color(0xFFFFFFF7),
        barColor: const Color(0xFFA3A397),
        selectedIndex: _currentIndex,
        onTabChange: (clickedIndex) {
          setState(() {
            _currentIndex = clickedIndex;
          });
        },
        tabs: [
          MoltenTab(
            icon: const Icon(Icons.home,
                color: Color.fromARGB(255, 118, 118, 92)),
          ),
          MoltenTab(
            icon: const Icon(Icons.wallet,
                color: Color.fromARGB(255, 118, 118, 92)),
          ),
          MoltenTab(
            icon: const Icon(Icons.person,
                color: Color.fromARGB(255, 118, 118, 92)),
          ),
        ],
      ),
    );
  }
}
