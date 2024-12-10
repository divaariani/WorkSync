import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'cablescan_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../utils/empty_data.dart';
import '../controllers/cable_controller.dart';
import '../models/cable_model.dart';

class CablePage extends StatefulWidget {
  const CablePage({Key? key}) : super(key: key);

  @override
  State<CablePage> createState() => _CablePageState();
}

class _CablePageState extends State<CablePage> {
  final TextEditingController searchController = TextEditingController();
  String currentDate = "";
  String userId = '';

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag())
        .format(DateTime.now());
    userId = SessionManager().getUserId() ?? '';
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
            centerTitle: true,
            title: Text(
              AppLocalizations(globalLanguage).translate("Cable Picking"),
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
              const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(children: [
                    CardTable(),
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}

class CardTable extends StatefulWidget {
  const CardTable({Key? key}) : super(key: key);

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  List<CableData> _data = [];
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

      final response = await CableController.viewData();

      final List<dynamic> nameDataList = response.data;

      final List<CableData> myDataList = nameDataList.map((data) {
        return CableData(
            noKP: data['KP_No'] ?? "",
            dateKP: data['KP_Date'] ?? "",
            noLot: data['No_Lot'] ?? "",
            itemBarangProduksi: data['Item_Barang_Produksi'] ?? "",
            satuanPaking: data['SatuanPaking'],
            qty: data['Qty'],
            satuanStock: data['SatuanStock'],
            scanChecked: data['ScanChecked'],
            userScanChecked: data['UserScanChecked']);
      }).toList();

      setState(() {
        _data = myDataList.where((data) {
          return (data.noLot?.toLowerCase() ?? "")
                  .contains(_searchResult.toLowerCase()) ||
              (data.dateKP?.toLowerCase() ?? "")
                  .contains(_searchResult.toLowerCase()) ||
              (data.itemBarangProduksi?.toLowerCase() ?? "")
                  .contains(_searchResult.toLowerCase()) ||
              (data.satuanPaking?.toLowerCase() ?? "")
                  .contains(_searchResult.toLowerCase());
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
                        hintText:
                            '${AppLocalizations(globalLanguage).translate("search")}...',
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
                        builder: (context) => const CableScanPage(),
                      ),
                    );
                  } else {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const StockLokasiPage(),
                    //   ),
                    // );
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
                                  AppLocalizations(globalLanguage)
                                      .translate("lotnumber"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("KP Date"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("namabarang"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("stock"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("unit"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("status"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                            ],
                            source: CableTableSource(_data),
                            rowsPerPage: 10,
                          ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CableTableSource extends DataTableSource {
  final List<CableData> data;

  CableTableSource(this.data);

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
              entry.dateKP ?? "",
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
              entry.itemBarangProduksi ?? "",
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
              entry.qty ?? "",
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
              entry.satuanPaking ?? "",
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
              entry.scanChecked == "*"
                  ? AppLocalizations(globalLanguage).translate("draft")
                  : AppLocalizations(globalLanguage).translate("confirm"),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: entry.scanChecked == "*" ? Colors.orange : Colors.green,
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
