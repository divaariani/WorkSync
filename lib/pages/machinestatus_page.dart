import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'machineoperatorscan_page.dart';
import '../controllers/machine_controller.dart';
import '../controllers/response_model.dart';
import '../utils/session_manager.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../utils/notifications.dart';

class MachineStatusPage extends StatefulWidget {
  const MachineStatusPage({Key? key}) : super(key: key);

  @override
  State<MachineStatusPage> createState() => _MachineStatusPageState();
}

class _MachineStatusPageState extends State<MachineStatusPage> {
  final SessionManager sessionManager = SessionManager();
  late DateTime currentTime;
  List<MyData> mydata = [];
  
  Future<void> fetchCurrentTime() async {
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
      final response = await MachineController.postFormOperator(
        id: 1,
        name: '',
        userId: 1,
        namaoperator: '',
        statusmesin: '',
      );

      final List<dynamic> nameDataList = response.data;

      final List<MyData> myDataList = nameDataList.map((data) {
        return MyData(
          id: data['id'] ?? '',
          mesin: data['name'] ?? '',
          operator: data['namaoperator'] ?? '',
          aksi: '',
          status: data['statusmesin'] ?? '',
        );
      }).toList();

      setState(() {
        mydata = myDataList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
    currentTime = DateTime.now();
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
            AppLocalizations(globalLanguage).translate("machineStatus"),
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
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: 360,
              height: 800,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.deepGreen, AppColors.lightGreen],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CardTable(data: mydata),
                    const SizedBox(height: 30),
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
  final String id;
  final String aksi;
  final String mesin;
  final String operator;
  final String status;

  MyData({
    required this.id,
    required this.aksi,
    required this.mesin,
    required this.operator,
    required this.status,
  });
}

class MyDataTableSource extends DataTableSource {
  final List<MyData> data;
  final BuildContext parentContext;
  MyDataTableSource(this.data, this.parentContext);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final entry = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(AksiCellWidget(
          parentContext: parentContext,
          entry: entry,
        )),
        DataCell(Text(
          entry.mesin,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )),
        DataCell(Text(
          entry.operator,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )),
        DataCell(Text(
          entry.status,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;

  void updateData(List<MyData> newData) {
    data.clear();
    data.addAll(newData);
  }
}

class CardTable extends StatefulWidget {
  final List<MyData> data;

  const CardTable({Key? key, required this.data}) : super(key: key);

  @override
  State<CardTable> createState() => _CardTableState();
}

class _CardTableState extends State<CardTable> {
  TextEditingController controller = TextEditingController();
  String searchResult = '';
  List<MyData> _data = [];

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await MachineController.postFormOperator(
        id: 1,
        name: '',
        userId: 1,
        namaoperator: '',
        statusmesin: '',
      );

      final List<dynamic> nameDataList = response.data;
      print('API Response: $nameDataList');

      final List<MyData> myDataList = nameDataList.map((data) {
        return MyData(
          id: data['id'] ?? '',
          mesin: data['name'] ?? '',
          operator: data['namaoperator'] ?? '',
          aksi: '',
          status: data['statusmesin'] ?? '',
        );
      }).toList();

      setState(() {
        _data = myDataList.where((data) {
          return data.mesin.toLowerCase().contains(searchResult.toLowerCase()) ||
              data.operator.toLowerCase().contains(searchResult.toLowerCase()) ||
              data.status.toLowerCase().contains(searchResult.toLowerCase());
        }).toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(Icons.search, color: globalTheme == 'Light Theme' ? Colors.black : Colors.white),
              title: TextField(
                style: TextStyle(color: globalTheme == 'Light Theme' ? Colors.black : Colors.white),
                cursorColor: globalTheme == 'Light Theme' ? Colors.black : Colors.white,
                controller: controller,
                decoration: InputDecoration(
                  hintText: '${AppLocalizations(globalLanguage).translate("search")}...',
                  hintStyle: TextStyle(color: globalTheme == 'Light Theme' ? Colors.black : Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchResult = value;
                    fetchDataFromAPI();
                  });
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.cancel, color: globalTheme == 'Light Theme' ? Colors.black : Colors.white),
                onPressed: () {
                  setState(() {
                    controller.clear();
                    searchResult = '';
                    fetchDataFromAPI();
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: PaginatedDataTable(
              columns: [
                DataColumn(
                  label: Flexible(
                    child: Text(
                      AppLocalizations(globalLanguage).translate("action"),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Text(
                      AppLocalizations(globalLanguage).translate("machine"),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Text(
                      AppLocalizations(globalLanguage).translate("operator"),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Text(
                      AppLocalizations(globalLanguage).translate("status"),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
              source: MyDataTableSource(_data, context),
              rowsPerPage: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class AksiCellWidget extends StatefulWidget {
  final BuildContext parentContext;
  final MyData entry;
  const AksiCellWidget({Key? key, required this.parentContext, required this.entry}) : super(key: key);

  @override
  State<AksiCellWidget> createState() => _AksiCellWidgetState();
}

class _AksiCellWidgetState extends State<AksiCellWidget> {
  late DateTime currentTime;
  final SessionManager sessionManager = SessionManager();
  final stateController = TextEditingController();
  final idController = TextEditingController();
  String userIdLogin = "";
  String userName = '';

  Future<void> fetchUserId() async {
    userIdLogin = await sessionManager.getUserId() ?? "";
    userName = await sessionManager.getNamaUser() ?? "";
    setState(() {});
  }

  Future<void> fetchCurrentTime() async {
    try {
      setState(() {
        currentTime = DateTime.now();
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    fetchUserId();
  }

  Future<void> _submitState() async {
    final int id = int.parse(idController.text);
    final String state = stateController.text;

    try {
      await fetchCurrentTime();

      ResponseModel response = await MachineController.postFormMachineState(
        id: id,
        state: state,
        timestate: currentTime.toString(),
      );

      if (response.status == 1) {
        final machineName = widget.entry.mesin;

        if (state == "Start") {
          NotificationManager().showNotification(title: 'Started !', body: 'Mesin $machineName');
        } else if (state == "Pause (Naik WIP)") {
          NotificationManager().showNotification(title: 'Paused !', body: 'Mesin $machineName (Naik WIP)');
        } else if (state == "Pause (Naik Bobin)") {
          NotificationManager().showNotification(title: 'Paused !', body: 'Mesin $machineName (Naik Bobin)');
        } else if (state == "Pause (Setup Mesin)") {
          NotificationManager().showNotification(title: 'Paused !', body: 'Mesin $machineName (Setup Mesin)');
        } else if (state == "Pause (Pergi/Istirahat)") {
          NotificationManager().showNotification(title: 'Paused !', body: 'Mesin $machineName (Pergi/Istirahat)');
        } else if (state == "Pause (Lingkungan)") {
          NotificationManager().showNotification(title: 'Paused !', body: 'Mesin $machineName (Lingkungan)');
        } else if (state == "Block (Material Availability)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Material Availability)');
        } else if (state == "Block (Equiment Failure)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Equiment Failure)');
        } else if (state == "Block (Setup Adjustments)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Setup Adjustments)');
        } else if (state == "Block (Reduced Speed)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Reduced Speed)');
        } else if (state == "Block (Process Defect)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Process Defect)');
        } else if (state == "Block (Reduced Yield)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Reduced Yield)');
        } else if (state == "Block (Fully Productive Time)") {
          NotificationManager().showNotification(title: 'Blocked !', body: 'Mesin $machineName (Fully Productive Time)');
        } else if (state == "End") {
          NotificationManager().showNotification(title: 'Ended !', body: 'Mesin $machineName');
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MachineStatusPage()
          )
        );
      } else if (response.status == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah status mesin !'),
          ),
        );
      } else {
        debugPrint('Terjadi kesalahan: Response tidak valid.');
      }
    } catch (e) {
      debugPrint('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              final id = widget.entry.id;
              idController.text = id;
              stateController.text = "Start";

              if(widget.entry.operator.isEmpty || widget.entry.operator != userName) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 16, right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations(globalLanguage).translate("machineCodeRequire"),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.mainGreen),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _submitState(); 
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:AppColors.grey,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations(globalLanguage).translate("startAnyway"),
                                    style: const TextStyle(color: AppColors.mainGreen),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MachineOperatorScanPage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainGreen,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations(globalLanguage).translate("scan"),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                _submitState();
              }
            },
            child: Image.asset(
              'assets/icon.start.png',
              height: 25,
              width: 25,
            ),
          ),
          const SizedBox(width: 10, height: 10),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: AppColors.mainGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Pause',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Pause (Naik WIP)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Naik WIP',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Pause (Setup Mesin)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Set Up Mesin',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Pause (Naik Bobin)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Naik Bobin',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Pause (Pergi/Istirahat)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Pergi/Istirahat',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Pause (Lingkungan)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Lingkungan',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).then((value) {
                if (value != null) {
                  print(value);
                }
              });
            },
            child: Image.asset(
              'assets/icon.pause.png',
              height: 25,
              width: 25,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: AppColors.mainGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Blocked',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Material Availability)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Material Availability',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Equiment Failure)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Equipment Failure',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Setup Adjustments)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Setup and Adjustments',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Reduced Speed)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Reduced Speed',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Process Defect)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Process Defect',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Reduced Yield)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Reduced Yield',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.grey,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  final id = widget.entry.id;
                                  idController.text = id;
                                  stateController.text = "Block (Fully Productive Time)";
                                  _submitState();
                                },
                                child: const Text(
                                  'Fully Productive Time',
                                  style: TextStyle(
                                    color: AppColors.mainGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).then((value) {
                if (value != null) {
                  print(value);
                }
              });
            },
            child: Image.asset(
              'assets/icon.block.png',
              height: 25,
              width: 25,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              final id = widget.entry.id;
              idController.text = id;
              stateController.text = "End";
              _submitState();
            },
            child: Image.asset(
              'assets/icon.end.png',
              height: 25,
              width: 25,
            ),
          ),
        ],
      ),
    );
  }
}