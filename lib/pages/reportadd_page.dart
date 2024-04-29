import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'reportmanual_page.dart';
import 'app_colors.dart';
import 'home_page.dart';
import '../utils/globals.dart';
import 'refresh_page.dart';
import '../utils/localizations.dart';
import '../utils/session_manager.dart';
import '../controllers/report_controller.dart';
import '../controllers/response_model.dart';

class ReportAddPage extends StatefulWidget {
  String result;
  List<String> resultBarangQc;

  ReportAddPage({required this.result, required this.resultBarangQc, Key? key}) : super(key: key);

  @override
  State<ReportAddPage> createState() => _ReportAddPageState();
}

class _ReportAddPageState extends State<ReportAddPage> {
  final SessionManager sessionManager = SessionManager();
  final SessionManager _sessionManager = SessionManager();
  final plotnumberController = TextEditingController();
  final stateController = TextEditingController();
  final idController = TextEditingController();
  final _dateController = TextEditingController();
  final _createTglController = TextEditingController();
  late DateTime currentTime;
  String userIdLogin = "";
  String barcodeBarangqcResult = globalBarcodeBarangqcResult;
  String? globalTglKP;
  double fontSize = 16.0;
  DateTime? _selectedDay;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    String plotnumberList = widget.resultBarangQc.join('\n');
    plotnumberController.text = plotnumberList;
    _dateController.text = globalTglKP ?? _getFormattedCurrentDateTime();
    _fetchUserId();
    _fetchCurrentTime();

    _createTglController.text = _getFormattedCurrentDateTime();

    if (globalTglKP != null && globalTglKP!.isNotEmpty) {
      _selectedDay = DateFormat('yyyy-MM-dd').parse(globalTglKP!);
    } else {
      _selectedDay = DateTime.now();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateCreateTgl();
    });
  }

  //scan
  Future<void> _scanBarcode() async {
    bool finishScanning = false;
    DateTime? previousSelectedDay = _selectedDay;
    String previousUserIdLogin = userIdLogin;
    String previousCreateTgl = _createTglController.text;

    while (!finishScanning) {
      String barcodeQcBarangResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        AppLocalizations(globalLanguage).translate("finish"),
        true,
        ScanMode.BARCODE,
      );

      if (barcodeQcBarangResult == '-1') {
       //_showReScanDialog();
        _navigateToreportAddPage();
        return;
      }

      if (barcodeQcBarangResult.isNotEmpty) {
        setState(() {
          globalBarcodeBarangQcResults.add(barcodeQcBarangResult);
        });
      }

      setState(() {
        _selectedDay = previousSelectedDay;
        userIdLogin = previousUserIdLogin;
        _createTglController.text = previousCreateTgl;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(16),
            title: Center(
                child: CircularProgressIndicator(color: AppColors.mainGreen)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$barcodeQcBarangResult',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (!finishScanning) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void _navigateToreportAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportAddPage(
            result: '', resultBarangQc: globalBarcodeBarangQcResults),
      ),
    );
  }

  String _getFormattedCurrentDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  void _updateCreateTgl() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    setState(() {
      _createTglController.text = formattedDate;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      globalBarcodeBarangQcResults.removeAt(index);
    });
  }

  Future<void> _fetchUserId() async {
    userIdLogin = await _sessionManager.getUserId() ?? "";
    final username = await _sessionManager.getNamaUser();

    if (username != null) {
      setState(() {
        idController.text = username;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
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

  Future<void> _submitStock() async {
    List<String> errorMessages = [];

    try {
      final int userId = int.parse(userIdLogin);
      final String uid = userIdLogin;
      String tglKpText = _dateController.text;
      String createdateText = _createTglController.text;

      DateTime tglkp = DateFormat('yyyy-MM-dd').parse(tglKpText);
      DateTime createdate =
          DateFormat('yyyy-MM-dd HH:mm').parse(createdateText);

      final List<Map<String, String?>> inventoryDetails = widget.resultBarangQc
          .map((lotnumber) => {
                'lotnumber': lotnumber,
                'state': 'draft',
              })
          .toList();

      if (inventoryDetails.isEmpty) {
        final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "Peringatan !",
              message: "Tidak ada data yang ingin disubmit.",
              contentType: ContentType.warning,
            ),
          );
          
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        return;
      }

      ResponseModel response = await ReportController.postFormDataLaporanTambah(
        p_tgl_kp: tglkp,
        p_userid: userId,
        p_uid: uid,
        p_createdate: createdate,
        p_inventory_details: inventoryDetails,
      );

      if (response.status == 0) {
        errorMessages.add('Permintaan gagal: ${response.message}');
      } else if (response.status != 1) {
        errorMessages.add('Terjadi kesalahan: Respon tidak valid.');
      }

      if (errorMessages.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessages.join('\n')),
          ),
        );
      } else {
        final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: "Berhasil !",
              message: "Stok berhasil diunggah.",
              contentType: ContentType.success,
            ),
          );
          
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
      }

      widget.resultBarangQc.clear();
      _dateController.clear();
      _createTglController.clear();

      setState(() {
        widget.resultBarangQc = [];
      });
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

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
            centerTitle: true,
            title: Text(
              AppLocalizations(globalLanguage).translate("addProduct"),
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
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
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
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [                
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'User Name',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                controller: idController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 19),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Createdate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextField(
                                controller: _createTglController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 19),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.all(16),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildGradientButton(
                                                AppLocalizations(globalLanguage)
                                                    .translate("scanbarcode"),
                                                () async {
                                              Navigator.pop(context);
                                              await _scanBarcode();
                                            }),
                                            const SizedBox(height: 16),
                                            _buildGradientButton(
                                                AppLocalizations(globalLanguage)
                                                    .translate("entermanually"),
                                                () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ReportManualPage()),
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 30),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations(globalLanguage)
                                            .translate("add"),
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations(globalLanguage).translate("detailProduct"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: fontSize,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No',
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppLocalizations(globalLanguage).translate("lotnumber"),
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.89,
                              height: 3,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemCount: globalBarcodeBarangQcResults.isEmpty
                            ? 1
                            : globalBarcodeBarangQcResults.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: TextField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText:
                                                globalBarcodeBarangQcResults
                                                        .isEmpty
                                                    ? "No"
                                                    : (index + 1).toString(),
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: TextField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            hintText: globalBarcodeBarangQcResults
                                                    .isEmpty
                                                ? "Lot Number"
                                                : globalBarcodeBarangQcResults[
                                                    index],
                                            filled: true,
                                            fillColor: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: globalBarcodeBarangQcResults
                                          .isNotEmpty,
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Warning"),
                                                content: Text(
                                                    AppLocalizations(globalLanguage)
                                            .translate("suredelete")),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(AppLocalizations(globalLanguage)
                                            .translate("cancel")),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteItem(index);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(AppLocalizations(globalLanguage)
                                            .translate("yes")),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 13),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
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
                              onTap: () async {
                                _submitStock();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RefreshLaporanTable()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      AppColors.lightGreen
                                    ],
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
                                            .translate("submit"),
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
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Widget _buildGradientButton(String text, Function() onPressed) {
  return Container(
    height: 40,
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
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
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
  );
}
