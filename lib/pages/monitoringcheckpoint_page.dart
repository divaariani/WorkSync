import 'dart:io';
import 'app_colors.dart';
import '../utils/globals.dart';
import 'package:excel/excel.dart';
import '../utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/monitoring_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MonitoringCpPage extends StatefulWidget {
  const MonitoringCpPage({Key? key}) : super(key: key);

  @override
  State<MonitoringCpPage> createState() => _MonitoringCpPageState();
}

class _MonitoringCpPageState extends State<MonitoringCpPage> {
  late Gradient cardGradient;
  late List<Map<String, dynamic>> _data = [];
  late TextEditingController searchController;
  int searchYear = DateTime.now().year;
  final TextEditingController cariController = TextEditingController();

  @override
  void initState() {
    super.initState();

    cardGradient = const LinearGradient(
      colors: [Colors.white, AppColors.lightGreen],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    searchController = TextEditingController();
    fetchData();
  }

  Future<void> fetchData({int? searchYear}) async {
    try {
      if (searchYear == null) {
        searchYear = DateTime.now().year;
      }

      List<Map<String, dynamic>> data = await MonitoringController()
          .fetchMonitoringData(searchYear: searchYear);
      print('API Response: $data');

      setState(() {
        _data = data;
      });
    } catch (error) {
      print('Error fetching data: $error');
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
      print('File Excel not found.');
    }
  }

  void shareExcelFile(File excelFile) {
    Share.shareFiles(
      [excelFile.path],
      text: 'Exported Excel',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations(globalLanguage).translate("monitoring"),
              style: const TextStyle(
                  color: AppColors.deepGreen, fontWeight: FontWeight.bold),
            ),
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
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                    GestureDetector(
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
                    )
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: MonitoringController()
                        .fetchMonitoringData(searchYear: searchYear),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                        child:  CircularProgressIndicator(
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
                              return buildSingleCard(
                                  item); 
                            },
                          );
                        } else {
                          return const Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
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
          Positioned(
            bottom: 16,
            left: 80,
            right: 80,
            child: InkWell(
              onTap: () {
                print(_data);
                createAndExportExcel(searchYear, _data);
              },
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
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                    child: Text(
                      AppLocalizations(globalLanguage).translate("exportexcel"),
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
      child: 
      Row(
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
