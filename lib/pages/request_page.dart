import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'requestlist_page.dart';
import 'ondutyform_page.dart';
import 'overtimeform_page.dart';
import 'offworkform_page.dart';
import 'leaveform_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.white,
      ),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
          child: Column(
            children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(AppLocalizations(globalLanguage).translate("request"),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                InkWell(
                  child: 
                    Text(AppLocalizations(globalLanguage).translate("seeAll"),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.deepGreen,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 3)
                        ]
                      )
                    ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RequestListPage(),
                      ),
                    );
                  },
                ),
              ]
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const OnDutyFormPage()),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                color: AppColors.mainGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/onduty.png', width: 50, height: 50),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations(globalLanguage).translate("onDuty"),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations(globalLanguage)
                                .translate("activitiesDesc"),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const OvertimeFormPage()),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                color: AppColors.mainGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/overtime.png',
                              width: 50, height: 50),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations(globalLanguage).translate("overtime"),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations(globalLanguage).translate("activitiesDesc"),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const OffWorkFormPage()),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                color: AppColors.mainGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/paidleave.png', width: 50, height: 50),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations(globalLanguage).translate("offWork"),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations(globalLanguage).translate("activitiesDesc"),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LeaveFormPage()),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.zero,
                color: AppColors.mainGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/leave.png', width: 50, height: 50),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations(globalLanguage).translate("leave"),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations(globalLanguage).translate("activitiesDesc"),
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        )
      )
    ]);
  }
}
