import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'requestform_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({Key? key}) : super(key: key);

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  String currentDate = "";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    currentDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("requestList"),
          style: const TextStyle(
            color: AppColors.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.deepGreen),
            onPressed: () {
              // Search functionality here
            },
          ),
        ],
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(currentDate, style: const TextStyle(color: AppColors.lightGreen)),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  AppLocalizations(globalLanguage).translate("approved"),
                                  style: const TextStyle(
                                    color: AppColors.deepGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ),
                        const SizedBox(height:10),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations(globalLanguage).translate("requestType"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(AppLocalizations(globalLanguage).translate("requestNo"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(AppLocalizations(globalLanguage).translate("from"), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(':'),
                                SizedBox(height: 5),
                                Text(':'),
                                SizedBox(height: 5),
                                Text(':'),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations(globalLanguage).translate("leave")),
                                const SizedBox(height: 5),
                                const Text('LV-2023'),
                                const SizedBox(height: 5),
                                Text('$currentDate - $currentDate'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height:10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text('Izin sakit pergi ke dokter', style: TextStyle(fontWeight: FontWeight.bold))
                          ]
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(currentDate, style: const TextStyle(color: AppColors.lightGreen)),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  AppLocalizations(globalLanguage).translate("approved"),
                                  style: const TextStyle(
                                    color: AppColors.deepGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ),
                        const SizedBox(height:10),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations(globalLanguage).translate("requestType"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(AppLocalizations(globalLanguage).translate("requestNo"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(AppLocalizations(globalLanguage).translate("from"), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(':'),
                                SizedBox(height: 5),
                                Text(':'),
                                SizedBox(height: 5),
                                Text(':'),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations(globalLanguage).translate("leave")),
                                const SizedBox(height: 5),
                                const Text('LV-2023'),
                                const SizedBox(height: 5),
                                Text('$currentDate - $currentDate'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height:10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Izin sakit pergi ke dokter', style: TextStyle(fontWeight: FontWeight.bold))
                          ]
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(currentDate, style: const TextStyle(color: AppColors.lightGreen)),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  AppLocalizations(globalLanguage).translate("approved"),
                                  style: const TextStyle(
                                    color: AppColors.deepGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ),
                        const SizedBox(height:10),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations(globalLanguage).translate("requestType"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(AppLocalizations(globalLanguage).translate("requestNo"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Text(AppLocalizations(globalLanguage).translate("from"), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(':'),
                                SizedBox(height: 5),
                                Text(':'),
                                SizedBox(height: 5),
                                Text(':'),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations(globalLanguage).translate("leave")),
                                const SizedBox(height: 5),
                                const Text('LV-2023'),
                                const SizedBox(height: 5),
                                Text('$currentDate - $currentDate'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height:10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text('Izin sakit pergi kedokter', style: TextStyle(fontWeight: FontWeight.bold))
                          ]
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 80,
            right: 80,
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
                      builder: (context) => const RequestFormPage(),
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
                  AppLocalizations(globalLanguage).translate("addRequest"),
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
      ),
    );
  }
}
