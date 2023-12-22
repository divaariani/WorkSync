import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'app_colors.dart';
import '../controllers/monitoring_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  @override
  void initState() {
    super.initState();

    cardGradient = LinearGradient(
      colors: [Colors.white, AppColors.lightGreen],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    searchController = TextEditingController();
    fetchData();
  }

  Future<void> fetchData({int? searchYear}) async {
    try {
      List<Map<String, dynamic>> data = await MonitoringController().fetchMonitoringData(searchYear: searchYear);
      setState(() {
        _data = data;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> createAndExportExcel(List<Map<String, dynamic>> data) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
      if (!status.isGranted) {
        return;
      }
    }

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow([
      'Nama Point', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
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
      ]);
    }

    for (var cell in sheet.row(0)) {
      if (cell != null) {
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }
    }

    final excelFile = File('${(await getTemporaryDirectory()).path}/MonitoringCheckPoint.xlsx');
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
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Monitoring',
              style: TextStyle(
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
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Image.asset('assets/search.png'),
              onPressed: () {
                showSearchField();
              },
            ),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: MonitoringController().fetchMonitoringData(searchYear: searchYear),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Map<String, dynamic>> data = snapshot.data!;
                            if (data.isNotEmpty) {
                              return Column(
                                children: data.map((item) {
                                  String CP_Note = item['CP_Note'] ?? '';
                                  String Jan = item['Jan'] ?? '';
                                  String February = item['Peb'] ?? '';
                                  String March = item['Mar'] ?? '';
                                  String April = item['Apr'] ?? '';
                                  String Mei = item['Mei'] ?? '';
                                  String June = item['Jun'] ?? '';
                                  String July = item['Jul'] ?? '';
                                  String August = item['Ags'] ?? '';
                                  String Sept = item['Sep'] ?? '';
                                  String Oktober = item['Okt'] ?? '';
                                  String Nop = item['Nop'] ?? '';
                                  String December = item['Des'] ?? '';
                                  String totalPerCP = item['TotalPerCP'] ?? '';

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
                                          constraints: BoxConstraints(
                                            maxWidth: 100,
                                          ),
                                          child: Center(
                                            child: Text(
                                              CP_Note,
                                              style: TextStyle(
                                                color: AppColors.deepGreen,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 1),
                                        Expanded(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 3,
                                              ),
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
                                                        bulan: 'January',
                                                        kali: Jan.isNotEmpty ? '$Jan X' : Jan,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'February',
                                                        kali: February.isNotEmpty ? '$February X' : February,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'March',
                                                        kali: March.isNotEmpty ? '$March X' : March,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'April',
                                                        kali: April.isNotEmpty ? '$April X' : April,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'Mei',
                                                        kali: Mei.isNotEmpty ? '$Mei X' : Mei,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'June',
                                                        kali: June.isNotEmpty ? '$June X' : June,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'July',
                                                        kali: July.isNotEmpty ? '$July X' : July,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'August',
                                                        kali: August.isNotEmpty ? '$August X' : August,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'September',
                                                        kali: Sept.isNotEmpty ? '$Sept X' : Sept,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'Oktober',
                                                        kali: Oktober.isNotEmpty ? '$Oktober X' : Oktober,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'November',
                                                        kali: Nop.isNotEmpty ? '$Nop X' : Nop,
                                                      ),
                                                      CustomCard(
                                                        gradient: cardGradient,
                                                        imagePath: 'assets/book_check.png',
                                                        bulan: 'December',
                                                        kali: December.isNotEmpty ? '$December X' : December,
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
                                }).toList(),
                              );
                            } else {
                              return Text('No data available.');
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 80,
            right: 80,
            child: InkWell(
              onTap: () {
                print(_data);
                createAndExportExcel(_data);
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
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                    child: Text(
                      'Export Excel',
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
    );
  }

  void showSearchField() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Enter Year',
          style: TextStyle(
            color: AppColors.deepGreen,
            fontSize: 14,
          )),
        content: TextField(
          controller: searchController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Year',
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                searchYear = int.tryParse(searchController.text) ?? DateTime.now().year;
              });
              Navigator.pop(context);
            },
            icon: Icon(Icons.search),
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
              SizedBox(height: 4),
              Text(
                bulan,
                style: TextStyle(
                  color: AppColors.deepGreen,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                kali,
                style: TextStyle(
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