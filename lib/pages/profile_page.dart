import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'app_colors.dart';
import '../utils/globals.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final heightSize = 0.09 * MediaQuery.of(context).size.height;
    final widthSize = 0.35 * MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileCard(),
            SizedBox(height: heightSize),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.8,
                      valueColor: AlwaysStoppedAnimation(AppColors.mainGreen),
                      backgroundColor: AppColors.grey,
                      strokeWidth: 10,
                    ),
                  ),
                  const Column(children: [
                    Text(
                      '80%',
                      style: TextStyle(
                        color: AppColors.mainGreen,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Kehadiran',
                      style: TextStyle(
                        color: AppColors.mainGreen,
                        fontSize: 12,
                      ),
                    ),
                  ])
                ],
              ),
            ),
            SizedBox(height: heightSize),
            Container(
              margin: EdgeInsets.symmetric(horizontal: widthSize),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    globalLanguage = const Locale('en', ''); 
                  });
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage()
                      )
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, AppColors.lightGreen],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                          color: AppColors.deepGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: heightSize),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.mainGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 40, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), 
              ),
              child: Image.asset('assets/avatar.png'), 
            ),
            const SizedBox(height: 20),
            const Text(
              'Username',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Full Stack Mobile Developer',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            const Text(
              'IT Department',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
