import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:worksync/main.dart';
import 'app_colors.dart';
import '../utils/globals.dart';
import '../utils/session_manager.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> with TickerProviderStateMixin {
  late bool isLoggedIn;
  late String savedTheme;

  @override
  void initState() {
    super.initState();
    initAsyncData();
  }

  Future<void> initAsyncData() async {
    final sessionManager = SessionManager();
    isLoggedIn = await sessionManager.isLoggedIn();
    savedTheme = sessionManager.getTheme();
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: globalTheme == 'Light Theme' ? Colors.white : Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Lottie.asset('assets/nointernet.json'),
                  ),
                ),
                const SizedBox(height: 20),
                Text('No Internet Connection', style: TextStyle(color: globalTheme == 'Light Theme' ? AppColors.mainGreen : Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => WorkSyncApp(isLoggedIn: isLoggedIn, savedTheme: savedTheme)),
                      );
                    },
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                          child: Text(
                            'Try Again',
                            style: TextStyle(
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
              )
            )
          ),
    );
  }
}