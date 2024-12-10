import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'stocklokasiscan_page.dart';
import 'cablescan_page.dart';
import 'app_colors.dart';
import 'stockopname_page.dart';
import 'stockmanual_page.dart';
import 'refresh_page.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../utils/localizations.dart';
import '../controllers/response_model.dart';
import '../controllers/cable_controller.dart';

class CableListScanPage extends StatefulWidget {
  const CableListScanPage({Key? key}) : super(key: key);

  @override
  State<CableListScanPage> createState() => _CableListScanPageState();
}

class _CableListScanPageState extends State<CableListScanPage> {
  late DateTime currentTime;
  final SessionManager sessionManager = SessionManager();
  final idController = TextEditingController();
  final hasilscanController = TextEditingController();
  String barcodeLokasiResult = globalBarcodeLokasiResult;
  String idInventory = '';
  String userid = "";

  @override
  void initState() {
    super.initState();
    fetchUserId();
    hasilscanController.text = globalBarcodeBarangResults.join('\n');
    userid = sessionManager.getUserId() ?? '';
  }

  Future<void> _scanBarcode() async {
    bool finishScanning = false;

    while (!finishScanning) {
      String barcodeBarangResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        AppLocalizations(globalLanguage).translate("finish"),
        true,
        ScanMode.BARCODE,
      );

      if (barcodeBarangResult == '-1') {
        navigateBack();
        return;
      }

      if (barcodeBarangResult.isNotEmpty) {
        setState(() {
          globalBarcodeBarangResults.add(barcodeBarangResult);
        });
      }

      dialogHasil(barcodeBarangResult);

      if (!finishScanning) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void navigateBack() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CableScanPage(),
      ),
    );
  }

  void dialogHasil(String barcodeBarang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          title: const Center(
              child: CircularProgressIndicator(color: AppColors.mainGreen)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                barcodeBarang,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void snackbar(String e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan: $e'),
      ),
    );
  }

  Future<void> fetchUserId() async {
    userid = sessionManager.getUserId() ?? "";
    setState(() {});
  }

  Future<void> submitStock() async {
    List<String> errorMessages = [];
    bool success = true;

    try {
      for (String hasilscan in globalBarcodeBarangResults) {
        ResponseModel response = await CableController.postFormStock(
          hasilscan: hasilscan,
          userid: userid,
        );

        if (response.status == 1) {
          success = true;
        } else if (response.status == 0) {
          errorMessages.add('Request gagal: ${response.message}');
        } else if (response.status != 1) {
          errorMessages.add('Terjadi kesalahan: Response tidak valid.');
        }
      }

      if (success) {
        debugPrint('Stock berhasil diupload');
      } else {
        debugPrint('Gagal mengupload Stock. Kesalahan:');
        for (String errorMessage in errorMessages) {
          debugPrint('- $errorMessage');
        }
      }

      if (errorMessages.isNotEmpty) {
        snackbar('');
      } else {
        // success upload
      }

      globalBarcodeBarangResults.clear();
      setState(() {
        globalBarcodeBarangResults = [];
      });
    } catch (e) {
      debugPrint('Terjadi kesalahan: $e');
      snackbar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool _) async {
        return Future.sync(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("Scan Stock"),
            style: TextStyle(
              color: globalTheme == 'Light Theme'
                  ? AppColors.deepGreen
                  : Colors.white,
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
                    builder: (context) => const StockOpnamePage()),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations(globalLanguage).translate("location"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.mainGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Text(AppLocalizations(globalLanguage)
                                .translate("sureChangeLocation")),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                    AppLocalizations(globalLanguage)
                                        .translate("cancel"),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const StockLokasiScan(),
                                    ),
                                  );
                                },
                                child: Text(
                                    AppLocalizations(globalLanguage)
                                        .translate("yes"),
                                    style: const TextStyle(
                                        color: AppColors.mainGreen,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.asset('assets/stocklokasi.png',
                                  height: 24, width: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  barcodeLokasiResult,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColors.deepGreen),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("stocklist"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: globalBarcodeBarangResults.isEmpty,
                        child: InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(16),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildGradientButton(
                                          AppLocalizations(globalLanguage)
                                              .translate("scanbarcode"),
                                          () async {
                                        Navigator.pop(context);
                                        await _scanBarcode();
                                      }),
                                      const SizedBox(height: 16),
                                      buildGradientButton(
                                          AppLocalizations(globalLanguage)
                                              .translate("entermanually"), () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const StockManualPage(),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                  vertical: 6, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations(globalLanguage)
                                        .translate("addstock"),
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
                      ),
                    ),
                    Visibility(
                      visible: globalBarcodeBarangResults.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        globalBarcodeBarangResults.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final item =
                                          globalBarcodeBarangResults[index];
                                      return Column(
                                        children: [
                                          if (index == 0)
                                            const SizedBox(height: 22),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        backgroundColor:
                                                            AppColors.mainGrey,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        content: Text(
                                                          '${AppLocalizations(globalLanguage).translate("suredelete")} $item?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              AppLocalizations(
                                                                      globalLanguage)
                                                                  .translate(
                                                                      "cancel"),
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                globalBarcodeBarangResults
                                                                    .removeAt(
                                                                        index);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              AppLocalizations(
                                                                      globalLanguage)
                                                                  .translate(
                                                                      "yes"),
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    'assets/delete.png',
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: AppColors.deepGreen,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: globalBarcodeBarangResults.isNotEmpty,
                      child: const SizedBox(height: 20),
                    ),
                    Visibility(
                      visible: globalBarcodeBarangResults.isNotEmpty,
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            buildGradientButton(
                                                AppLocalizations(globalLanguage)
                                                    .translate("scanbarcode"),
                                                () async {
                                              Navigator.pop(context);
                                              await _scanBarcode();
                                            }),
                                            const SizedBox(height: 16),
                                            buildGradientButton(
                                                AppLocalizations(globalLanguage)
                                                    .translate("entermanually"),
                                                () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const StockManualPage()),
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    },
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
                                              .translate("add"),
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
                              )),
                          const SizedBox(width: 10),
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
                                submitStock();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RefreshStockTable(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations(globalLanguage)
                                          .translate("upload"),
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
                    ),
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

Widget buildGradientButton(String text, Function() onPressed) {
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
              'assets/fill.png',
              width: 30,
              height: 30,
              color: AppColors.mainGrey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                AppLocalizations(globalLanguage).translate("noDataa"),
                style: GoogleFonts.poppins(
                  color: AppColors.mainGrey,
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
