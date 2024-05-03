import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'login_page.dart';
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
    } else {
      language = '-';
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
                        borderRadius: BorderRadius.circular(16),
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: AppColors.grey,
                        child: FutureBuilder<List<AttendanceData>>(
                          future: controller.futureData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(color: AppColors.mainGreen); 
                            } else if (snapshot.hasError) {
                              return Text(AppLocalizations(globalLanguage).translate("noDataa"),);
                            } else {
                              List<AttendanceData> data = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRow('assets/department.png', AppLocalizations(globalLanguage).translate("department"),
                                    '${SessionManager().getDeptInisial()} Department'),
                                  buildDivider(),
                                  buildRow('assets/attendance.png', AppLocalizations(globalLanguage).translate("attendanceTitle"),
                                    '${AppLocalizations(globalLanguage).translate("performance")}: ${controller.calculatePerformance(data)}'), 
                                  buildDivider(),
                                  Padding(
                                    padding: const EdgeInsets.all(20), 
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: AppColors.mainGrey,
                                          radius: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              backgroundColor: AppColors.mainGrey,
                                              radius: 15,
                                              backgroundImage: AssetImage('assets/theme.png'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(AppLocalizations(globalLanguage).translate("switchTheme"), style: const TextStyle(color: AppColors.deepGreen, fontWeight: FontWeight.bold)),
                                            Text('${AppLocalizations(globalLanguage).translate("current")}: ${globalTheme == "Light Theme" ? AppLocalizations(globalLanguage).translate("lightTheme") : AppLocalizations(globalLanguage).translate("darkTheme")}', style: const TextStyle(color: AppColors.deepGrey)),
                                          ],
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (globalTheme == 'Light Theme') {
                                                globalTheme = 'Dark Theme';
                                                SessionManager().setTheme(globalTheme);
                                              } else {
                                                globalTheme = 'Light Theme';
                                                SessionManager().setTheme(globalTheme);
                                              }
                                            });
                                            
                                          },
                                          child: Image.asset(globalTheme == 'Light Theme' ? 'assets/mode_light.png' : 'assets/mode_dark.png', height: 30),
                                        ),
                                      ],
                                    )
                                  ),
                                  buildDivider(),
                                  buildRow('assets/language.png', AppLocalizations(globalLanguage).translate("language"),
                                    '${AppLocalizations(globalLanguage).translate("current")}: $language'),
                                ],
                              );
                            }
                          },
                        )
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.white, AppColors.lightGreen],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.mainGrey, 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), 
                                ),
                                content: Text(AppLocalizations(globalLanguage).translate("sureLogOut")),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); 
                                    },
                                    child: Text(AppLocalizations(globalLanguage).translate("cancel"), 
                                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      SessionManager().logout();
                                      SessionManager().setTheme(const Locale('en', 'US').toString());
                                      Navigator.push(
                                        context,
                                          MaterialPageRoute(
                                            builder: (context) => const LoginPage()
                                          )
                                      );
                                    },
                                    child: Text(AppLocalizations(globalLanguage).translate("yes"), 
                                      style: const TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                            child: Text(
                              AppLocalizations(globalLanguage).translate("logout"),
                              style: const TextStyle(
                                color: AppColors.deepGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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