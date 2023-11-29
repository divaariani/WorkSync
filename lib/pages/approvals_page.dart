import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../controllers/overtime_controller.dart';
import '../controllers/approvedleavemodel_controller.dart';
import '../controllers/approvedleaveservice_controller.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  String currentDate = "";

  @override
  void initState() {
    super.initState();
    init();

    final now = DateTime.now();
    final formatter = DateFormat('dd MMM yyyy');
    currentDate = formatter.format(now);
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
        centerTitle: true,
        title: const Text(
          'Approvals',
          style: TextStyle(
            color: AppColors.deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.deepGreen),
            onPressed: () {
              // Search functionality here
            },
          ),
        ],
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
            tabs: const [
              'Overtime',
              'Leave',
            ],
            children: [
              FutureBuilder<List<OvertimeData>>(
                future: OvertimeController().futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('No data available'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final OvertimeData data = snapshot.data![index];
                          return Card(
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
                                      style: const TextStyle(color: AppColors.lightGreen)
                                    ),
                                    const Spacer(),
                                    Container(
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
                                      child: const Text(
                                        'Approve',
                                        style: TextStyle(
                                          color: AppColors.deepGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Text('From', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Text('Until', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Text('Remark', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                            Text(data.ovtDateStart),
                                            const SizedBox(height: 5),
                                            Text(data.ovtDateEnd),
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
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              // divider tab
              ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const SizedBox(height: 16),
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
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                DateFormat('E, d MMM yyyy', 'id_ID')
                                    .format(approvedLeave[index].tglAjuan),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // if (approvedLeave[index].status == "Add") {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const ApprovedLeavePage()),
                                  //   );
                                  // }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: approvedLeave[index]
                                                  .actionStatusPost ==
                                              "Open/Draft"
                                          ? Colors.green
                                          : Colors.blue,
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      approvedLeave[index].actionStatusPost,
                                      style: TextStyle(
                                        color: approvedLeave[index]
                                                    .actionStatusPost ==
                                                "Open/Draft"
                                            ? Colors.green
                                            : Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              if (approvedLeave[index].actionStatusPost == "Open/Draft")
                                GestureDetector(
                                  // onTap: () {
                                  //   Navigator.of(context).push(MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const LeaveFormPage()));
                                  // },
                                  child: Image.asset(
                                    'assets/ic-edit.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                )
                              else
                                Image.asset(
                                  'assets/ic-edit.png', 
                                  width: 30,
                                  height: 30,
                                  color: Colors.grey,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations(globalLanguage).translate("Name"),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppLocalizations(globalLanguage).translate("from"),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppLocalizations(globalLanguage).translate("to"),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppLocalizations(globalLanguage) .translate("Leave Type"),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    AppLocalizations(globalLanguage).translate("Leave Note"),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                                    DateFormat('E, d MMM yyyy', 'id_ID').format(approvedLeave[index].sampai),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(approvedLeave[index].leaveDesc),
                                  const SizedBox(height: 5),
                                  Text(approvedLeave[index].attLeaveNote),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
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
                            child: ElevatedButton(
                              onPressed: () async {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => const LeaveFormPage(),
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                AppLocalizations(globalLanguage).translate("Approved"),
                                style: const TextStyle(
                                  color: AppColors.deepGreen,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
