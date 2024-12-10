import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worksync/pages/checkpointdone_page.dart';
import 'package:tab_container/tab_container.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'checkpointscan_page.dart';
import '../utils/globals.dart';
import '../controllers/checkpoint_controller.dart';
import '../controllers/monitoring_controller.dart';
import '../utils/localizations.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CheckPointPage extends StatefulWidget {
  final String result;
  final List<String> resultCheckpoint;

  const CheckPointPage(
      {required this.result, required this.resultCheckpoint, Key? key})
      : super(key: key);

  @override
  State<CheckPointPage> createState() => _CheckPointPageState();
}

class _CheckPointPageState extends State<CheckPointPage> {
  final CheckPointController controller = CheckPointController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController cariController = TextEditingController();
  late Gradient cardGradient;
  late List<Map<String, dynamic>> _data = [];
  int searchYear = DateTime.now().year;
  String barcodeCheckpointResult = globalBarcodeCheckpointResult;

  @override
  void initState() {
    super.initState();

    cardGradient = const LinearGradient(
      colors: [Colors.white, AppColors.lightGreen],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    fetchData();
  }

  Future<void> fetchData({int? searchYear}) async {
    try {
      // if (searchYear == null) {
      //   searchYear = DateTime.now().year;
      // }

      List<Map<String, dynamic>> data = await MonitoringController()
          .fetchMonitoringData(searchYear: searchYear);

      setState(() {
        _data = data;
      });
    } catch (error) {
      debugPrint('Error fetching data: $error');
    }
  }

  Future<void> createAndExportExcel(
      int searchYear, List<Map<String, dynamic>> data) async {
    List<Map<String, dynamic>> data = await MonitoringController()
        .fetchMonitoringData(searchYear: searchYear);
    final excel = Excel.createExcel();
    final sheet = excel['Data $searchYear'];

    sheet.appendRow([
      'Nama Point',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
      'Total'
    ]);

    for (var item in data) {
      sheet.appendRow([
        item['CP_Note'] ?? '',
        item['Jan'] ?? '',
        item['Peb'] ?? '',
        item['Mar'] ?? '',
        item['Apr'] ?? '',
        item['Mei'] ?? '',
        item['Jun'] ?? '',
        item['Jul'] ?? '',
        item['Ags'] ?? '',
        item['Sep'] ?? '',
        item['Okt'] ?? '',
        item['Nop'] ?? '',
        item['Des'] ?? '',
        item['TotalPerCP'] ?? '',
      ]);
    }

    for (var cell in sheet.row(0)) {
      if (cell != null) {
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }
    }

    final excelFile = File(
        '${(await getTemporaryDirectory()).path}/Monitoring CheckPoint.xlsx');
    final excelData = excel.encode()!;

    await excelFile.writeAsBytes(excelData);

    if (excelFile.existsSync()) {
      shareExcelFile(excelFile);
    } else {
      debugPrint('File Excel not found.');
    }
  }

  void shareExcelFile(File excelFile) {
    Share.shareXFiles(
      [XFile(excelFile.path)],
      text: 'Exported Excel',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool _) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return Future.sync(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: globalTheme == 'Light Theme'
                    ? AppColors.deepGreen
                    : Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage(initialIndex: 1)),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("checkpoinTour"),
            style: TextStyle(
              color: globalTheme == 'Light Theme'
                  ? AppColors.deepGreen
                  : Colors.white,
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
                  colors: [Colors.white, AppColors.lightGreen],
                ),
              ),
            ),
            TabContainer(color: AppColors.lightGreen, tabs: [
              AppLocalizations(globalLanguage).translate("checkpoinTour"),
              AppLocalizations(globalLanguage).translate("monitoring"),
            ], children: [
              // main
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: controller.fetchCheckPointUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Map<String, dynamic>> checkPointList =
                                snapshot.data ?? [];

                            String getStatus(Map<String, dynamic> checkpoint) {
                              DateTime? startDate = DateTime.tryParse(
                                  checkpoint['KPI_AP_TaskLine_StartDate'] ??
                                      '');
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
                              checkPointList =
                                  checkPointList.where((checkpoint) {
                                String status =
                                    getStatus(checkpoint).toLowerCase();

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
                                    status.contains(query);
                              }).toList();
                            }
                            return ListView.builder(
                              itemCount: checkPointList.length,
                              itemBuilder: (context, index) {
                                final checkpoint = checkPointList[index];

                                DateTime? startDate = DateTime.tryParse(
                                    checkpoint['KPI_AP_TaskLine_StartDate'] ??
                                        '');
                                DateTime? endDate = DateTime.tryParse(
                                    checkpoint['KPI_AP_TaskLine_EndDate'] ??
                                        '');

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
                                  return const SizedBox.shrink();
                                }

                                TextStyle status = TextStyle(
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
                                    : const SizedBox.shrink();

                                Widget lastItemSpace =
                                    (index == checkPointList.length - 1)
                                        ? const SizedBox(height: 60)
                                        : const SizedBox.shrink();

                                return Column(
                                  children: [
                                    firstItemSpace,
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CheckpointDonePage(
                                                    cpCode: checkpoint[
                                                        'LinkDokumen'],
                                                    cpName:
                                                        checkpoint['CP_Note']),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Center(
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
                                                        BorderRadius.circular(
                                                            10),
                                                    image:
                                                        const DecorationImage(
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
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                style: status,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        timerText,
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .mainGreen,
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
              // monitoring
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: cariController,
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
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: GestureDetector(
                            onTap: () async {
                              showSearchField();
                            },
                            child: Container(
                              height: 63,
                              width: 63,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/filter.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: MonitoringController()
                            .fetchMonitoringData(searchYear: searchYear),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Map<String, dynamic>> data = snapshot.data!;
                            data = data.where((item) {
                              String cpNote = item['CP_Note'] ?? '';
                              return cpNote
                                  .toLowerCase()
                                  .contains(cariController.text.toLowerCase());
                            }).toList();

                            if (data.isNotEmpty) {
                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> item = data[index];

                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        buildSingleCard(item)
                                      ],
                                    );
                                  } else if (index == data.length - 1) {
                                    return Column(
                                      children: [
                                        buildSingleCard(item),
                                        const SizedBox(height: 58)
                                      ],
                                    );
                                  } else {
                                    return buildSingleCard(item);
                                  }
                                },
                              );
                            } else {
                              return Center(
                                child: Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("noDataa"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 30),
                        child: Text(
                          AppLocalizations(globalLanguage)
                              .translate("Checkpoint"),
                          style: const TextStyle(
                            color: AppColors.deepGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
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
                        createAndExportExcel(searchYear, _data);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 30),
                        child: Text(
                          AppLocalizations(globalLanguage)
                              .translate("exportexcel"),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSingleCard(Map<String, dynamic> item) {
    String cpNote = item['CP_Note'] ?? '';
    String totalPerCP = item['TotalPerCP'] ?? '';
    String january = item['Jan'] ?? '';
    String february = item['Peb'] ?? '';
    String march = item['Mar'] ?? '';
    String april = item['Apr'] ?? '';
    String mei = item['Mei'] ?? '';
    String june = item['Jun'] ?? '';
    String july = item['Jul'] ?? '';
    String august = item['Ags'] ?? '';
    String sept = item['Sep'] ?? '';
    String october = item['Okt'] ?? '';
    String nov = item['Nop'] ?? '';
    String december = item['Des'] ?? '';
    String total = AppLocalizations(globalLanguage).translate("total");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    cpNote,
                    style: const TextStyle(
                      color: AppColors.deepGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "$total : $totalPerCP",
                    style: const TextStyle(
                      color: AppColors.deepGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 1),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.5,
                      ),
                      items: [
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("january"),
                          kali: january.isNotEmpty && january.isNotEmpty
                              ? '$january X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("february"),
                          kali: february.isNotEmpty && february.isNotEmpty
                              ? '$february X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("march"),
                          kali: march.isNotEmpty && march.isNotEmpty
                              ? '$march X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("april"),
                          kali: april.isNotEmpty && april.isNotEmpty
                              ? '$april X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan:
                              AppLocalizations(globalLanguage).translate("may"),
                          kali:
                              mei.isNotEmpty && mei.isNotEmpty ? '$mei X' : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("june"),
                          kali: june.isNotEmpty && june.isNotEmpty
                              ? '$june X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan:
                              AppLocalizations(globalLanguage).translate("jul"),
                          kali: july.isNotEmpty && july.isNotEmpty
                              ? '$july X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("august"),
                          kali: august.isNotEmpty && august.isNotEmpty
                              ? '$august X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan: AppLocalizations(globalLanguage)
                              .translate("sept"),
                          kali: sept.isNotEmpty && sept.isNotEmpty
                              ? '$sept X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan:
                              AppLocalizations(globalLanguage).translate("okt"),
                          kali: october.isNotEmpty && october.isNotEmpty
                              ? '$october X'
                              : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan:
                              AppLocalizations(globalLanguage).translate("nov"),
                          kali:
                              nov.isNotEmpty && nov.isNotEmpty ? '$nov X' : '0',
                        ),
                        CustomCard(
                          gradient: cardGradient,
                          imagePath: 'assets/book_check.png',
                          bulan:
                              AppLocalizations(globalLanguage).translate("des"),
                          kali: december.isNotEmpty && december.isNotEmpty
                              ? '$december X'
                              : '0',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSearchField() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations(globalLanguage).translate("inputyear"),
            style: const TextStyle(
              color: AppColors.deepGreen,
              fontSize: 14,
            )),
        content: TextField(
          controller: searchController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppLocalizations(globalLanguage).translate("inputyear"),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                searchYear =
                    int.tryParse(searchController.text) ?? DateTime.now().year;
              });
              Navigator.pop(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Gradient gradient;
  final String imagePath;
  final String bulan;
  final String kali;

  const CustomCard({
    Key? key,
    required this.gradient,
    required this.imagePath,
    required this.bulan,
    required this.kali,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 250,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: gradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 4),
              Text(
                bulan,
                style: const TextStyle(
                  color: AppColors.deepGreen,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                kali,
                style: const TextStyle(
                  color: AppColors.deepGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
