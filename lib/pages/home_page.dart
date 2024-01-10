import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'app_colors.dart';
import 'dashboard_page.dart';
import 'features_page.dart';
import 'profile_page.dart';
import '../utils/globals.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(initialIndex);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this._currentIndex);
  int _currentIndex = 0;
  DateTime? currentBackPressTime;

  final List<Widget> _tabs = [
    const DashboardPage(),
    const FeaturesPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit the app'),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: Container(
          color: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          child: MoltenBottomNavigationBar(
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
              MoltenTab(icon: const Icon(Icons.window, color: AppColors.mainGreen)),
              MoltenTab(icon: const Icon(Icons.person, color: AppColors.mainGreen)),
            ],
          ),
        ),
      ),
    );
  }
}
