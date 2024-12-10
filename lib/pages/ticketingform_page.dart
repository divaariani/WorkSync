import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'home_page.dart';
import 'app_colors.dart';
import 'ticketing_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';
import '../utils/photos.dart';
import '../controllers/ticketing_controller.dart';

class TicketingFormPage extends StatefulWidget {
  const TicketingFormPage({Key? key}) : super(key: key);

  @override
  State<TicketingFormPage> createState() => _TicketingFormPageState();
}

class _TicketingFormPageState extends State<TicketingFormPage> {
  TicketingController controller = TicketingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String attachment = '';
  String selectedTicketingType = '2'; 
  String selectedAssignedType = '0'; 
  String selectedCategoryType = '1'; 
  String selectedSubCategoryType = '1'; 
  String selectedPriorityType = 'Low';
  double uploadProgress = 0.0;
  List<Map<String, dynamic>> ticketingToOptions = [];
  List<Map<String, dynamic>> assignedToOptions = []; 
  List<Map<String, dynamic>> categoryOptions = [];
  List<Map<String, dynamic>> subCategoryOptions = [];

  CustomFile? pickedFile;
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

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      final snapshot = await uploadTask.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        attachment = urlDownload;
      });
      
      debugPrint('Direct Image Link: $urlDownload');
    } else {
      debugPrint('No file selected');
    }
  }

  Future<void> fetchTicketingToOptions() async {
    final response = await http.get(Uri.parse('$apiBaseUrl?function=get_list_ticketing_to'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        List<dynamic> data = responseData['data'];
        setState(() {
          ticketingToOptions = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint('API Error: ${responseData['message']}');
      }
    } else {
      debugPrint('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future<void> fetchAssignedToOptions(String ticketingId) async {
    final response = await http.get(Uri.parse('$apiBaseUrl?function=get_list_sign_to&lineuid=$ticketingId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        List<dynamic> data = responseData['data'];
        setState(() {
          assignedToOptions = List<Map<String, dynamic>>.from(data);
          if (assignedToOptions.isNotEmpty) {
            selectedAssignedType = assignedToOptions[0]['User_Id'];
          }
        });
      } else {
        debugPrint('API Error: ${responseData['message']}');
      }
    } else {
      debugPrint('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future<void> fetchCategoryOptions(String ticketingId) async {
    final response = await http.get(Uri.parse('$apiBaseUrl?function=get_list_category&id_ticketing=$ticketingId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        List<dynamic> data = responseData['data'];
        setState(() {
          categoryOptions = List<Map<String, dynamic>>.from(data);
        });
      } else {
        debugPrint('API Error: ${responseData['message']}');
      }
    } else {
      debugPrint('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future<void> fetchSubCategoryOptions(String categoryId) async {
    final response = await http.get(Uri.parse('$apiBaseUrl?function=get_list_subcategory&id_category=$categoryId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        List<dynamic> data = responseData['data'];
        setState(() {
          subCategoryOptions = List<Map<String, dynamic>>.from(data);
          if (subCategoryOptions.isNotEmpty) {
            selectedSubCategoryType = subCategoryOptions[0]['Id']; 
          } 
        });
      } else {
        debugPrint('API Error: ${responseData['message']}');
      }
    } else {
      debugPrint('HTTP Request Error: ${response.statusCode}');
    }
  }

  get userId => SessionManager().getUserId();

  @override
  void initState() {
    super.initState();
    fetchTicketingToOptions();
    fetchAssignedToOptions(selectedTicketingType);
    fetchCategoryOptions(selectedTicketingType);
    fetchSubCategoryOptions(selectedCategoryType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("ticketing"),
            style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,),
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
                    AppLocalizations(globalLanguage).translate("ticketingTo"),
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
                          Image.asset('assets/department.png', height: 24, width: 24),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: selectedTicketingType, 
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedTicketingType = newValue;
                                  fetchAssignedToOptions(selectedTicketingType);
                                  selectedAssignedType = assignedToOptions[0]['User_Id'];
                                  selectedCategoryType = categoryOptions[0]['Id'];
                                });
                              }
                            },
                            items: ticketingToOptions.map((Map<String, dynamic> option) {
                              return DropdownMenuItem<String>(
                                value: option['Id'].toString(),
                                child: Text(option['TiketingTo'],
                                    style: const TextStyle(color: AppColors.deepGreen)),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations(globalLanguage).translate("assignedTo"),
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
                          DropdownButton<String>(
                            value: selectedAssignedType,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedAssignedType = newValue;
                                });
                              }
                            },
                            items: assignedToOptions.map((Map<String, dynamic> option) {
                              return DropdownMenuItem<String>(
                                value: option['User_Id'].toString(),
                                child: Text(option['SignTo'],
                                    style: const TextStyle(color: AppColors.deepGreen)),
                              );
                            }).toList(),
                          ),
                        ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("category"),
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
                            Image.asset('assets/attendancetype.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedCategoryType,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() async {
                                    selectedCategoryType = newValue;
                                    fetchSubCategoryOptions(selectedCategoryType);
                                    await Future.delayed(const Duration(seconds: 1));
                                    selectedSubCategoryType = subCategoryOptions[0]['Id'];
                                  });
                                }
                              },
                              items: categoryOptions.map((Map<String, dynamic> option) {
                                return DropdownMenuItem<String>(
                                  value: option['Id'].toString(),
                                  child: Text(option['Kategori'],
                                      style: const TextStyle(color: AppColors.deepGreen)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("subCategory"),
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
                            Image.asset('assets/attendancetype.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedSubCategoryType,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedSubCategoryType = newValue;
                                  });
                                }
                              },
                              items: subCategoryOptions.map((Map<String, dynamic> option) {
                                return DropdownMenuItem<String>(
                                  value: option['Id'].toString(),
                                  child: Text(option['SubKategori'],
                                      style: const TextStyle(color: AppColors.deepGreen)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("priority"),
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
                            Image.asset('assets/attendancetype.png', height: 24, width: 24),
                            const SizedBox(width: 10),
                            DropdownButton<String>(
                              value: selectedPriorityType,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedPriorityType = newValue;
                                  });
                                }
                              },
                              items: <String>['Low', 'Medium', 'High'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          color: AppColors.deepGreen)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("subject"),
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
                                controller: subjectController,
                                decoration: InputDecoration(
                                  hintText: '${AppLocalizations(globalLanguage).translate("subject")}...',
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
                                controller: descriptionController,
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
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("attachment"),
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
                      child: GestureDetector(
                        onTap: () async {
                          await selectFile();
                          await uploadFile();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.asset('assets/file.png', height: 24, width: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  pickedFile == null ? file : pickedFile!.name,
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis, 
                                  style: const TextStyle(color: AppColors.deepGreen),
                                ),
                              ),
                              const Spacer(),
                              Image.asset('assets/add.png', height: 24, width: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            debugPrint('tiket kepada dept $selectedTicketingType');
                            debugPrint('kepada $selectedAssignedType');
                            debugPrint('subyek  ${subjectController.text}');
                            debugPrint('deskripsi  ${descriptionController.text}');
                            debugPrint('userid  $userId');
                            debugPrint('kategori  $selectedCategoryType');
                            debugPrint('sub kategori $selectedSubCategoryType');
                            debugPrint('[prioritas] $selectedPriorityType');
                            debugPrint('[attachment] $attachment');

                            try {
                              await controller.postTicketing(
                                  lineuid: 0,
                                  tiketingTo: int.parse(selectedTicketingType),
                                  signTo: int.parse(selectedAssignedType),
                                  subject: subjectController.text,
                                  desk: descriptionController.text,
                                  userid: userId,
                                  kat: int.parse(selectedCategoryType),
                                  subKat: int.parse(selectedSubCategoryType),
                                  priority: selectedPriorityType,
                                  attachment: attachment,
                                );

                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: AppLocalizations(globalLanguage).translate("ticketingPosted"),
                                    message: AppLocalizations(globalLanguage).translate("ticketingPostedDesc"),
                                    contentType: ContentType.success,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TicketingPage(),
                                  ),
                                );

                            } catch (e) {
                              final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Failed',
                                    message: 'Failed to post ticketing',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              debugPrint("Error posting ticket: $e");
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