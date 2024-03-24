import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_leave_form_page.dart';
import 'home_page.dart';
import 'app_colors.dart';
import 'leave_form_page.dart';
import '../service/leave_list_service.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../service/leave_list_model.dart';

class LeaveListPage extends StatefulWidget {
  const LeaveListPage({Key? key}) : super(key: key);

  @override
  State<LeaveListPage> createState() => _LeaveListPageState();
}

class _LeaveListPageState extends State<LeaveListPage> {
  List<DatumLeaveList> leaveList = [];
  final TextEditingController searchController = TextEditingController();

  String currentDate = "";

  String formatLanguageFullDate(DateTime date) {
    return DateFormat('E, d MMM yyyy', 'id_ID').format(date);
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    LeaveListService service = LeaveListService();
    final result = await service.fetchData();
    currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    if (mounted) {
      setState(() {
        leaveList = result.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("leaveList"),
            style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,),
          ),
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 1)),
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
          const SizedBox(height: 80),
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
                      controller: searchController,
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
                FutureBuilder<LeaveListModel>(
                  future: LeaveListService().fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      List<DatumLeaveList> leaveList =
                          snapshot.data?.data ?? [];

                      if (searchController.text.isNotEmpty) {
                        final String query =
                            searchController.text.toLowerCase();
                        leaveList = leaveList.where((leave) {
                          return leave.status.toLowerCase().contains(query) ||
                              (query == 'requested' &&
                                  leave.status.toLowerCase() == 'open/draft') ||
                              (query == 'approved' &&
                                  leave.status.toLowerCase() ==
                                      'manager signed') ||
                              leave.keterangan.toLowerCase().contains(query) ||
                              formatLanguageFullDate(leave.dari)
                                  .toLowerCase()
                                  .contains(query) ||
                              formatLanguageFullDate(leave.sampai)
                                  .toLowerCase()
                                  .contains(query);
                        }).toList();
                      }

                      return Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 80),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemCount: leaveList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 16, bottom: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          currentDate,
                                          style: const TextStyle(
                                            color: AppColors.deepGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            if (leaveList[index].status ==
                                                "Open/Draft") {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditLeaveFormPage(
                                                    data: leaveList[index],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: getStatusColor(
                                                    leaveList[index].status),
                                                width: 1,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                getStatusLeave(leaveList[index].status),
                                                style: TextStyle(
                                                  color: getStatusColor(leaveList[index].status),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        if (leaveList[index].status == "Open/Draft")
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                  EditLeaveFormPage(
                                                    data: leaveList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/fill.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations(globalLanguage).translate("from"),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              AppLocalizations(globalLanguage).translate("until"),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              AppLocalizations(globalLanguage).translate("remark"),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
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
                                            Text(
                                              DateFormat('E, d MMM yyyy', 'id_ID').format(leaveList[index].dari),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              DateFormat('E, d MMM yyyy', 'id_ID').format(leaveList[index].sampai),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              leaveList[index].keterangan,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
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
          Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
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
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LeaveFormPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                      child: Text(
                        AppLocalizations(globalLanguage).translate("addLeave"),
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
            ),
        ],
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Manager Signed":
      return Colors.green;
    case "Rejected (Ditolak)":
      return Colors.red;
    case "Open/Draft":
      return Colors.orange;
    default:
      return Colors.black; 
  }
}

String getStatusLeave(String status){
  switch (status) {
    case "Manager Signed":
      return AppLocalizations(globalLanguage).translate("approved");
    case "Rejected (Ditolak)":
      return AppLocalizations(globalLanguage).translate("rejected");
    case "Open/Draft":
      return AppLocalizations(globalLanguage).translate("requested");
    default:
      return ''; 
  }
}