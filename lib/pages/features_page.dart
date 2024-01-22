import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:worksync/pages/warehouse_page.dart';
import 'app_colors.dart';
import 'approvals_page.dart';
import 'overtimelist_page.dart';
import 'leave_list_page.dart';
import 'checkpoint_page.dart';
import 'ticketing_page.dart';
import 'monitoringcheckpoint_page.dart';
import 'stockopname_page.dart';
import 'facerecognition_page.dart';
import 'faceregister_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../service/approve_list_leave_service.dart';
import '../service/approve_list_leave_model.dart';
import '../controllers/overtime_controller.dart';
import '../controllers/facerecognition_controller.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({Key? key}) : super(key: key);

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  late OvertimeController overtimeController;
  late FaceRecognitionController faceRecognitionController;
  List<DatumApproveListLeave> approvedLeave = [];
  int overtimeCount = 0;
  int leaveCount = 0;
  String? actorAttendance = '';
  String? actorOvertime = '';
  String? actorLeave = '';
  String? actorApprovalLeave = '';
  String? actorApprovalOvertime = '';
  String? actorCheckpoint = '';
  String? actorTicketing = '';
  String? actorMonitoring = '';
  String? actorAuditor= '';
  String? actorWarehouse= '';

  @override
  void initState() {
    super.initState();
    overtimeController = OvertimeController();
    faceRecognitionController = FaceRecognitionController();

    SessionManager sessionManager = SessionManager();
    actorAttendance = sessionManager.getActorAttendance();
    actorOvertime = sessionManager.getActorOvertime();
    actorLeave = sessionManager.getActorLeave();
    actorApprovalLeave = sessionManager.getActorApproveLeave();
    actorApprovalOvertime = sessionManager.getActorApproveOvertime();
    actorCheckpoint = sessionManager.getActorCheckpoint();
    actorTicketing = sessionManager.getActorTicketing();
    actorMonitoring = sessionManager.getActorMonitoring();
    actorAuditor= sessionManager.getActorAuditor();
    actorWarehouse = sessionManager.getActorWarehouse();

    fetchOvertimeData();
    fetchApprovedLeaveData();
    checkFaceCode;
  }

  Future<void> fetchApprovedLeaveData() async {
    ApprovedListLeaveService service = ApprovedListLeaveService();
    final result = await service.fetchData();
    setState(() {
      approvedLeave = result.data;
      _updateLeaveCount();
    });
  }

  Future<void> fetchOvertimeData() async {
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

  void checkFaceCode() async {
    try {
      List<FaceRecognitionData> faceRecognitionList = await faceRecognitionController.getFaceRecognition();

      bool faceCodeNotFound = faceRecognitionList.any((data) => data.kodeFace == AppLocalizations(globalLanguage).translate("notRegistered"));
      bool faceCodeTwoRegistered = faceRecognitionList.length == 2;
      bool faceCodeOneRegistered = faceRecognitionList.length == 1;

      if (faceCodeNotFound) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("notRegistered"),
            message: AppLocalizations(globalLanguage).translate("notRegistered3More"),
            contentType: ContentType.warning,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRegisterPage(),
          ),
        );
      } else if (faceCodeOneRegistered) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("registerAgain"),
            message: AppLocalizations(globalLanguage).translate("register2More"),
            contentType: ContentType.warning,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRegisterPage(),
          ),
        );
      } else if (faceCodeTwoRegistered) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: AppLocalizations(globalLanguage).translate("registerAgain"),
            message: AppLocalizations(globalLanguage).translate("register1More"),
            contentType: ContentType.warning,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FaceRegisterPage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations(globalLanguage).translate("attention"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepGreen,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      AppLocalizations(globalLanguage).translate("makeSureLocation"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      AppLocalizations(globalLanguage).translate("makeSureCamera"),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                      AppLocalizations(globalLanguage).translate("cancel"),
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FaceRecognitionPage(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations(globalLanguage).translate("yes"),
                      style: const TextStyle(
                          color: AppColors.mainGreen,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: globalTheme == 'Light Theme' ? Colors.white : Colors.black
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  AppLocalizations(globalLanguage).translate("features"),
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: globalTheme == 'Light Theme' ? Colors.black : Colors.white
                  )
                ),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: actorAttendance == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/attendancefeature.png',
                  title: AppLocalizations(globalLanguage).translate("attendanceTitle"),
                  onTap: () {
                    if (actorAttendance == '1') {
                      checkFaceCode();
                    } else {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: AppLocalizations(globalLanguage).translate("attendanceFeature"),
                          message: AppLocalizations(globalLanguage).translate("featureWarning"),
                          contentType: ContentType.warning,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                ),
                CardItem(
                  color: actorOvertime == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/overtime.png',
                  title: AppLocalizations(globalLanguage).translate("overtime"),
                  onTap: () {
                    if (actorOvertime == '1') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OvertimeListPage(),
                        ),
                      );
                    } else {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: AppLocalizations(globalLanguage).translate("overtimeFeature"),
                          message: AppLocalizations(globalLanguage).translate("featureWarning"),
                          contentType: ContentType.warning,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                ),
                CardItem(
                  color: actorLeave == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/leave.png',
                  title: AppLocalizations(globalLanguage).translate("leave"),
                  onTap: () {
                    if (actorLeave == '1') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LeaveListPage(),
                        ),
                      );
                    } else {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: AppLocalizations(globalLanguage).translate("leaveFeature"),
                          message: AppLocalizations(globalLanguage).translate("featureWarning"),
                          contentType: ContentType.warning,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                      color: actorApprovalLeave == '1' || actorApprovalOvertime == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                      imagePath: 'assets/approval.png',
                      title: AppLocalizations(globalLanguage).translate("approvals"),
                      onTap: () {
                        if (actorApprovalLeave == '1' || actorApprovalOvertime == '1') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ApprovalsPage(),
                            ),
                          );
                        } else {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: AppLocalizations(globalLanguage).translate("approvalFeature"),
                              message: AppLocalizations(globalLanguage).translate("featureWarning"),
                              contentType: ContentType.warning,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        } 
                      },
                      notificationCount: overtimeCount + leaveCount,
                    ),
                CardItem(
                  color: actorCheckpoint == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/checkpoint.png',
                  title: AppLocalizations(globalLanguage).translate("checkpoinTour"),
                  onTap: () {
                    if (actorCheckpoint == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckPointPage(
                          result: '', resultCheckpoint: globalBarcodeCheckpointResults
                        )),
                      );
                    } else {
                      final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: AppLocalizations(globalLanguage).translate("checkpointTourFeature"),
                            message: AppLocalizations(globalLanguage).translate("featureWarning"),
                            contentType: ContentType.warning,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                    } 
                  },
                ),
                CardItem(
                  color: actorMonitoring == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/monitoring.png',
                  title: AppLocalizations(globalLanguage).translate("monitoring"),
                  onTap: () {
                    if (actorMonitoring == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MonitoringCpPage()),
                      );
                    } else {
                      final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: AppLocalizations(globalLanguage).translate("monitoringFeature"),
                            message: AppLocalizations(globalLanguage).translate("featureWarning"),
                            contentType: ContentType.warning,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: actorTicketing == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/ticketing.png',
                  title: AppLocalizations(globalLanguage).translate("ticketing"),
                  onTap: () {
                    if (actorTicketing == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TicketingPage()),
                      );
                    } else {
                      final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: AppLocalizations(globalLanguage).translate("ticketingFeature"),
                            message: AppLocalizations(globalLanguage).translate("featureWarning"),
                            contentType: ContentType.warning,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                    } 
                  },
                ),
                CardItem(
                  color: actorAuditor == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/opname.png',
                  title: AppLocalizations(globalLanguage).translate("stockopname"),
                  onTap: () {
                    if (actorAuditor == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StockOpnamePage()),
                      );
                    } else {
                      final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: AppLocalizations(globalLanguage).translate("stockOpnameFeature"),
                            message: AppLocalizations(globalLanguage).translate("featureWarning"),
                            contentType: ContentType.warning,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                    }
                  },
                ),
                CardItem(
                  color: actorWarehouse == '1' ? AppColors.mainGreen : Colors.grey.withOpacity(0.5),
                  imagePath: 'assets/warehouse.png',
                  title: AppLocalizations(globalLanguage).translate("DO Picking"),
                  onTap: () {
                    if (actorWarehouse == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WarehousePage()),
                      );
                    } else {
                      final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: AppLocalizations(globalLanguage).translate("warehouseFeature"),
                            message: AppLocalizations(globalLanguage).translate("featureWarning"),
                            contentType: ContentType.warning,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
          ]),
        ))
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final double imageWidth;
  final double imageHeight;
  final int notificationCount; 
  final VoidCallback onTap;

  CardItem({
    required this.color,
    required this.imagePath,
    this.title = '',
    this.imageWidth = 70,
    this.imageHeight = 70,
    this.notificationCount = 0, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter, 
            children: [
              Container(
                width: 0.27 * MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Container(
                    width: imageWidth,
                    height: imageHeight,
                    child: Image.asset(imagePath),
                  ),
                ),
              ),
              if (notificationCount > 0) 
                Positioned(
                  top: 0,
                  right: 0, 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFBC5757), 
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}