import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'home_page.dart';
import 'warehousescan_page.dart';
import 'waremobilmanual_page.dart';
import 'warehousebarcodes_page.dart';
import 'app_colors.dart';
import '../controllers/warehouse_controller.dart';
import '../utils/session_manager.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({Key? key}) : super(key: key);

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  final SessionManager sessionManager = SessionManager();
  String searchText = "";

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 1)),
        );
        return false;
      },
      
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("DO Picking"),
            style: TextStyle(
              color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.deepGreen, AppColors.lightGreen],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CardTable(searchText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyData {
  final String mobil;
  final String lotnumber;
  final String name;
  final String merk;
  final String pack;
  final String stock;
  final String unit;
  final String status;
  final String aksi;

  MyData({
    required this.mobil,
    required this.lotnumber,
    required this.name,
    required this.merk,
    required this.pack,
    required this.stock,
    required this.unit,
    required this.status,
    required this.aksi
  });
}

class MyDataTableSource extends DataTableSource {
  final List<MyData> data;
  final BuildContext context;

  MyDataTableSource(this.data, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final entry = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          GestureDetector(
            onTap: () async {
              globalBarcodeMobilResult = entry.mobil;
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => const WarehouseBarcodesPage()),
              );
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                entry.mobil,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.lotnumber,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.merk,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.pack,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.stock,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.unit,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.status,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class CardTable extends StatefulWidget {
  final String searchText;
  TextEditingController controller = TextEditingController();
  
  CardTable(this.searchText);

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  TextEditingController controller = TextEditingController();
  List<MyData> _data = [];
  List<MyData> _fetchedData = [];
  bool _isLoading = false;
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await WarehouseController.viewGudangOut(
        mobil: '',
        noLot: '',
        namaBarang: '',
        merk: '',
        pack: '',
        stock: '',
        unit: '',
        status: ''
      );

      final List<dynamic> nameDataList = response.data;

      final List<MyData> myDataList = nameDataList.map((data) {
        String mobil = data['NoMobil'] ?? "";
        String lotnumber = data['NoLot'] ?? "";
        String name = data['NamaBarang'] ?? "";
        String merk = data['Merk'] ?? "";
        String pack = data['UnitPack'] ?? "";
        String stock = data['Stock'] ?? "";
        String unit = data['Unit'] ?? "";
        String status = data['Status'] ?? "";

        return MyData(
          mobil: mobil,
          lotnumber: lotnumber,
          name: name,
          merk: merk,
          pack: pack,
          stock: stock,
          unit: unit,
          status: status,
          aksi: '',
        );
      }).toList();

      _fetchedData = myDataList;

      setState(() {
        _data = myDataList.where((data) {
          return (data.name.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.lotnumber.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.mobil.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.status.toLowerCase()).contains(_searchResult.toLowerCase());
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createAndExportExcel(List<String> data) async {
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

    sheet.appendRow(['Truck', 'Product Name', 'Lot Number', 'Quantity', 'Status']);
    
    for (MyData data in _fetchedData) {
      sheet.appendRow([
        data.mobil,
        data.name,
        data.lotnumber,
        data.stock,
        data.status,
      ]);
    }

    for (var cell in sheet.row(0)) {
      if (cell != null) {
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }
    }

    final excelFile = File('${(await getTemporaryDirectory()).path}/DOpicking.xlsx');
    final excelData = excel.encode()!;

    await excelFile.writeAsBytes(excelData);

    if (excelFile.existsSync()) {
      Share.shareFiles(
        [excelFile.path],
        text: 'Exported Excel',
      );
    } else {
      print('File Excel not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations(globalLanguage).translate("search"),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchResult = value;
                          fetchDataFromAPI();
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          _searchResult = '';
                          fetchDataFromAPI();
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  if (globalBarcodeGudangResults.isEmpty) {
                    showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(30),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                          onTap: () async {
                                            Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) => const WarehouseScanPage()),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations(globalLanguage).translate("scanbarcode"),
                                                  style: const TextStyle(
                                                    color: AppColors.deepGreen,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
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
                                          onTap: () async {
                                            Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) => const MobilManualPage()),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations(globalLanguage).translate("entermanually"),
                                                  style: const TextStyle(
                                                    color: AppColors.deepGreen,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                  } else {
                    Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WarehouseBarcodesPage(),
                            ),
                          );
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: AppColors.mainGreen),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        
        const SizedBox(height: 10),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 26),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(children: [
              _isLoading
                  ? const CircularProgressIndicator()
                  : _data.isEmpty
                      ? EmptyData()
                      : PaginatedDataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("truck"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("lotnumber"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("namabarang"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("merk"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("pack"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("stock"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("unit"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage).translate("status"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                          source: MyDataTableSource(_data, context),
                          rowsPerPage: 5,
                        ),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        Row(
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
                          onTap: () async {
                            createAndExportExcel(_data.map((data) => data.toString()).toList());
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
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations(globalLanguage).translate("exportexcel"),
                                    style: const TextStyle(
                                      color: AppColors.deepGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ),
                      ],
                    ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        width: 1 * MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/monitoring.png',
              width: 50,
              height: 50,
              color: AppColors.deepGreen,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                AppLocalizations(globalLanguage).translate("nodata"),
                style: GoogleFonts.poppins(
                  color: AppColors.deepGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
