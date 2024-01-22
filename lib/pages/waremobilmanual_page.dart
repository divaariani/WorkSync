import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'warehouse_page.dart';
import 'warehousebarcodes_page.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class MobilManualPage extends StatefulWidget {
  const MobilManualPage({Key? key}) : super(key: key);

  @override
  State<MobilManualPage> createState() => _MobilManualPageState();
}

class _MobilManualPageState extends State<MobilManualPage> {
  TextEditingController mobilController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("truckForm"),
            style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,),
          ),
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WarehousePage()
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
                      AppLocalizations(globalLanguage).translate("managedBy"),
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
                              SessionManager().getNamaUser() ?? 'Unknown',
                              style: const TextStyle(color: AppColors.deepGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("truck"),
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
                                controller: mobilController,
                                decoration: InputDecoration(
                                  hintText: '${AppLocalizations(globalLanguage).translate("truck")}...',
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
                            globalBarcodeMobilResult = mobilController.text;

                            Navigator.pushReplacement(
                              context, MaterialPageRoute(
                                builder: (context) => WarehouseBarcodesPage(
                                  result: '',
                                  resultBarang: []
                                )
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 50),
                            child: Text(
                              AppLocalizations(globalLanguage).translate("next"),
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