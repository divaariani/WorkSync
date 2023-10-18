import 'package:flutter/material.dart';
import 'facerecognition_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFFFFFF7),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 70, bottom: 30, left: 30, right: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Welcome!'),
                        Text(
                          'Username',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset('assets/avatar.png',
                              width: 80, height: 80),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FaceRecognitionPage()));
                  },
                  child: Image.asset('assets/facerecognition.png'),
                ),
                const SizedBox(height: 40),
                const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('REQUEST', style: TextStyle(fontSize: 18)),
                ]),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0xFFE2E3D5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/request.png',
                                width: 50, height: 50),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF76745C)),
                            ),
                            Text(
                              'Tambahkan request anda',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF76745C)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Column(
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF76745C),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0xFFE2E3D5),
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lembur',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF76745C)),
                            ),
                            Text(
                              'Tambahkan lembur anda',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF76745C)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Column(
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF76745C),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0xFFE2E3D5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/paidleave.png',
                                width: 50, height: 50),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cuti',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF76745C)),
                            ),
                            Text(
                              'Tambahkan cuti anda',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF76745C)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Column(
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF76745C),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: const Color(0xFFE2E3D5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset('assets/sick.png',
                                width: 50, height: 50),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Izin',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF76745C)),
                            ),
                            Text(
                              'Tambahkan izin anda',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF76745C)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Column(
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF76745C),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      );
  }
}
