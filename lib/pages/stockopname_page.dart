import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'refresh_page.dart';
import 'stocklokasiscan_page.dart';
import 'stocklokasi_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../controllers/stockopname_controller.dart';
import '../controllers/response_model.dart';

class StockOpnamePage extends StatefulWidget {
  const StockOpnamePage({Key? key}) : super(key: key);

  @override
  State<StockOpnamePage> createState() => _StockOpnamePageState();
}

class _StockOpnamePageState extends State<StockOpnamePage> {
  final TextEditingController searchController = TextEditingController();
  String currentDate = "";
  String userId = '';

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag()).format(DateTime.now());
    userId = SessionManager().getUserId() ?? '';
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
              AppLocalizations(globalLanguage).translate("stockopname"),
              style: TextStyle(
                color: globalTheme == 'Light Theme'
                  ? AppColors.deepGreen
                  : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const CardTable(),
                      const SizedBox(height: 20),
                      Center(
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
                                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        try {
                                          ResponseModel response = await StockOpnameController.postConfirmStock();

                                          if (response.status == 1) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RefreshStockTable()
                                              ),
                                            );

                                            final snackBar = SnackBar(
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: AppLocalizations(globalLanguage).translate("uploaded"),
                                                message: AppLocalizations(globalLanguage).translate("succesupload"),
                                                contentType: ContentType.success,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);

                                            print('Confirm data posted successfully');
                                          } else {
                                            print('Failed to confirm the draft: ${response.message}');
                                          }
                                        } catch (e) {
                                          print('Error posting: $e userid nya $userId');
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations(globalLanguage).translate("confirm"),
                                        style: const TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.bold)
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                              child: Text(
                                AppLocalizations(globalLanguage).translate("postdraft"),
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
                      const SizedBox(height: 30),
                    ]
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class MyData {
  final String? lokasi;
  final String? noLot;
  final String? namaBarang;
  final String? merk;
  final String? stock;
  final String? unit;
  final String? status;


  MyData({required this.lokasi, required this.noLot, required this.namaBarang, required this.merk, required this.stock, required this.unit, required this.status});
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

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.lokasi ?? "",
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
              entry.noLot ?? "",
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
              entry.namaBarang ?? "",
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
              entry.merk ?? "",
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
              entry.stock ?? "",
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
              entry.unit ?? "",
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
              entry.status == AppLocalizations(globalLanguage).translate("posted")
                ? AppLocalizations(globalLanguage).translate("confirm")
                : AppLocalizations(globalLanguage).translate("draft"),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: entry.status == AppLocalizations(globalLanguage).translate("posted")
                  ? Colors.green
                  : Colors.orange,
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
  const CardTable({Key? key}) : super(key: key);

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  List<MyData> _data = [];
  bool _isLoading = false;

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

      final response = await StockOpnameController.viewData(lokasi: '', noLot: '', namaBarang: '', merk: '', stock: '', unit: '', status:'');

      final List<dynamic> nameDataList = response.data;

      final List<MyData> myDataList = nameDataList.map((data) {
        String lokasi = data['Lokasi'] ?? "";
        String noLot = data['NoLot'] ?? "";
        String namaBarang = data['NamaBarang'] ?? "";
        String merk = data['Merk'] ?? "";
        String stock = data['Stock'] ?? "";
        String unit = data['Unit'] ?? "";
        String status = data['Status'] ?? "";

        return MyData(
          lokasi: lokasi,
          noLot: noLot,
          namaBarang: namaBarang,
          merk: merk,
          stock: stock,
          unit: unit,
          status: status,
        );
      }).toList();

      setState(() {
        _data = myDataList.where((data) {
          return (data.lokasi?.toLowerCase() ?? "").contains(_searchResult.toLowerCase()) ||
            (data.noLot?.toLowerCase() ?? "").contains(_searchResult.toLowerCase()) ||
            (data.merk?.toLowerCase() ?? "").contains(_searchResult.toLowerCase());
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 16),
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
                        hintText: '${AppLocalizations(globalLanguage).translate("search")}...',
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
                onTap: () {
                  if (globalBarcodeBarangResults.isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StockLokasiScan(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StockLokasiPage(),
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
                      style: TextStyle( fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.mainGreen),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : _data.isEmpty
                        ? const EmptyData()
                        : PaginatedDataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("location"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("lotnumber"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("namabarang"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                               DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("merk"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                               DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("stock"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                               DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("unit"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("status"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                            ],
                            source: MyDataTableSource(_data),
                            rowsPerPage: 5,
                          ),
              ],
            ),
          ),
        ),
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
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/monitoring.png',
                  width: 30,
                  height: 30,
                  color: AppColors.deepGreen,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    AppLocalizations(globalLanguage).translate("noDataa"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}