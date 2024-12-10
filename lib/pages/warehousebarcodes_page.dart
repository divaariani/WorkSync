import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'refresh_page.dart';
import 'app_colors.dart';
import 'warehouse_page.dart';
import 'warehousescan_page.dart';
import 'waremobilmanual_page.dart';
import 'warehousemanual_page.dart';
import '../controllers/warehouse_controller.dart';
import '../controllers/response_model.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class WarehouseBarcodesPage extends StatefulWidget {
  const WarehouseBarcodesPage({Key? key}) : super(key: key);

  @override
  State<WarehouseBarcodesPage> createState() => _WarehouseBarcodesPageState();
}

class _WarehouseBarcodesPageState extends State<WarehouseBarcodesPage> {
  final SessionManager sessionManager = SessionManager();
  final hasilscanController = TextEditingController();
  final mobilController = TextEditingController();
  String userid = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    String hasilscan = globalBarcodeGudangResults.join('\n');
    mobilController.text = globalBarcodeMobilResult;
    hasilscanController.text = hasilscan;
    userid = sessionManager.getUserId() ?? '';
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    bool finishScanning = false;

    while (!finishScanning) {
      String barcodeGudangResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        AppLocalizations(globalLanguage).translate("finish"),
        true,
        ScanMode.BARCODE,
      );

      if (barcodeGudangResult == '-1') {
        _navigateBack();
        return;
      }

      if (barcodeGudangResult.isNotEmpty) {
        if (globalBarcodeGudangResults.contains(barcodeGudangResult) &&
            mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(16),
                  title: const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.deepGreen),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${AppLocalizations(globalLanguage).translate("result")}: $barcodeGudangResult',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Lot Number sudah discan.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          setState(() {
            globalBarcodeGudangResults.add(barcodeGudangResult);
          });
        }
      }

      if (mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(16),
                title: const Center(
                  child: CircularProgressIndicator(color: AppColors.deepGreen),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${AppLocalizations(globalLanguage).translate("result")}: $barcodeGudangResult',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            });
      }

      if (!finishScanning) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  void _navigateBack() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WarehouseBarcodesPage(),
      ),
    );
  }

  Future<void> _submitStock() async {
    final String mobil = mobilController.text;
    List<String> errorMessages = [];
    bool success = true;

    try {
      for (String hasilscan in globalBarcodeGudangResults) {
        ResponseModel response = await WarehouseController.postGudangOut(
          hasilscan: hasilscan,
          mobil: mobil,
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
        debugPrint('Gudang out berhasil diupload');
      } else {
        debugPrint('Gagal mengupload gudang out. Kesalahan:');
        for (String errorMessage in errorMessages) {
          debugPrint('- $errorMessage');
        }
      }

      if (errorMessages.isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessages.join('\n')),
          ),
        );
      } else {
        // success upload
      }

      globalBarcodeGudangResults.clear();
      setState(() {
        globalBarcodeGudangResults = [];
      });
    } catch (e) {
      debugPrint('Terjadi kesalahan: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
          ),
        );
      }
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
            AppLocalizations(globalLanguage).translate("productList"),
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
                MaterialPageRoute(builder: (context) => const WarehousePage()),
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
                      AppLocalizations(globalLanguage).translate("truck"),
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
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(30),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations(globalLanguage).translate(
                                      "Apakah Anda ingin mengganti kode truk?")),
                                  const SizedBox(height: 20),
                                  Container(
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
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const WarehouseScanPage()),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations(globalLanguage)
                                                  .translate("scanbarcode"),
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
                                  const SizedBox(height: 10),
                                  Container(
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
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MobilManualPage()),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocalizations(globalLanguage)
                                                  .translate("entermanually"),
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
                              Image.asset('assets/mobil.png',
                                  height: 24, width: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  globalBarcodeMobilResult,
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
                      AppLocalizations(globalLanguage).translate("productList"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: globalBarcodeGudangResults.isEmpty,
                        child: InkWell(
                          onTap: () async {
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await _scanBarcode();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations(
                                                          globalLanguage)
                                                      .translate("scanbarcode"),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WarehouseManualPage()),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations(
                                                          globalLanguage)
                                                      .translate(
                                                          "entermanually"),
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
                                vertical: 6,
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations(globalLanguage)
                                        .translate("addProduct"),
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
                      visible: globalBarcodeGudangResults.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 1),
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
                                  itemCount: globalBarcodeGudangResults.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item =
                                        globalBarcodeGudangResults[index];
                                    return Column(
                                      children: [
                                        if (index == 0)
                                          const SizedBox(height: 22),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3),
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
                                                              globalBarcodeGudangResults
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
                                                              color: Colors.red,
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
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: AppColors.deepGreen,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (index ==
                                            globalBarcodeGudangResults.length -
                                                1)
                                          const SizedBox(height: 22),
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
                  ],
                ),
              ),
            ),
            Visibility(
              visible: globalBarcodeGudangResults.isNotEmpty,
              child: const SizedBox(height: 20),
            ),
            Visibility(
              visible: globalBarcodeGudangResults.isNotEmpty,
              child: Positioned(
                bottom: 20.0,
                left: 0.0,
                right: 0.0,
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
                                  contentPadding: const EdgeInsets.all(30),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await _scanBarcode();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations(
                                                          globalLanguage)
                                                      .translate("scanbarcode"),
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WarehouseManualPage()),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  AppLocalizations(
                                                          globalLanguage)
                                                      .translate(
                                                          "entermanually"),
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
                          _submitStock();
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: AppLocalizations(globalLanguage)
                                  .translate("uploaded"),
                              message: AppLocalizations(globalLanguage)
                                  .translate("succesproductupload"),
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RefreshWarehouseTable(),
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
            ),
          ],
        ),
      ),
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
