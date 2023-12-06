import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'approvals_page.dart';
import 'overtimelist_page.dart';
import 'leave_list_page.dart';
import 'checkpoint_page.dart';
import 'refresh_page.dart';
import 'ticketing_page.dart';
import 'monitoringcheckpoint_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../controllers/overtime_controller.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({Key? key}) : super(key: key);

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  late OvertimeController overtimeController;

  @override
  void initState() {
    super.initState();
    overtimeController = OvertimeController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppLocalizations(globalLanguage).translate("features"),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/attendancefeature.png',
                  title: AppLocalizations(globalLanguage).translate("attendanceForm"),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RefreshAttendance(),
                        ),
                      );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/overtime.png',
                  title: AppLocalizations(globalLanguage).translate("overtime"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OvertimeListPage()),
                    );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/leave.png',
                  title: AppLocalizations(globalLanguage).translate("leave"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LeaveListPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder<List<OvertimeData>>(
                  future: overtimeController.futureData,
                  builder: (context, snapshot) {
                    int overtimeCount = snapshot.hasData ? snapshot.data!.length : 0;

                    return CardItem(
                      color: AppColors.mainGreen,
                      imagePath: 'assets/approval.png',
                      title: AppLocalizations(globalLanguage).translate("approvals"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovalsPage(),
                          ),
                        );
                      },
                      notificationCount: overtimeCount,
                    );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/checkpoint.png',
                  title: AppLocalizations(globalLanguage).translate("checkpoinTour"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckPointPage(
                         result: '', resultCheckpoint: globalBarcodeCheckpointResults
                      )),
                    );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/ticketing.png',
                  title: AppLocalizations(globalLanguage).translate("ticketing"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TicketingPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/monitoring.png',
                  title: AppLocalizations(globalLanguage).translate("Monitoring"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MonitoringCpPage()),
                    );
                  },
                ),
              ],
            ),
          ]),
        ))
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final double imageWidth;
  final double imageHeight;
  final int notificationCount; 
  final VoidCallback onTap;

  CardItem({
    required this.color,
    required this.imagePath,
    this.title = '',
    this.imageWidth = 70,
    this.imageHeight = 70,
    this.notificationCount = 0, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter, 
            children: [
              Container(
                width: 0.27 * MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Container(
                    width: imageWidth,
                    height: imageHeight,
                    child: Image.asset(imagePath),
                  ),
                ),
              ),
              if (notificationCount > 0) 
                Positioned(
                  top: 0,
                  right: 0, 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFBC5757), 
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }
}
