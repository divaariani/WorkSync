import 'package:flutter/material.dart';
import 'app_colors.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({Key? key}) : super(key: key);

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 70),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('FEATURES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              InkWell(
                child: const Text('See All',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.deepGreen,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 3)
                        ])),
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const FeatureListPage(),
                  //   ),
                  // );
                },
              ),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/payslip.png',
                  title: 'Payslip',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => PayslipPage()),
                    // );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/checkpoint.png', 
                  title: 'Checkpoint Tour',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CheckpointPage()),
                    // );
                  },
                ),
                CardItem(
                  color: AppColors.mainGreen,
                  imagePath: 'assets/ticketing.png', 
                  title: 'Ticketing',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => TicketingPage()),
                    // );
                  },
                ),
              ],
            ),
          ]),
        )));
  }
}

class CardItem extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final double imageWidth;
  final double imageHeight;
  final VoidCallback onTap;

  CardItem({
    required this.color,
    required this.imagePath,
    this.title = '',
    this.imageWidth = 70,
    this.imageHeight = 70,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100, 
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Container(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset(imagePath),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.deepGreen, 
            ),
          ),
        ],
      ),
    );
  }
}