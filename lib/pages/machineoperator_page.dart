import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'home_page.dart';
//import 'operatorstatus_view.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../utils/session_manager.dart';
import '../controllers/response_model.dart';
// import '../controllers/notification_controller.dart';
import '../controllers/machine_controller.dart';

class MachineOperatorPage extends StatefulWidget {
  final String barcodeMachineResult;

  const MachineOperatorPage({Key? key, required this.barcodeMachineResult}) : super(key: key);

  @override
  State<MachineOperatorPage> createState() => _MachineOperatorPageState();
}

class _MachineOperatorPageState extends State<MachineOperatorPage> {
  late DateTime currentTime;
  final SessionManager sessionManager = SessionManager();
  final SessionManager _sessionManager = SessionManager();
  final idwcController = TextEditingController();
  final tapController = TextEditingController();
  String userIdLogin = "";
  String userName = "";
  String barcodeMachineResult = globalBarcodeMesinResult;
  String _machineName = '';

  Future<void> fetchUserId() async {
    userIdLogin = await _sessionManager.getUserId() ?? "";
    userName = await _sessionManager.getNamaUser() ?? "";
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

  Future<void> fetchMachineData() async {
    try {
      final Map<String, dynamic> apiData = await MachineController.getWorkcenterList();
      final List<dynamic> dataList = apiData['data'];

      bool machineFound = false; 

      for (var item in dataList) {
        if (item['id'] == barcodeMachineResult.toString()) {
          _machineName = item['name'];
          machineFound = true; 
          break;
        }
      }

      if (!machineFound) {
        _machineName = "Machine not found";
      }

      setState(() {
        _machineName;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
    fetchMachineData();
    fetchCurrentTime();
    currentTime = DateTime.now();
    idwcController.text = barcodeMachineResult;
  }

  Future<void> _submitForm() async {
    final int idwc = int.parse(idwcController.text);
    final int userId = int.parse(userIdLogin);
    final String tap = tapController.text;
    final String date = DateFormat('yyyy-MM-dd HH:mm').format(currentTime);

    try {
      await fetchCurrentTime();

      ResponseModel response = await MachineController.postOperatorInOut(
        idwc: idwc,
        userId: userId,
        oprTap: currentTime.toString(),
        tap: tap,
      );

      if (response.status == 1) {
        if (tap == "I") {
          Get.snackbar('IN Mesin', 'Operator $userName');

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //       return OperatorStatusView();
          //     },
          //   ),
          // );
        } else if (tap == "O") {
          Get.snackbar('OUT Mesin', 'Operator $userName');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return HomePage();
              },
            ),
          );
        }
      } else if (response.status == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request gagal: ${response.message}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan: Response tidak valid.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
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
          AppLocalizations(globalLanguage).translate("Operator Attendance"),
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
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        height: 250,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/logo.png",
                                  width: 70,
                                  height: 70,
                                ),
                                const SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          image: const DecorationImage(
                                            image: AssetImage('assets/avatar.jpg'),
                                          ),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(
                                            color: AppColors.mainGreen,
                                            style: BorderStyle.solid,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: AppColors.mainGreen,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Machine: ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.mainGreen,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    _machineName,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal,
                                                      color: AppColors.mainGreen,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 100,
                            margin: const EdgeInsets.only(right: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                tapController.text = "I";
                                //_submitForm();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/in.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "IN",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.mainGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Image.asset(
                                                'assets/icon.warning.png',
                                                width: 70,
                                                height: 70,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Apakah Anda telah selesai menggunakan mesin?',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: AppColors.mainGreen,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.grey,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Tidak',
                                                    style: TextStyle(
                                                      color: AppColors.mainGreen,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    tapController.text = "O";
                                                    //_submitForm();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.mainGreen,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Ya',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
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
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/out.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "OUT",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.mainGreen,
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