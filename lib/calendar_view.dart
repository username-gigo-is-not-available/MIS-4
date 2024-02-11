import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CalendarView({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        locale: 'en_US',
        // Set locale
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          // Hide format button
          titleCentered: true,
          // Center title
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // Customize title text style
          headerPadding: EdgeInsets.symmetric(
              vertical: 15), // Adjust header padding
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        // Start week with Monday
        availableGestures: AvailableGestures.horizontalSwipe,
        // Allow horizontal swiping
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.3)),
          // Highlight today's date
          selectedDecoration: BoxDecoration(color: Colors.blue),
          // Highlight selected date
          markersMaxCount: 2, // Limit number of event markers
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black),
          // Customize weekday text style
          weekendStyle: TextStyle(
              color: Colors.red), // Customize weekend text style
        ),
        selectedDayPredicate: (day) {
          return isSameDay(day, _selectedDate);
        },

        focusedDay: _selectedDate,
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        lastDay: DateTime.now().add(Duration(days: 365)),
        onDaySelected: (date, focusedDay) {
          setState(() {
            _selectedDate = date;
          });
          widget.onDateSelected(date);
        }
    );
  }
}
