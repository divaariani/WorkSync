import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'app_colors.dart';
import '../utils/globals.dart';

class AttendanceFormPage extends StatefulWidget {
  const AttendanceFormPage({Key? key}) : super(key: key);

  @override
  State<AttendanceFormPage> createState() => _AttendanceFormPageState();
}

class _AttendanceFormPageState extends State<AttendanceFormPage> {
  String selectedType = 'Check In';
  String inOrOut = '';
  String imageAsset = '';

  @override
  Widget build(BuildContext context) {
    if (selectedType == 'Check Out') {
      inOrOut = 'Out';
    } else {
      inOrOut = 'In';
    }

    if (selectedType == 'Check Out') {
      imageAsset = 'assets/out.png';
    } else {
      imageAsset = 'assets/in.png';
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Attendance Form',
            style: TextStyle(
                color: AppColors.deepGreen, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Attendance For',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/useradd.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Username',
                              style: TextStyle(color: AppColors.deepGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/map.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                globalLocationName,
                                style: const TextStyle(color: AppColors.deepGreen),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: WebView(
                          initialUrl:
                              'https://www.google.com/maps/search/?api=1&query=$globalLat,$globalLong',
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Attendance Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: Row(
                          children: [
                            Image.asset('assets/attendancetype.png',
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedType,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedType = newValue;
                                  });
                                }
                              },
                              items: <String>['Check In', 'Check Out']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: AppColors.deepGreen)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$inOrOut Time',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset(imageAsset, height: 24, width: 24),
                            const SizedBox(width: 10),
                            const Text(
                              '17:04',
                              style: TextStyle(color: AppColors.deepGreen),
                            ),
                            const Text(
                              " (You're on time)",
                              style: TextStyle(
                                  color: AppColors.deepGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                        child: Text(
                          inOrOut,
                          style: const TextStyle(
                              color: AppColors.deepGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ],
        )
      );
  }
}
