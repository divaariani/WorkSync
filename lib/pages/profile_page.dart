import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'welcome_page.dart';
import 'editprofile_page.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../utils/session_manager.dart';
import '../controllers/attendance_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AttendanceController controller;
  late String language;

  @override
  void initState() {
    super.initState();

    if (globalLanguage == const Locale('en', 'US')) {
      language = 'English';
    } else if (globalLanguage == const Locale('id', 'ID')) {
      language = 'Bahasa Indonesia';
    } else if (globalLanguage == const Locale('ko', 'KR')) {
      language = '한국';
    } else {
      language = '';
    }

    controller = AttendanceController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations(globalLanguage).translate("profile"), 
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: globalTheme == 'Light Theme' ? Colors.black : Colors.white
                      )
                    ),
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        SessionManager().getNamaUser() ?? 'Unknown',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 14,
                                        children: [
                                          Text(
                                            SessionManager().getDeptFullName() ?? 'Unknown',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Colors.white)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const EditProfilePage()),
                                    );
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
                        child: FutureBuilder<List<AttendanceData>>(
                          future: controller.futureData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); 
                            } else if (snapshot.hasError) {
                              return Text('No Connection');
                            } else {
                              List<AttendanceData> data = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRow('assets/department.png', AppLocalizations(globalLanguage).translate("department"),
                                    '${SessionManager().getDeptInisial()} Department'),
                                  buildDivider(),
                                  buildRow( 'assets/attendance.png', AppLocalizations(globalLanguage).translate("attendanceForm"),
                                    '${AppLocalizations(globalLanguage).translate("performance")}: ${controller.calculatePerformance(data)}'),
                                  buildDivider(),
                                  buildRow('assets/theme.png', AppLocalizations(globalLanguage).translate("switchTheme"),
                                    '${AppLocalizations(globalLanguage).translate("current")}: $globalTheme'),
                                  buildDivider(),
                                  buildRow('assets/language.png', AppLocalizations(globalLanguage).translate("language"),
                                    '${AppLocalizations(globalLanguage).translate("current")}: $language'),
                                ],
                              );
                            }
                          },
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 25),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.mainGrey, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20), 
                              ),
                              content: Text(AppLocalizations(globalLanguage).translate("Are you sure you want to Log Out?")),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); 
                                  },
                                  child: Text(AppLocalizations(globalLanguage).translate("Cancel"), 
                                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    SessionManager().logout();
                                    setState(() {
                                      globalLanguage = const Locale('en', 'US'); 
                                    });
                                    Navigator.push(
                                      context,
                                        MaterialPageRoute(
                                          builder: (context) => const WelcomePage()
                                        )
                                    );
                                  },
                                  child: Text(AppLocalizations(globalLanguage).translate("Yes"), 
                                    style: const TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
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
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations(globalLanguage).translate("logout"),
                              style: const TextStyle(
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
      ]
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
