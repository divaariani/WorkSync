import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
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
        title: const Text(
          'Approvals',
          style: TextStyle(
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
                colors: [Colors.white, AppColors.lightGreen],
              ),
            ),
          ),
          TabContainer(
            color: AppColors.lightGreen,
            tabs: const [
              'Overtime',
              'Leave',
            ],
            children: [
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white, AppColors.lightGreen],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2), 
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(
                                      color: AppColors.deepGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                    Text(AppLocalizations(globalLanguage).translate("overtime")),
                                    const SizedBox(height: 5),
                                    const Text('OT-2023'),
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
                                Text('Menyelesaikan project add on erp', style: TextStyle(fontWeight: FontWeight.bold))
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white, AppColors.lightGreen],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2), 
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(
                                      color: AppColors.deepGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                    Text(AppLocalizations(globalLanguage).translate("overtime")),
                                    const SizedBox(height: 5),
                                    const Text('OT-2023'),
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
                                Text('Melakukan rapat dadakan', style: TextStyle(fontWeight: FontWeight.bold))
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white, AppColors.lightGreen],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2), 
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(
                                      color: AppColors.deepGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                                    Text(AppLocalizations(globalLanguage).translate("overtime")),
                                    const SizedBox(height: 5),
                                    const Text('OT-2023'),
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
                                Text('Melakukan rapat dadakan', style: TextStyle(fontWeight: FontWeight.bold))
                              ]
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // divider tab
              Padding(
                padding: EdgeInsets.all(16),
                //CONTENT LEAVE LIST APPROVE REQUEST HERE
                child: Text('List leave requested')
              )
            ],
          ),
        ],
      ),
    );
  }
}