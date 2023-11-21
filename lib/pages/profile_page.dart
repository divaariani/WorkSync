import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'welcome_page.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
          child: Column(
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PROFILE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.mainGreen,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage('assets/avatar.jpg'),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(SessionManager().namaUser ?? 'Unknown', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(SessionManager().deptFullName ?? 'Unknown', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                                  // );
                                },
                                child: Image.asset(
                                  'assets/edit.png',
                                  width: 24, 
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.grey,
                    child: Column(
                      children: [
                        buildRow('assets/department.png', 'Department', '${SessionManager().deptInisial ?? 'Unknown'} Department'),
                        buildDivider(),
                        buildRow('assets/attendance.png', 'Attendance', 'Performance: 80%'),
                        buildDivider(),
                        buildRow('assets/theme.png', 'Swicth Theme', 'Current: Light Mode'),
                        buildDivider(),
                        buildRow('assets/language.png', 'Language', 'Current: English'),
                        // buildDivider(),
                        // buildRow('assets/logout.png', 'Log Out', 'Log out from your account'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 25),
                    child: GestureDetector(
                      onTap: () {
                        SessionManager().logout();
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
                                color: AppColors.mainGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(String imagePath, String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.mainGrey,
            radius: 20,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundColor: AppColors.mainGrey,
                radius: 15,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text1, style: const TextStyle(color: AppColors.deepGreen, fontWeight: FontWeight.bold)),
              Text(text2, style: const TextStyle(color: AppColors.deepGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      height: 0.5,
      color: AppColors.deepGrey,
    );
  }
}
