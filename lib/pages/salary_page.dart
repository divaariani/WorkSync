import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'app_colors.dart';
import '../utils/globals.dart';
import '../utils/localizations.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({Key? key}) : super(key: key);

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations(globalLanguage).translate("payslip"),
            style: const TextStyle(color: AppColors.deepGreen, fontWeight: FontWeight.bold),
          ),
        backgroundColor: Colors.white,
        //centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepGreen),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.deepGreen, AppColors.lightGreen], 
          ),
        ),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              const Expanded(
                flex: 6,
                child: Calendar(),
              ),
              Expanded(
                flex: 4,
                child: MonthList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarCarousel(
      onDayPressed: (DateTime date, List events) {
        // Do something when a day is pressed
      },
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      weekdayTextStyle: const TextStyle(
        color: Colors.white,
      ),
      thisMonthDayBorderColor: Colors.white,
      todayButtonColor: Colors.white,
      todayTextStyle: const TextStyle(color: AppColors.deepGreen),
      selectedDayButtonColor: AppColors.deepGreen,
      iconColor: Colors.white,
      headerTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}

class MonthList extends StatelessWidget {
  MonthList({Key? key}) : super(key: key);
  
  final List<String> items = [
    'October 2023',
    'September 2023',
    'August 2023',
    'July 2023',
    'June 2023',
    'May 2023',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.circle,
                color: AppColors.grey,
              ),
              title: Text(items[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () {
                // Action when the list item is tapped
              },
            ),
          ],
        );
      },
    );
  }
}
