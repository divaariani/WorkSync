import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'home_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../controllers/overtime_controller.dart';
import '../service/approve_list_leave_model.dart';
import '../service/approval_leave_service.dart';
import '../service/approve_list_leave_service.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchLeaveControllerr = TextEditingController();
  late OvertimeController overtimeController;
  String currentDate = "";
  int overtimeCount = 0;
  int leaveCount = 0;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag()).format(DateTime.now());
    overtimeController = OvertimeController();
    _fetchOvertimeData();
    _fetchApprovedLeaveData();
  }

  final TextEditingController searchControllerr = TextEditingController();
  
  List<DatumApproveListLeave> approvedLeave = [];
  String formatLanguageFulllDate(DateTime date) {
    return DateFormat('E, d MMM yyyy', 'id_ID').format(date);
  }

  Future<void> _handleApproval(String attLeaveId, int nstatrecord) async {
    final service = ApiApproveLeave();
    await service.approveData(attLeaveId, nstatrecord);

    approvedLeave.removeWhere((leave) => leave.attLeaveId == attLeaveId);
    setState(() {});
  }

  Future<void> _fetchApprovedLeaveData() async {
    ApprovedListLeaveService service = ApprovedListLeaveService();
    final result = await service.fetchData();
    setState(() {
      approvedLeave = result.data;
      _updateLeaveCount();
    });
    
  }

  Future<void> _fetchOvertimeData() async {
    final String? noAbsen = SessionManager().getNoAbsen();
    try {
      final List<OvertimeData> overtimeDataList = await overtimeController.fetchData(noAbsen);
      setState(() {
        overtimeCount = overtimeDataList.length;
      });
    } catch (error) {
      print('Error fetching overtime data: $error');
    }
  }

  void _updateLeaveCount() {
    leaveCount = approvedLeave.length;
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
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("approvals"),
            style: TextStyle(
              color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, AppColors.lightGreen],
                ),
              ),
            ),
            TabContainer(
                  color: AppColors.lightGreen,
                  tabs: [
                    '${AppLocalizations(globalLanguage).translate("overtime")} ($overtimeCount)',
                    '${AppLocalizations(globalLanguage).translate("leave")} ($leaveCount)',
                  ],
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (query) {
                              setState(() {
                                // Trigger a search query
                              });
                            },
                            decoration: InputDecoration(
                              hintText: '${AppLocalizations(globalLanguage).translate("search")}...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<OvertimeData>>(
                          future: OvertimeController().futureData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                            } else if (snapshot.hasError) {
                              return Center(child: Text(AppLocalizations(globalLanguage).translate("noDataa"),));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text(AppLocalizations(globalLanguage).translate("noDataa"),));
                            } else {
                              List<OvertimeData> overtimeList = snapshot.data ?? [];

                              if (searchController.text.isNotEmpty) {
                                final String query = searchController.text.toLowerCase();
                                overtimeList = overtimeList.where((data) {
                                  return data.employeeName.toLowerCase().contains(query) ||
                                      formatLanguageFullDate(data.ovtDateStart).toLowerCase().contains(query) ||
                                      formatLanguageFullDate(data.ovtDateEnd).toLowerCase().contains(query) ||
                                      data.ovtNoted.toLowerCase().contains(query);
                                }).toList();
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ListView.builder(
                                  itemCount: overtimeList.length,
                                  itemBuilder: (context, index) {
                                    final OvertimeData data = overtimeList[index];

                                    return Column(children: [
                                      if (index == 0) const SizedBox(height: 16),
                                      Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("name"),
                                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("from"),
                                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("until"),
                                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("remark"),
                                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(data.employeeName),
                                                      const SizedBox(height: 5),
                                                      Text(formatLanguageFullDate(data.ovtDateStart)),
                                                      const SizedBox(height: 5),
                                                      Text(formatLanguageFullDate(data.ovtDateEnd)),
                                                      const SizedBox(height: 5),
                                                      Wrap(
                                                        spacing: 8,
                                                        children: [
                                                          Text(
                                                            data.ovtNoted,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => 
                                                          AlertDialog(
                                                            backgroundColor: AppColors.mainGrey,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            content: Text(AppLocalizations(globalLanguage).translate("rejectMakeSure")),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text(
                                                                  AppLocalizations(globalLanguage).translate("cancel"),
                                                                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                                              ),
                                                              TextButton(
                                                                onPressed: () async {
                                                                  try {
                                                                    await overtimeController.postRejectOvertime(data.ovtId.toString());

                                                                    setState(() {
                                                                      OvertimeController().futureData = OvertimeController().fetchData(SessionManager().getNoAbsen());
                                                                    });

                                                                    final snackBar = SnackBar(
                                                                      elevation: 0,
                                                                      behavior: SnackBarBehavior.floating,
                                                                      backgroundColor: Colors.transparent,
                                                                      content: AwesomeSnackbarContent(
                                                                        title: AppLocalizations(globalLanguage).translate("rejected"),
                                                                        message: AppLocalizations(globalLanguage).translate("rejectOvertime"),
                                                                        contentType: ContentType.success,
                                                                      ),
                                                                    );

                                                                    ScaffoldMessenger.of(context)
                                                                      ..hideCurrentSnackBar()
                                                                      ..showSnackBar(snackBar);

                                                                    Navigator.of(context).push(
                                                                      MaterialPageRoute(
                                                                        builder: (context) => const ApprovalsPage(),
                                                                      ),
                                                                    );
                                                                  } catch (error) {
                                                                    print('Error rejecting overtime: $error');
                                                                  }
                                                                },
                                                                child: Text(
                                                                  AppLocalizations(globalLanguage).translate("yes"),
                                                                  style: const TextStyle(color: Color(0xFFBC5757), fontWeight: FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              AppColors.mainGrey,
                                                              Color(0xFFBC5757)
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.4),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: const Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          AppLocalizations(globalLanguage).translate("reject"),
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        try {
                                                          await OvertimeController().postApproveOvertime(data.ovtId.toString());
                                                          setState(() {
                                                            OvertimeController().futureData = OvertimeController().fetchData(SessionManager().getNoAbsen());
                                                          });

                                                          final snackBar = SnackBar(
                                                            elevation: 0,
                                                            behavior: SnackBarBehavior.floating,
                                                            backgroundColor: Colors.transparent,
                                                            content: AwesomeSnackbarContent(
                                                              title: AppLocalizations(globalLanguage).translate("approved"),
                                                              message: AppLocalizations(globalLanguage).translate("approveOvertime"),
                                                              contentType: ContentType.success,
                                                            ),
                                                          );

                                                          ScaffoldMessenger.of(context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(snackBar);

                                                          Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ApprovalsPage(),
                                                            ),
                                                          );
                                                        } catch (error) {
                                                          print('Error approving overtime: $error');
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              Colors.white,
                                                              AppColors.lightGreen
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: const Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          AppLocalizations(globalLanguage).translate("approve"),
                                                          style: const TextStyle(
                                                            color: AppColors.deepGreen,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (index == snapshot.data!.length - 1) const SizedBox(height: 16),
                                    ]);
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ]),
                    // divider tab
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: searchControllerr,
                                onChanged: (query) {
                                  setState(() {
                                    // Trigger a rebuild with the updated search query
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
                          FutureBuilder<ApproveListLeaveModel>(
                            future: ApprovedListLeaveService().fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                );
                              } else if (snapshot.hasError) {
                                return Text(AppLocalizations(globalLanguage).translate("noDataa"),);
                              } else {
                                List<DatumApproveListLeave> approvedLeave = snapshot.data?.data ?? [];

                                if (searchControllerr.text.isNotEmpty) {
                                  final String query = searchControllerr.text.toLowerCase();
                                  approvedLeave = approvedLeave.where((leave) {
                                    return leave.actionStatusPost.toLowerCase().contains(query) ||
                                        (query == 'requested' && leave.actionStatusPost.toLowerCase() == 'open/draft') ||
                                        (query == 'approved' && leave.actionStatusPost.toLowerCase() == 'manager signed') ||
                                        formatLanguageFulllDate(leave.tglAjuan).toLowerCase().contains(query) ||
                                        formatLanguageFulllDate(leave.dari).toLowerCase().contains(query) ||
                                        leave.namaKaryawan.toLowerCase().contains(query) ||
                                        leave.leaveDesc.toLowerCase().contains(query);
                                  }).toList();
                                }

                                return Expanded(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 16),
                                    itemCount: approvedLeave.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        margin: EdgeInsets.zero,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat('E, d MMM yyyy', 'id_ID').format(approvedLeave[index].tglAjuan),
                                                  ),
                                                ]
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("name"),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("from"),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("until"),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("leaveType"),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("remark"),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                      SizedBox(height: 5),
                                                      Text(':'),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(approvedLeave[index].namaKaryawan),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        DateFormat('E, d MMM yyyy', 'id_ID').format(approvedLeave[index].dari),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        DateFormat(
                                                                'E, d MMM yyyy', 'id_ID')
                                                            .format(approvedLeave[index]
                                                                .sampai),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(approvedLeave[index].leaveDesc),
                                                      const SizedBox(height: 5),
                                                      Text(approvedLeave[index].attLeaveNote),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        AppLocalizations(globalLanguage).translate("attachment"),
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  const Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(':'),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                content: Container(
                                                                  child: Image.network(
                                                                    approvedLeave[index].attachment!, 
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                          print(approvedLeave[index].attachment);
                                                        },
                                                        child: Text(
                                                          AppLocalizations(globalLanguage).translate("viewPhoto"),
                                                            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => 
                                                          AlertDialog(
                                                            backgroundColor: AppColors.mainGrey,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            content: Text(AppLocalizations(globalLanguage).translate("rejectMakeSure")),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text(
                                                                  AppLocalizations(globalLanguage).translate("cancel"),
                                                                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                                                              ),
                                                              TextButton(
                                                                onPressed: () async {
                                                                  await _handleApproval(approvedLeave[index].attLeaveId, 22); 
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text(
                                                                  AppLocalizations(globalLanguage).translate("yes"),
                                                                  style: const TextStyle(color: Color(0xFFBC5757), fontWeight: FontWeight.bold)),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              AppColors.mainGrey,
                                                              Color(0xFFBC5757)
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.4),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: const Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          AppLocalizations(globalLanguage).translate("reject"),
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await _handleApproval(approvedLeave[index].attLeaveId, 11); 
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              Colors.white,
                                                              AppColors.lightGreen
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.5),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: const Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          AppLocalizations(globalLanguage).translate("approve"),
                                                          style: const TextStyle(
                                                            color: AppColors.deepGreen,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
          ],
        ),
      )
    );
  }

  String formatLanguageFullDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate = DateFormat('dd MMM yyyy [HH:mm]', globalLanguage.toLanguageTag()).format(dateTime);
    return formattedDate;
  }
}