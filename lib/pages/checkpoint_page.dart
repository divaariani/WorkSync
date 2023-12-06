import 'package:flutter/material.dart';
import 'package:worksync/pages/home_page.dart';
import 'app_colors.dart';
import 'checkpointscan_page.dart';
import '../utils/globals.dart';
import '../controllers/checkpoint_controller.dart';
import 'package:intl/intl.dart';
import '../utils/localizations.dart';
import 'features_page.dart';

class CheckPointPage extends StatefulWidget {
  String result;
  List<String> resultCheckpoint;

  CheckPointPage({
    required this.result,
    required this.resultCheckpoint,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckPointPage> createState() => _CheckPointPageState();
}

class _CheckPointPageState extends State<CheckPointPage> {
  String barcodeCheckpointResult = globalBarcodeCheckpointResult;
  final CheckPointController controller = CheckPointController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("Checkpoint Tour"),
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
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: controller.fetchCheckPointUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final List<Map<String, dynamic>> CheckPointList =
                            snapshot.data ?? [];

                        return ListView.builder(
                          itemCount: CheckPointList.length,
                          itemBuilder: (context, index) {
                            final checkpoint = CheckPointList[index];

                            DateTime? startDate = DateTime.tryParse(
                                checkpoint['KPI_AP_TaskLine_StartDate'] ?? '');
                            DateTime? endDate = DateTime.tryParse(
                                checkpoint['KPI_AP_TaskLine_EndDate'] ?? '');

                            String formatTime(DateTime? dateTime) {
                              return dateTime != null
                                  ? DateFormat('yyyy-MM-dd HH:mm').format(dateTime)
                                  : '';
                            }

                            String timerText = endDate != null
                                ? formatTime(endDate)
                                : (startDate != null ? formatTime(startDate) : '');

                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Center(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/book_check.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      checkpoint['CP_Note'],
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.deepGreen,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                 Align(
                                                alignment: Alignment.topCenter,
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 20),
                                                  child: Text(
                                                    startDate != null
                                                        ? (endDate != null ? 'Done' : 'Patrolling')
                                                        : 'Not Patrolling',
                                                    style: TextStyle(
                                                      color: endDate != null
                                                          ? const Color(0xFF28B446)
                                                          : (startDate != null
                                                              ? AppColors.lightGreen
                                                              : AppColors.deepGreen),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                timerText,
                                                style: TextStyle(
                                                  color: AppColors.mainGreen,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Positioned(child: 
                Container(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckPointScanPage(),
                          ),
                        );
                      },
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 50),
                          child: Text(
                            'Choose Site',
                            style: TextStyle(
                              color: AppColors.deepGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
