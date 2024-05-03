import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'leavelist_page.dart';
import '../controllers/leave_controller.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../utils/session_manager.dart';
import '../utils/photos.dart';

class EditLeaveFormPage extends StatefulWidget {
  final LeaveData? data;
  final String? noAbsen = SessionManager().getNoAbsen();
  EditLeaveFormPage({Key? key, this.data}) : super(key: key);

  @override
  State<EditLeaveFormPage> createState() => _EditLeaveFormPageState();
}

class _EditLeaveFormPageState extends State<EditLeaveFormPage> {
  late String startDate = widget.data?.dari != null
      ? DateFormat('dd MMM yyyy').format(widget.data!.dari)
      : AppLocalizations(globalLanguage).translate("startTime");
  late String endDate = widget.data?.sampai != null
      ? DateFormat('dd MMM yyyy').format(widget.data!.sampai)
      : AppLocalizations(globalLanguage).translate("endTime");

  TextEditingController leavenoteController = TextEditingController();
  List<String> leaveTypes = [];
  String selectedType = '';
  String leavenote = "";

  String noAbsen = '';
  String attLeaveId = '';
  LeaveTypeData? previousSelectedLeaveType;

  CustomFile? pickedFile;
  String attachment = '';
  String file = AppLocalizations(globalLanguage).translate("addFile");

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = CustomFile(
          result.files.first.path ?? '', result.files.first.name);
          
    });
  }

  Future<void> uploadFile() async {
    if (pickedFile != null) {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        attachment = urlDownload;
      });
      
      print('Direct Image Link: $urlDownload');
    } else {
      print('No file selected');
    }
  }

  LeaveTypeData? selectedLeaveType;

  double uploadProgress = 0.0;

  bool isLoading = false;

  Future<void> _selectDate(BuildContext context, String variableName) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd MMM yyyy').format(picked);
      setState(() {
        if (variableName == 'startDate') {
          startDate = formattedDate;
        } else if (variableName == 'endDate') {
          endDate = formattedDate;
        }
      });
    }
  }

  String? idLeaveType = "0";

  Future<void> _updateLeaveTypes() async {
    ApiProvider apiProvider = ApiProvider();
    LeaveTypeController leaveTypeModel = await apiProvider.fetchLeaveTypes();

    setState(() {
      leaveTypes =
          leaveTypeModel.data.map((datum) => datum.statusAbsensi).toList();
      selectedType = leaveTypes.isNotEmpty ? leaveTypes[0] : '';

      selectedLeaveType = leaveTypeModel.data.firstWhere(
        (element) => element.statusAbsensi == selectedType,
        orElse: () => selectedLeaveType!,
      );
    });
  }

  Future<List<LeaveTypeData>> _getList() async {
    ApiProvider apiProvider = ApiProvider();
    final data = await apiProvider.fetchLeaveTypes();
    return data.data;
  }

  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    _initAsync();    
  }

  Future<void> _initAsync() async {
    await _updateLeaveTypes();
    
    setState(() {
      startDate = widget.data?.dari != null
          ? DateFormat('dd MMM yyyy').format(widget.data!.dari)
          : AppLocalizations(globalLanguage).translate("startTime");
      endDate = widget.data?.sampai != null
          ? DateFormat('dd MMM yyyy').format(widget.data!.sampai)
          : AppLocalizations(globalLanguage).translate("endTime");

      leavenoteController.text = widget.data?.keterangan ?? "";
      leavenote = widget.data?.keterangan ?? "";

      selectedLeaveType = LeaveTypeData(
        id: widget.data?.workTimeStatusId ?? "",
        statusAbsensi: widget.data?.keterangan ?? "",
      );

      idLeaveType = widget.data?.workTimeStatusId ?? "";
      previousSelectedLeaveType = selectedLeaveType;
    });
  }

  Future<void> _submitData() async {
    leavenote = leavenoteController.text;
    debugPrint('Id: $idLeaveType');
    final String? noAbsen = SessionManager().getNoAbsen();

    if (widget.data != null && attachment.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        await LeaveUrlController().submitEditData(
          widget.data?.attLeaveId ?? '',
          noAbsen ?? '',
          idLeaveType ?? widget.data?.workTimeStatusId ?? "",
          startDate,
          endDate,
          leavenote,
          attachment,
        );

        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LeaveListPage(),
                            ),
                          );

      } finally {
        
      }
    } else {
      final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: AppLocalizations(globalLanguage).translate("Failed"),
                                  message: AppLocalizations(globalLanguage).translate("Attachment can not be empty"),
                                  contentType: ContentType.failure,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("leave"),
            style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,),
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
                          Image.asset('assets/useradd.png',
                              height: 24, width: 24),
                          const SizedBox(width: 10),
                          Text(
                            SessionManager().getNamaUser() ?? 'Unknown',
                            style: const TextStyle(color: AppColors.deepGreen),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations(globalLanguage).translate("Leave Type"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownSearch<LeaveTypeData>(
                    asyncItems: (String filter) => _getList(),
                    itemAsString: (LeaveTypeData u) => u.statusAbsensi,
                    onChanged: (LeaveTypeData? data) {
                      if (data != null) {
                        if (data != previousSelectedLeaveType) {
                          idLeaveType = data.id;
                        }
                      }

                      previousSelectedLeaveType = data;
                    },
                    selectedItem: LeaveTypeData(
                      id: widget.data?.workTimeStatusId ?? "", 
                      statusAbsensi: widget.data?.keterangan ?? "",
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
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
                          Flexible(
                            child: TextField(
                              maxLines: 5,
                              controller: leavenoteController,
                              decoration: InputDecoration(
                                hintText:
                                    '${AppLocalizations(globalLanguage).translate("remark")}...',
                                hintStyle: const TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) {
                                leavenote = value;
                              },
                            ),
                          ),
                          Image.asset('assets/fill.png', height: 24, width: 24),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations(globalLanguage).translate("attachment"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await selectFile();
                        await uploadFile();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/file.png',
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                pickedFile == null ? file : pickedFile!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(color: AppColors.deepGreen),
                              ),
                            ),
                            const Spacer(),
                            Image.asset('assets/add.png',
                                height: 24, width: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: pickedFile != null,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: LinearProgressIndicator(
                            value: uploadProgress,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.deepGreen),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations(globalLanguage).translate("time"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
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
                                  Image.asset('assets/calendar.png',
                                      width: 47.12, height: 46),
                                  const Spacer(),
                                  Text(
                                    startDate,
                                    style: const TextStyle(
                                        color: AppColors.deepGreen),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Card(
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
                                  Image.asset('assets/calendar.png',
                                      width: 47.12, height: 46),
                                  const Spacer(),
                                  Text(
                                    endDate,
                                    style: const TextStyle(
                                        color: AppColors.deepGreen),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      _submitData();
                    },
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 50,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: AppColors.mainGreen)
                              : Text(
                                  AppLocalizations(globalLanguage)
                                      .translate("submit"),
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
      ),
    );
  }

  @override
  void dispose() {
    leavenoteController.dispose();
    super.dispose();
  }
}