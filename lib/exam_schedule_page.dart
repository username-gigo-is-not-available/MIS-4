import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ExamSchedulePage extends StatefulWidget {
  const ExamSchedulePage({Key? key}) : super(key: key);

  @override
  _ExamSchedulePageState createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  final TextEditingController _subjectController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  late List<Map<String, dynamic>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _selectedEvents = _events[DateTime.now()] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDate,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _selectedEvents = _events[selectedDay] ?? [];
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (BuildContext context, int index) {
                final schedule = _selectedEvents[index];
                final DateTime scheduleDateTime = schedule['date'];
                final String formattedDate = DateFormat('yyyy-MM-dd').format(scheduleDateTime);
                final TimeOfDay timeOfDay = schedule['time'];
                final String formattedTime = '${timeOfDay.hour}:${timeOfDay.minute}';
                return ListTile(
                  title: Text(schedule['subject'] ?? ''),
                  subtitle: Text('$formattedDate | $formattedTime'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddScheduleDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddScheduleDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Exam Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedTime == null ? '' : '${_selectedTime!.hour}:${_selectedTime!.minute}',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Time',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addSchedule();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _addSchedule() {
    if (_subjectController.text.isNotEmpty) {
      final newEvent = {
        'subject': _subjectController.text,
        'date': _selectedDate,
        'time': _selectedTime,
      };
      setState(() {
        _events.update(_selectedDate, (value) => [...value, newEvent], ifAbsent: () => [newEvent]);
        _selectedEvents = _events[_selectedDate] ?? [];
        _subjectController.clear();
      });
    }
  }
}
