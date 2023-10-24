import 'package:flutter/material.dart';
import 'app_colors.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
            child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 60),
          child: Column(children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppColors.mainBrown,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      'Attendance List',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 20)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/paidleave.png',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const Text('Off Work', style: TextStyle(color: AppColors.mainBrown, fontWeight: FontWeight.bold))
                  ]
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/overtime.png',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const Text('Overtime', style: TextStyle(color: AppColors.mainBrown, fontWeight: FontWeight.bold))
                  ]
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/onduty.png',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const Text('On Duty', style: TextStyle(color: AppColors.mainBrown, fontWeight: FontWeight.bold))
                  ]
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/leave.png',
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const Text('Leave', style: TextStyle(color: AppColors.mainBrown, fontWeight: FontWeight.bold))
                  ]
                ),
              ],
            ),
          ]),
        )));
  }
}
