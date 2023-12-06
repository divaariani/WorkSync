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
import '../service/leaveapproved_controller.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  final TextEditingController searchController = TextEditingController();
  String currentDate = "";

  @override
  void initState() {
    super.initState();
    init();

    currentDate = DateFormat.yMMMMd(globalLanguage.toLanguageTag()).format(DateTime.now());;
  }

  List<Datum> approvedLeave = [];

  Future<void> init() async {
    ApprovedLeaveService service = ApprovedLeaveService();
    final result = await service.fetchData();
    setState(() {
      approvedLeave = result.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage()
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("approvals"),
          style: const TextStyle(
            color: AppColors.deepGreen,
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
              AppLocalizations(globalLanguage).translate("overtime"),
              AppLocalizations(globalLanguage).translate("leave"),
            ],
            children: [
              Column(
                children: [
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
                            // Trigger a rebuild with the updated search query
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '${AppLocalizations(globalLanguage).translate("search")}...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                        return const Center(child: Text('No data available'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available'));
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

                              return Column(
                                children: [
                                  if (index == 0) const SizedBox(height: 16),
                                  Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Text(currentDate,
                                              style: const TextStyle(color: AppColors.mainGreen)
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                try {
                                                  await OvertimeController().postApproveOvertime(data.ovtId.toString());
                                                  setState(() {
                                                    OvertimeController().futureData = OvertimeController().fetchData(SessionManager().noAbsen);
                                                  });

                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.transparent,
                                                    content: AwesomeSnackbarContent(
                                                      title: 'Approved',
                                                      message: 'Successfully approve the overtime requested',
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
                                                  print('Error approving overtime: $error');
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [Colors.white, AppColors.lightGreen],
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
                                          ]),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(AppLocalizations(globalLanguage).translate("name"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("from"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("until"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("remark"), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                                )
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index == snapshot.data!.length - 1) const SizedBox(height: 16),
                                ]
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  )
                ]
              ),
              
              // divider tab
              // TAB LEAVE APPROVAL
            ],
          ),
        ],
      ),
    );
  }

  String formatLanguageFullDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate = DateFormat('dd MMM yyyy [HH:mm]', globalLanguage.toLanguageTag()).format(dateTime);
    return formattedDate;
  }
}
