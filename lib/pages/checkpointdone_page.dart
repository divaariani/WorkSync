import 'package:flutter/material.dart';
import 'checkpoint_page.dart';
import 'app_colors.dart';
import '../utils/localizations.dart';
import '../utils/globals.dart';
import '../controllers/checkpoint_controller.dart';

class CheckpointDonePage extends StatefulWidget {
  final String cpCode;
  final String cpName;

  const CheckpointDonePage(
      {required this.cpCode, required this.cpName, Key? key})
      : super(key: key);

  @override
  State<CheckpointDonePage> createState() => _CheckpointDonePageState();
}

class _CheckpointDonePageState extends State<CheckpointDonePage> {
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations(globalLanguage).translate("Checkpoint Done"),
            style: TextStyle(
              color: globalTheme == 'Light Theme'
                  ? AppColors.deepGreen
                  : Colors.white,
            ),
          ),
          backgroundColor:
              globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: globalTheme == 'Light Theme'
                    ? AppColors.deepGreen
                    : Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CheckPointPage(
                          result: '',
                          resultCheckpoint: [],
                        )),
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
                      AppLocalizations(globalLanguage).translate("name"),
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
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/book_check.png',
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            Text(
                              widget.cpName,
                              style:
                                  const TextStyle(color: AppColors.deepGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations(globalLanguage).translate("Code"),
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
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.asset('assets/book_check.png',
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            Text(
                              widget.cpCode,
                              style:
                                  const TextStyle(color: AppColors.deepGreen),
                            ),
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
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: noteController,
                                decoration: InputDecoration(
                                  hintText:
                                      '${AppLocalizations(globalLanguage).translate("remark")}...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset('assets/fill.png',
                                height: 24, width: 24),
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
                            await CheckPointController.fetchDataScan(
                                cpBarcode: widget.cpName,
                                cpNote: noteController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CheckPointPage(
                                  result: '',
                                  resultCheckpoint: [],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 50),
                            child: Text(
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
        ));
  }
}
