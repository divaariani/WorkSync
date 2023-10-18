import 'package:flutter/material.dart';
import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final heightSize = 0.09 * MediaQuery.of(context).size.height;
    final widthSize = 0.35 * MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileCard(),
            SizedBox(height: heightSize),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.8,
                      valueColor: AlwaysStoppedAnimation(Color(0xFFA3A397)),
                      backgroundColor: Color(0xFFFFFFF7),
                      strokeWidth: 5,
                    ),
                  ),
                  const Column(children: [
                    Text(
                      '80%',
                      style: TextStyle(
                        color: Color(0xFFA3A397),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Kehadiran',
                      style: TextStyle(
                        color: Color(0xFFA3A397),
                        fontSize: 12,
                      ),
                    ),
                  ])
                ],
              ),
            ),
            SizedBox(height: heightSize),
            Container(
              margin: EdgeInsets.symmetric(horizontal: widthSize),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage()));
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3A397),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                        color: Color(0xFFFFFFF7),
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: heightSize),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFA3A397),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.only(top: 100, bottom: 40, left: 20, right: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Username',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFF7)),
            ),
            SizedBox(height: 10),
            Text(
              'Full Stack Mobile Developer',
              style: TextStyle(fontSize: 14, color: Color(0xFFFFFFF7)),
            ),
            Text(
              'IT Department',
              style: TextStyle(fontSize: 14, color: Color(0xFFFFFFF7)),
            ),
          ],
        ),
      ),
    );
  }
}