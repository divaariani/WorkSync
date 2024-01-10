import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'app_colors.dart';
import 'ticketing_page.dart';
import '../controllers/ticketing_controller.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class TicketingDetailPage extends StatefulWidget {
  final TicketingUser ticket;

  const TicketingDetailPage({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketingDetailPage> createState() => _TicketingDetailPageState();
}

class _TicketingDetailPageState extends State<TicketingDetailPage> {
  TextEditingController noteController = TextEditingController();
  int _rating = 0;
  int scoreTicketing = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations(globalLanguage).translate("ticketingDetail"),
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
              MaterialPageRoute(builder: (context) => const TicketingPage()),
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
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              '${widget.ticket.noTiket} - ${widget.ticket.subjek}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.mainGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), 
                          CustomPaint(
                            painter: DashedLinePainter(),
                            child: Container(
                              height: 1, 
                            ),
                          ),
                          const SizedBox(height: 10), 
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AppLocalizations(globalLanguage).translate("priority"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(AppLocalizations(globalLanguage).translate("category"), style: const TextStyle( fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(AppLocalizations(globalLanguage).translate("subCategory"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(AppLocalizations(globalLanguage).translate("status"), style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(':'),
                                    SizedBox(height: 5),
                                    Text(':'),
                                    SizedBox(height: 5),
                                    Text(':'),
                                    SizedBox(height: 5),
                                    Text(':'),
                                  ],
                                )
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.ticket.prioritas!),
                                    const SizedBox(height: 5),
                                    Text(widget.ticket.kategori!),
                                    const SizedBox(height: 5),
                                    Text(widget.ticket.subkategori!),
                                    const SizedBox(height: 5),
                                    Text(widget.ticket.status!),
                                  ],
                                )
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations(globalLanguage).translate("remark"),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(':'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.ticket.description!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations(globalLanguage).translate("attachment"),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(':'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                child: Image.network(
                                                  widget.ticket.attachment!, 
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        print(widget.ticket.attachment);
                                      },
                                      child: Text(
                                        AppLocalizations(globalLanguage).translate("viewPhoto"),
                                          style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (widget.ticket.status != 'Completed') Center(
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: AppColors.mainGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SizedBox(height: 20),
                                              Text(
                                                'Rate your satisfaction in this ticket system',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              StarRating(
                                                onRatingChanged: (rating) {
                                                  setState(() {
                                                    _rating = rating;
                                                    updateScoreTicketing();
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 20),
                                              TextField(
                                                maxLines: 3,
                                                controller: noteController,  
                                                onChanged: (text) {
                                                  noteController.text = text;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Add your satisfaction note...',
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: BorderSide(color: Colors.grey), 
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: BorderSide(color: AppColors.lightGreen), 
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      gradient: const LinearGradient(
                                                        colors: [Colors.white, AppColors.mainGrey],
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
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                                                        child: Text(
                                                          'Cancel',
                                                          style: const TextStyle(
                                                            color: AppColors.deepGreen,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                                        String ticketingId = widget.ticket.lineUID!;
                                                        String score = '$scoreTicketing'; 
                                                        String note = noteController.text;

                                                        try {
                                                          await TicketingController().postRateTicketing(ticketingId, score, note);
                                                          final snackBar = SnackBar(
                                                            elevation: 0,
                                                            behavior: SnackBarBehavior.floating,
                                                            backgroundColor: Colors.transparent,
                                                            content: AwesomeSnackbarContent(
                                                              title: AppLocalizations(globalLanguage).translate("Rated"),
                                                              message: AppLocalizations(globalLanguage).translate("Successfully rate the ticketing"),
                                                              contentType: ContentType.success,
                                                            ),
                                                          );

                                                          ScaffoldMessenger.of(context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(snackBar);

                                                          print('Rating submitted successfully');
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => const TicketingPage()),
                                                          );
                                                        } catch (error) {
                                                          print('Error submitting rating: $error');
                                                          final snackBar = SnackBar(
                                                            elevation: 0,
                                                            behavior: SnackBarBehavior.floating,
                                                            backgroundColor: Colors.transparent,
                                                            content: AwesomeSnackbarContent(
                                                              title: AppLocalizations(globalLanguage).translate("Failed"),
                                                              message: AppLocalizations(globalLanguage).translate("Failed rate the ticketing"),
                                                              contentType: ContentType.failure,
                                                            ),
                                                          );

                                                          ScaffoldMessenger.of(context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(snackBar);
                                                        }
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                                                        child: Text(
                                                          'Submit',
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
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                                  child: Text(
                                    AppLocalizations(globalLanguage).translate("Rate"),
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
                  if (widget.ticket.status == 'Completed') Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildScoreIcon(int.parse(widget.ticket.score!)),
                        ],
                      ),
                      Text(widget.ticket.note!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                    ]
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateScoreTicketing() {
    if (_rating == 1) {
      scoreTicketing = 20;
    } else if (_rating == 2) {
      scoreTicketing = 40;
    } else if (_rating == 3) {
      scoreTicketing = 60;
    } else if (_rating == 4) {
      scoreTicketing = 80;
    } else if (_rating == 5) {
      scoreTicketing = 100;
    } else {
      scoreTicketing = 0;
    }
  }

  Widget buildScoreIcon(int score) {
    if (score >= 20 && score < 40) {
      return Icon(Icons.star_rounded, color: Colors.amber);
    } else if (score >= 40 && score < 60) {
      return Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
        ],
      );
    } else if (score >= 60 && score < 80) {
      return Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
        ],
      );
    } else if (score >= 80 && score < 100) {
      return Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
        ],
      );
    } else if (score == 100) {
      return Row(
        children: [
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
          Icon(Icons.star_rounded, color: Colors.amber),
        ],
      );
    } else {
      return Text('Score: $score');
    }
  }
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

    double startX = 0.0;
    double endX = size.width;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, 0.0),
        Offset(startX + dashWidth, 0.0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StarRating extends StatefulWidget {
  final Function(int) onRatingChanged;

  StarRating({required this.onRatingChanged});

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star_rounded,
            color: index < _rating ? Colors.amber : Colors.white,
          ),
          iconSize: 30,
          onPressed: () {
            setState(() {
              _rating = index + 1;
              widget.onRatingChanged(_rating); 
            });
          },
        );
      }),
    );
  }
}