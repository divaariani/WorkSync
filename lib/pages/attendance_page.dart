import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'attendancecorrect_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../controllers/attendance_controller.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late AttendanceController controller;

  @override
  void initState() {
    super.initState();
    controller = AttendanceController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations(globalLanguage).translate("attendanceList"),
          style: const TextStyle(
            color: AppColors.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<AttendanceData>>(
        future: controller.futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildAttendanceList(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget buildAttendanceList(List<AttendanceData> data) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.deepGreen, AppColors.lightGreen],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  buildAttendanceCard(data[index]),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          left: 100,
          right: 100,
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
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AttendanceCorrectionPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppLocalizations(globalLanguage).translate("addCorrection"),
                style: const TextStyle(
                  color: AppColors.deepGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAttendanceCard(AttendanceData data) {
    bool hasTimeData = data.jamMasuk != null && data.jamPulang != null;

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
                Text(data.tglAbsen),
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
}
