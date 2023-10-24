import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'app_colors.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({Key? key}) : super(key: key);

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: Column(
          children: [
            const Flexible(
              child: Calendar(),
            ),
            Expanded(
              child: MonthList(),
            ),
          ],
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
        color: AppColors.mainBrown,
      ),
      thisMonthDayBorderColor: AppColors.mainBrown,
      todayButtonColor: AppColors.mainBrown,
      selectedDayButtonColor: AppColors.mainBrown,
      iconColor: AppColors.mainBrown,
      headerTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }
}

class MonthList extends StatelessWidget {
  MonthList({Key? key}) : super(key: key);
  
  final List<String> items = [
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
                color: AppColors.mainBrown,
              ),
              title: Text(items[index]),
              trailing: const Icon(Icons.arrow_forward, color: AppColors.mainBrown),
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
