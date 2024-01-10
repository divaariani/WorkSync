import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'ticketingform_page.dart';
import 'ticketingdetail_page.dart';
import '../controllers/ticketing_controller.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class TicketingPage extends StatefulWidget {
  const TicketingPage({Key? key}) : super(key: key);

  @override
  State<TicketingPage> createState() => _TicketingPageState();
}

class _TicketingPageState extends State<TicketingPage> {
  final TicketingController controller = TicketingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("ticketingList"),
          style: TextStyle(
            color: globalTheme == 'Light Theme' ? AppColors.deepGreen : Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                  const SizedBox(height: 5),
                  FutureBuilder<List<TicketingUser>>(
                    future: controller.fetchTicketingUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        return const Text('No Data', style: TextStyle(color: Colors.white));
                      } else {
                        final List<TicketingUser> ticketingList = snapshot.data ?? [];

                        return Column(
                          children: ticketingList.map((ticket) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TicketingDetailPage(ticket: ticket),
                                    ),
                                  );
                                },
                                child: ClipPath(
                                  clipper: DolDurmaClipper(
                                      holeWidth: 10,
                                      holeHeight: 80,
                                      bottom: 80),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                                    child: CustomPaint(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${ticket.noTiket} - ${ticket.subjek}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: AppColors.deepGreen,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(AppLocalizations(globalLanguage).translate("priority"),
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("category"),
                                                    style: const TextStyle( fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("subCategory"),
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("status"),
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  Text(AppLocalizations(globalLanguage).translate("remark"),
                                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              const Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(':'),
                                                  SizedBox(height: 5),
                                                  Text(':'),
                                                  SizedBox(height: 5),
                                                  Text(':'),
                                                  SizedBox(height: 5),
                                                  Text(':'),
                                                  SizedBox(height: 5),
                                                  Text(':'),
                                                ],
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(ticket.prioritas!),
                                                    const SizedBox(height: 5),
                                                    Text(ticket.kategori!),
                                                    const SizedBox(height: 5),
                                                    Text(ticket.subkategori!),
                                                    const SizedBox(height: 5),
                                                    Text(ticket.status!),
                                                    const SizedBox(height: 5),
                                                    Wrap(
                                                      spacing: 8,
                                                      children: [
                                                        Text(
                                                          ticket.description!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
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
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TicketingFormPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                    child: Text(
                      AppLocalizations(globalLanguage).translate("addTicketing"),
                      style: const TextStyle(
                        color: AppColors.deepGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DolDurmaClipper extends CustomClipper<Path> {
  final double holeWidth;
  final double holeHeight;
  final double bottom;

  DolDurmaClipper({
    required this.holeWidth,
    required this.holeHeight,
    required this.bottom,
  });

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - bottom - holeHeight)
      ..lineTo(holeWidth, size.height - bottom - holeHeight)
      ..lineTo(holeWidth, size.height - bottom)
      ..lineTo(0.0, size.height - bottom)
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - bottom)
      ..lineTo(size.width - holeWidth, size.height - bottom)
      ..lineTo(size.width - holeWidth, size.height - bottom - holeHeight)
      ..lineTo(size.width, size.height - bottom - holeHeight);

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.mainGreen
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    double dashWidth = 10.0;
    double dashSpace = 15.0;

    double startY = 0.0;
    double endY = size.height;

    while (startY < endY) {
      canvas.drawLine(
        Offset(0.0, startY),
        Offset(0.0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
