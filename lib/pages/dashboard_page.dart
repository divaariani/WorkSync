import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'facerecognition_page.dart';
import 'refresh_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../controllers/attendance_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AttendanceController controller;

  @override
  void initState() {
    super.initState();
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
            padding: const EdgeInsets.only(top: 70, bottom: 30, left: 30, right: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations(globalLanguage).translate("welcome"),
                          style: TextStyle(
                            fontSize: 14,
                            color: globalTheme == 'Light Theme' ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          SessionManager().getNamaUser() ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold,
                            color: globalTheme == 'Light Theme' ? AppColors.deepGreen : AppColors.lightGreen
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset('assets/avatar.jpg', width: 50, height: 50),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FaceRecognitionPage()));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.mainGreen,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Container(
                                width: 40,
                                height: 40,
                                child: Image.asset('assets/facerecognition.png'),
                              ),
                              const Spacer(),
                              Text(
                                AppLocalizations(globalLanguage).translate("scanAttendance"),
                                style: const TextStyle(
                                    color: AppColors.mainGreen,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer()
                            ],
                          ),
                          const SizedBox(height: 10)
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<AttendanceData>>(
                  future: controller.futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const RefreshHomepage();
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppColors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/checkin.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppLocalizations(globalLanguage).translate("checkIn"),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mainGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.getTodayIn(snapshot.data!), 
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                  Text(
                                    controller.getTodayState(snapshot.data!),
                                    //AppLocalizations(globalLanguage).translate("onTime"), 
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppColors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/checkout.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        AppLocalizations(globalLanguage).translate("checkOut"),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.mainGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.getTodayOut(snapshot.data!), 
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                  Text(
                                    controller.getTodayState(snapshot.data!),
                                    //AppLocalizations(globalLanguage).translate("onTime"), // GANTI DENGAN statusAbsen TANGGAL HARI INI
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.mainGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations(globalLanguage).translate("attendance"), 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: globalTheme == 'Light Theme' ? Colors.black : Colors.white
                    )
                  ),
                  const Spacer(),
                  InkWell(
                    child: Text(
                      AppLocalizations(globalLanguage).translate("seeAll"), 
                      style: TextStyle(
                        fontSize: 12, 
                        color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white, 
                        shadows: const [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3)]
                      )
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RefreshAttendanceList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              FutureBuilder<List<AttendanceData>>(
                future: controller.futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('No data');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No data available');
                    }

                    int itemCount = snapshot.data!.length > 5 ? 5 : snapshot.data!.length;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            buildAttendanceCard(snapshot.data![index]),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildAttendanceCard(AttendanceData data) {
    bool hasTimeData = data.jamMasuk != null || data.jamPulang != null;
    

    Color cardColor = hasTimeData ? AppColors.mainGreen : const Color(0xFFBC5757);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Card(
          color: AppColors.grey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(formatLanguageDate(data.tglAbsen)),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Image.asset("assets/checkin.png", width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(data.jamMasuk ?? 'N/A⠀'),
                    const Spacer(),
                    Image.asset("assets/checkout.png", width: 24, height: 24),
                    const SizedBox(width: 10),
                    Text(data.jamPulang ?? 'N/A⠀'),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatLanguageDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag()).format(dateTime);
    return formattedDate;
  }
}
