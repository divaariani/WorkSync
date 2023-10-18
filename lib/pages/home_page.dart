import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'dashboard_page.dart';
// import 'wallet_page.dart';
// import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    DashboardPage(),
    SalaryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        domeCircleColor: const Color(0xFFFFFFF7),
        barColor: const Color(0xFFA3A397),
        borderColor: const Color(0xFFFFFF7),
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



class SalaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Salary Page'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page'),
    );
  }
}
