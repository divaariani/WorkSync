import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'checkpointscan_page.dart';
import '../utils/globals.dart';
import '../controllers/checkpoint_controller.dart';
import '../utils/localizations.dart';

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
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 1)),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("checkpoinTour"),
            style: TextStyle(
              color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (query) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText:
                              '${AppLocalizations(globalLanguage).translate("search")}...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                  child:
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: controller.fetchCheckPointUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Map<String, dynamic>> CheckPointList =
                            snapshot.data ?? [];

                        String getStatus(Map<String, dynamic> checkpoint) {
                          DateTime? startDate = DateTime.tryParse(
                              checkpoint['KPI_AP_TaskLine_StartDate'] ?? '');
                          DateTime? endDate = DateTime.tryParse(
                              checkpoint['KPI_AP_TaskLine_EndDate'] ?? '');

                          if (endDate != null) {
                            return AppLocalizations(globalLanguage)
                                .translate("done");
                          } else if (startDate != null) {
                            return AppLocalizations(globalLanguage)
                                .translate("patrolling");
                          } else {
                            return AppLocalizations(globalLanguage)
                                .translate("nopatroll");
                          }
                        }

                        if (searchController.text.isNotEmpty) {
                          final String query =
                              searchController.text.toLowerCase();
                          CheckPointList = CheckPointList.where((checkpoint) {
                            String Status = getStatus(checkpoint).toLowerCase();

                            return (checkpoint['CP_Note']
                                        ?.toString()
                                        .toLowerCase()
                                        .contains(query) ??
                                    false) ||
                                (checkpoint['KPI_AP_TaskLine_StartDate'] !=
                                        null &&
                                    checkpoint['KPI_AP_TaskLine_StartDate']
                                        .toString()
                                        .toLowerCase()
                                        .contains(query)) ||
                                (checkpoint['KPI_AP_TaskLine_EndDate'] !=
                                        null &&
                                    checkpoint['KPI_AP_TaskLine_EndDate']
                                        .toString()
                                        .toLowerCase()
                                        .contains(query)) ||
                                Status.contains(query);
                          }).toList();
                        }
                        return ListView.builder(
                            itemCount: CheckPointList.length,
                            itemBuilder: (context, index) {
                              final checkpoint = CheckPointList[index];

                              DateTime? startDate = DateTime.tryParse(
                                  checkpoint['KPI_AP_TaskLine_StartDate'] ??
                                      '');
                              DateTime? endDate = DateTime.tryParse(
                                  checkpoint['KPI_AP_TaskLine_EndDate'] ?? '');

                              String formatTime(DateTime? dateTime) {
                                return dateTime != null
                                    ? DateFormat('yyyy-MM-dd HH:mm')
                                        .format(dateTime)
                                    : '';
                              }

                              String timerText = endDate != null
                                  ? formatTime(endDate)
                                  : (startDate != null
                                      ? formatTime(startDate)
                                      : '');

                              if (checkpoint['CP_Note'] == null ||
                                  checkpoint['CP_Note'].isEmpty) {
                                return SizedBox.shrink();
                              }

                              TextStyle Status = TextStyle(
                                color: endDate != null
                                    ? const Color(0xFF28B446)
                                    : (startDate != null
                                        ? AppColors.lightGreen
                                        : AppColors.deepGreen),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              );

                              Widget firstItemSpace = (index == 0)
                                  ? const SizedBox(height: 16)
                                  : SizedBox.shrink();

                              Widget lastItemSpace =
                                  (index == CheckPointList.length - 1)
                                      ? const SizedBox(height: 60)
                                      : SizedBox.shrink();

                              return Column(
                                children: [
                                  firstItemSpace,
                                  Card(
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
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/book_check.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
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
                                                            checkpoint[
                                                                    'CP_Note'] ??
                                                                'No Room',
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .deepGreen,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20),
                                                            child: Text(
                                                              getStatus(
                                                                  checkpoint),
                                                              style: Status,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                      timerText,
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.mainGreen,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                  ),
                                  lastItemSpace,
                                ],
                              );
                            },
                          );
                        
                      }
                    },
                  ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckPointScanPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                      child: Text(
                        AppLocalizations(globalLanguage).translate("chooseSite"),
                        style: const TextStyle(
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
    );
  }
}