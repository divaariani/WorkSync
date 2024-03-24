import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'refresh_page.dart';
import 'reportadd_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../controllers/report_controller.dart';

class ReportPage extends StatefulWidget {
  final String? auditorData;

  const ReportPage({Key? key, this.auditorData}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController searchController = TextEditingController();
  String currentDate = "";
  String userId = '';
  String? userText;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag()).format(DateTime.now());
    userId = SessionManager().getUserId() ?? '';
    userText = widget.auditorData;
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
              AppLocalizations(globalLanguage).translate("Product Report"),
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
              const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CardTable(),
                      SizedBox(height: 20),
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
  final int? nomor_kp;
  final DateTime? tgl_kp;
  final int? userid;
  final String? dibuatoleh;
  final DateTime? dibuattgl;


  MyData({
    required this.nomor_kp,
    required this.tgl_kp,
    required this.userid,
    required this.dibuatoleh,
    required this.dibuattgl,
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

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.nomor_kp?.toString() ?? "",
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
              (entry.tgl_kp != null)
                  ? DateFormat('yyyy-MM-dd').format(entry.tgl_kp!)
                  : "",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // DataCell(
        //   Container(
        //     alignment: Alignment.centerLeft,
        //     child: Text(
        //       entry.dibuatoleh ?? "",
        //       style: const TextStyle(
        //         fontSize: 12,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.dibuattgl != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(entry.dibuattgl!)
                  : "",
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

      final response = await ReportController.postFormData(
        nomor_kp: 1,
        tgl_kp: DateTime.now(),
        userid: 1,
        dibuatoleh: '',
        dibuattgl: DateTime.now(),
      );

      final List<dynamic> nameDataList = response.data;

      final List<MyData> myDataList = nameDataList.map((data) {
        int nomor_kp = int.tryParse(data['nomor_kp'].toString()) ?? 0;
        DateTime tgl_kp = DateTime.parse(data['tgl_kp']);
        int userid = int.tryParse(data['userid'].toString()) ?? 0;
        String dibuatoleh = data['dibuatoleh'];
        DateTime dibuattgl = DateTime.parse(data['dibuattgl']);

        return MyData(
          nomor_kp: nomor_kp,
          tgl_kp: tgl_kp,
          userid: userid,
          dibuatoleh: dibuatoleh,
          dibuattgl: dibuattgl,
        );
      }).toList();

      setState(() {
        _data = myDataList.where((data) {
          return (data.nomor_kp?.toString() ?? "").contains(_searchResult.toLowerCase());
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
                    // trailing: IconButton(
                    //   icon: const Icon(Icons.cancel),
                    //   onPressed: () {
                    //     setState(() {
                    //       controller.clear();
                    //       _searchResult = '';
                    //       fetchDataFromAPI();
                    //     });
                    //   },
                    // ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportAddPage(result: '',
                    resultBarangQc: globalBarcodeBarangResults),
                  ),
                );
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
                                  AppLocalizations(globalLanguage).translate("Nomor KP"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("Tanggal KP"),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                  ),
                                ),
                              ),
                              // DataColumn(
                              //   label: Text(
                              //     AppLocalizations(globalLanguage).translate("Pembuat"),
                              //     style: const TextStyle(
                              //       fontSize: 12,
                              //       color: AppColors.deepGreen,
                              //     ),
                              //   ),
                              // ),
                               DataColumn(
                                label: Text(
                                  AppLocalizations(globalLanguage).translate("Tanggal"),
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
