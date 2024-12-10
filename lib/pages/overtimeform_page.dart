import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'overtimelist_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../controllers/overtime_controller.dart';

class OvertimeFormPage extends StatefulWidget {
  const OvertimeFormPage({Key? key}) : super(key: key);

  @override
  State<OvertimeFormPage> createState() => _OvertimeFormPageState();
}

class _OvertimeFormPageState extends State<OvertimeFormPage> {
  TextEditingController noteController = TextEditingController();
  String startDate = AppLocalizations(globalLanguage).translate("startTime");
  String endDate = AppLocalizations(globalLanguage).translate("endTime");

  Future<void> _selectDate(BuildContext context, String variableName) async {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    if (variableName == 'startDate') {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      ) ??
    DateTime.now();
    } else if (variableName == 'endDate') {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      ) ??
    DateTime.now();
    }

    selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ) ??
    TimeOfDay.now();

    final DateTime picked = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final formattedDate = DateFormat('dd MMM yyyy HH:mm').format(picked);

    setState(() {
      if (variableName == 'startDate') {
        startDate = formattedDate;
      } else if (variableName == 'endDate') {
        endDate = formattedDate;
      }
    });
  }

  void _snackbar(var snackBar) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _navigateToPage(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("overtime"),
            style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,),
          ),
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OvertimeListPage()
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
                      AppLocalizations(globalLanguage).translate("requestFor"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/useradd.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            Text(
                              //"diva", 
                              SessionManager().getNamaUser() ?? 'Unknown',
                              style: const TextStyle(color: AppColors.deepGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("start"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          _selectDate(context, 'startDate');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Image.asset('assets/calendar.png', width: 47.12, height: 46),
                              const Spacer(),
                              Text(
                                startDate,
                                style: const TextStyle(color: AppColors.deepGreen),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("end"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          _selectDate(context, 'endDate');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Image.asset('assets/calendar.png', width: 47.12, height: 46),
                              const Spacer(),
                              Text(
                                endDate,
                                style: const TextStyle(color: AppColors.deepGreen),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const Spacer(),
                            ],
                          ),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: noteController,
                                decoration: InputDecoration(
                                  hintText: '${AppLocalizations(globalLanguage).translate("remark")}...',
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
                          onTap: () async {
                            final DateTime startDateObj = DateFormat('dd MMM yyyy HH:mm').parse(startDate);
                            final DateTime endDateObj = DateFormat('dd MMM yyyy HH:mm').parse(endDate);

                            final String? noAbsen = SessionManager().getNoAbsen();

                            if (noAbsen != null) {
                              try {
                                await OvertimeController().postOvertime(
                                  noAbsen,
                                  startDateObj,
                                  endDateObj,
                                  noteController.text,
                                );
                              } catch (error) {
                                debugPrint('Error posting overtime: $noAbsen $error');

                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: AppLocalizations(globalLanguage).translate("overtimePosted"),
                                    message: AppLocalizations(globalLanguage).translate("overtimePostedDesc"),
                                    contentType: ContentType.success,
                                  ),
                                );

                                _snackbar(snackBar);
                                _navigateToPage(const OvertimeListPage());
                              }
                            } else {
                              debugPrint('No noAbsen available');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                            child: Text(
                              AppLocalizations(globalLanguage).translate("submit"),
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
}
