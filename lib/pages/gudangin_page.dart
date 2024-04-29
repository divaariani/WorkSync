import 'dart:ui' as ui;
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'refresh_page.dart';
import 'home_page.dart';
import 'app_colors.dart';
import '../controllers/gudangin_controller.dart';
import '../utils/session_manager.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';


class GudanginPage extends StatefulWidget {
  const GudanginPage({Key? key}) : super(key: key);

  @override
  State<GudanginPage> createState() => _GudanginPageState();
}

class _GudanginPageState extends State<GudanginPage> {
  final SessionManager sessionManager = SessionManager();
  String searchText = "";
  

  @override
  void initState() {
    super.initState();
  }

  Future<void> _scanBarcode() async {
    
    String barcodeGudangBarangResult = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    if (barcodeGudangBarangResult == '-1') {
      _showReScanDialog();
      return;
    }

    if (barcodeGudangBarangResult.isNotEmpty) {
      try {
        await GudangInController.updateWarehouseInScan(lotnumber: barcodeGudangBarangResult);
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const RefreshGudangStatusTable()),
        );
      
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void _showReScanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Please Re-Scan Barcode"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onScanButtonPressed() {
    _scanBarcode();
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(initialIndex: 1)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("warehouse"),
            style: TextStyle(
              color: globalTheme == 'Light Theme'
                  ? AppColors.deepGreen
                  : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                    CardTable(searchText,
                        onScanButtonPressed: _onScanButtonPressed),
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
  final String checked;
  final int id;
  final String tgl_kp;
  final String lotnumber;
  final String namabarang;
  final int qty;
  final String uom;

  MyData({
    required this.checked,
    required this.id,
    required this.tgl_kp,
    required this.lotnumber,
    required this.namabarang,
    required this.qty,
    required this.uom,
  });
}

class MyDataTableSource extends DataTableSource {
  final List<MyData> data;

  MyDataTableSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final entry = data[index];
    Color textColor = Colors.black; 

    if (entry.checked.toLowerCase() == 'draft') {
      textColor = Colors.orange; 
    } else if (entry.checked.toLowerCase() == 'checked') {
      textColor = Colors.green; 
    }

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.checked,
              style: TextStyle(
                color: textColor, 
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
              entry.id.toString(),
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
              entry.tgl_kp,
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
              entry.namabarang,
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
              entry.qty.toString(),
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
              entry.uom,
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
  final ui.VoidCallback onScanButtonPressed;

  CardTable(this.searchText, {required this.onScanButtonPressed});

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  TextEditingController controller = TextEditingController();
  final GudangInController _gudangUploadController = GudangInController();
  List<MyData> _data = [];
  List<MyData> _fetchedData = [];
  bool _isLoading = false;
  String _searchResult = '';
  late DateTime currentTime;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
    _fetchCurrentTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDataFromAPI();
  }

  Future<void> _fetchCurrentTime() async {
    try {
      setState(() {
        currentTime = DateTime.now();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchDataFromAPI() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final DateTime tgl_kp = DateTime.now();
      final response = await GudangInController.viewGudangIn(
        checked: '',
        id: 1,
        tgl_kp: tgl_kp,
        lotnumber: '',
        namabarang: '',
        qty: 1,
        uom: '',
      );

      final List<dynamic> nameDataList = response.data;

      final List<MyData> myDataList = nameDataList.map((data) {
        String checked = data['checked'] ?? "";
        int id = int.tryParse(data['id'].toString()) ?? 0;
        String tgl_kp = data['tgl_kp'] ?? "";
        String lotnumber = data['lotnumber'] ?? "";
        String namabarang = data['namabarang'] ?? "";
        int qty = int.tryParse(data['qty'].toString()) ?? 0;
        String uom = data['uom'] ?? "";

        return MyData(
          checked: checked,
          id: id,
          tgl_kp: tgl_kp,
          lotnumber: lotnumber,
          namabarang: namabarang,
          qty: qty,
          uom: uom,
        );
      }).toList();

      _fetchedData = myDataList;

      setState(() {
        _data = myDataList.where((data) {
          return (data.checked.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.id.toString()).contains(_searchResult.toLowerCase()) ||
              (data.qty.toString()).contains(_searchResult.toLowerCase()) ||
              (data.namabarang.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.lotnumber.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.uom.toLowerCase()).contains(_searchResult.toLowerCase()) ||
              (data.namabarang.toLowerCase()).contains(_searchResult.toLowerCase());
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

    sheet.appendRow([
      'Checked',
      'Id',
      'Tanggal Kp',
      'Lot Number',
      'Nama Barang',
      'Qty',
      'Uom'
    ]);

    for (MyData data in _fetchedData) {
      sheet.appendRow([
        data.checked,
        data.id,
        data.tgl_kp,
        data.lotnumber,
        data.namabarang,
        data.qty,
        data.uom,
      ]);
    }

    for (var cell in sheet.row(0)) {
      if (cell != null) {
        cell.cellStyle = CellStyle(
          bold: true,
        );
      }
    }

    final excelFile =
        io.File('${(await getTemporaryDirectory()).path}/Warehouse.xlsx');
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: controller,
                       onChanged: (value) {
                        setState(() {
                          _searchResult = value;
                          fetchDataFromAPI();
                        });
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
                    widget.onScanButtonPressed();
                  },
                  child: Container(
                    height: 63,
                    width: 63,
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
                                AppLocalizations(globalLanguage)
                                    .translate('status'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage)
                                    .translate('Id'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage)
                                    .translate('date'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage)
                                    .translate('lotnumber'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage)
                                    .translate('namabarang'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage)
                                    .translate('quantity'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                AppLocalizations(globalLanguage)
                                    .translate('Uom'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                          source: MyDataTableSource(_data),
                          rowsPerPage: 5,
                        ),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                              Column(
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
                            createAndExportExcel(
                                _data.map((data) => data.toString()).toList());
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
                                  vertical: 6, horizontal: 30),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations(globalLanguage)
                                        .translate("exportexcel"),
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
                        )),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
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
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.mainGrey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  content: Text(AppLocalizations(globalLanguage).translate("surestock")),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                          AppLocalizations(globalLanguage).translate("cancel"),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          await _fetchCurrentTime();
                                          final response = await _gudangUploadController.uploadDataToGudang();
                                          if (response['status'] == 1) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RefreshGudangStatusTable()),
                                            );

                                            final snackBar = SnackBar(
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title:
                                                    AppLocalizations(globalLanguage).translate("uploaded"),
                                                message:
                                                    AppLocalizations(globalLanguage).translate("succesupload"),
                                                contentType: ContentType.success,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);

                                            print('Draft posted successfully');
                                          } else {
                                            print('Failed to upload: ${response}');
                                          }
                                        } catch (e) {
                                          print('Error upload: $e ');
                                        }
                                      },
                                      child: Text(
                                          AppLocalizations(globalLanguage).translate("confirm"),
                                          style: const TextStyle(
                                              color: AppColors.mainGreen,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                              child: Text(
                                AppLocalizations(globalLanguage).translate("upload"),
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
              ],
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
