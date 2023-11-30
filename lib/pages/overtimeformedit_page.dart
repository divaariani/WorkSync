import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'overtimelist_page.dart';
import '../utils/session_manager.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../controllers/overtime_controller.dart';

class OvertimeEditFormPage extends StatefulWidget {
  final Map<String, dynamic> overtimeData;

  const OvertimeEditFormPage({Key? key, required this.overtimeData}) : super(key: key);

  @override
  State<OvertimeEditFormPage> createState() => _OvertimeEditFormPageState();
}

class _OvertimeEditFormPageState extends State<OvertimeEditFormPage> {
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    startDateController = TextEditingController(text: widget.overtimeData['Ovt_Date_Start'].substring(0, 16));
    endDateController = TextEditingController(text: widget.overtimeData['Ovt_Date_End'].substring(0, 16));
    noteController = TextEditingController(text: widget.overtimeData['Ovt_Noted']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations(globalLanguage).translate("Edit Overtime"),
            style: const TextStyle(
              color: AppColors.deepGreen, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const OvertimeListPage(),
                ),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations(globalLanguage).translate("Start Overtime"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: startDateController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset('assets/fill.png', height: 24, width: 24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("End Overtime"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: endDateController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset('assets/fill.png', height: 24, width: 24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("remark"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: noteController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset('assets/fill.png', height: 24, width: 24),
                          ],
                        ),
                      ),
                    ),
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
                            updateOvertime();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                            child: Text(
                              AppLocalizations(globalLanguage).translate("Save"),
                              style: const TextStyle(
                                color: AppColors.deepGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      );
  }

  void updateOvertime() async {
    String startDate = startDateController.text;
    String endDate = endDateController.text;
    String note = noteController.text;

    try {
      await OvertimeController().postOvertimeEdit(
        widget.overtimeData['Ovt_Id'],
        SessionManager().noAbsen ?? '',
        DateTime.parse(startDate),
        DateTime.parse(endDate),
        note,
      );

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'Your overtime edited successfully',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OvertimeListPage(),
        ),
      );
    } catch (error) {
      print('Error updating overtime: $error');
    }
  }
}
