import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'warehousebarcodes_page.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';
import '../utils/session_manager.dart';

class WarehouseManualPage extends StatefulWidget {
  final String? auditorData;

  const WarehouseManualPage({Key? key, this.auditorData}) : super(key: key);

  @override
  State<WarehouseManualPage> createState() => _WarehouseManualPageState();
}

class _WarehouseManualPageState extends State<WarehouseManualPage> {
  final SessionManager sessionManager = SessionManager();
  String userName = "";

  List<String> lotNumbers = [''];

  void addCard() {
    setState(() {
      lotNumbers.add('');
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    userName = sessionManager.getNamaUser() ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool _) async {
        return Future.sync(() => false);
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations(globalLanguage).translate("productForm"),
              style: TextStyle(
                color: globalTheme == 'Light Theme'
                    ? AppColors.deepGreen
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor:
                globalTheme == 'Light Theme' ? Colors.white : Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WarehouseBarcodesPage()),
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
                              Image.asset('assets/useradd.png',
                                  height: 24, width: 24),
                              const SizedBox(width: 10),
                              Text(
                                userName,
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
                              Image.asset('assets/mobil.png', height: 24, width: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  globalBarcodeMobilResult,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(color: AppColors.deepGreen),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations(globalLanguage).translate("productList"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: lotNumbers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final lotNumber = entry.value;
                          final listLength = lotNumbers.length;

                          return Column(
                            children: [
                              if (index == 0) const SizedBox(height: 16),
                              buildLotNumberCard(lotNumber),
                              if (index < listLength - 1) const SizedBox(height: 8),
                              if (index == listLength - 1)
                                const SizedBox(height: 48),
                            ],
                          );
                        }).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            child: InkWell(
                              onTap: () async {
                                addCard();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                                child: Text(
                                  AppLocalizations(globalLanguage).translate("+"),
                                  style: const TextStyle(
                                    color: AppColors.deepGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                            child: InkWell(
                              onTap: () async {
                                globalBarcodeGudangResults.addAll(lotNumbers.where((lot) => lot.isNotEmpty));

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WarehouseBarcodesPage(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                                child: Text(
                                  AppLocalizations(globalLanguage).translate("save"),
                                  style: const TextStyle(
                                    color: AppColors.deepGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget buildLotNumberCard(String lotNumber) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        lotNumbers[lotNumbers.indexOf(lotNumber)] = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: '...',
                      hintStyle: TextStyle(color: AppColors.deepGreen),
                      border: InputBorder.none,
                    ),
                  ),
              ),
              const Spacer(),
              Image.asset('assets/fill.png', height: 24, width: 24),
            ],
          ),
        ),
      ),
    );
  }
}