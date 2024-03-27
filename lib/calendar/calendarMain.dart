import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tongtong/theme/theme.dart';
import 'dart:collection';

import 'package:tongtong/widgets/customWidgets.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  final events = LinkedHashMap(
    equals: isSameDay,
  )..addAll(eventSource);

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       fontFamily: 'SunflowerMedium',
    //     ),
    //     home:
    return Scaffold(
        body: Column(children: [
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, dynamic events) {
              if (events.isNotEmpty) {
                return Container(
                    width: 35,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: const Text(
                        'MT',
                        style: TextStyle(fontSize: 10),
                      ),
                    ));
              }
              return null;
            }),
          ),
        ]),
        floatingActionButton: _floatingActionButton(context));
  }
}

Widget _floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    heroTag: 'MakeAppointment',
    shape: const CircleBorder(),
    onPressed: () {},
    backgroundColor: Colors.blue,
    child: const Icon(
      Icons.add,
      color: Colors.white,
    ),
  );
}

class Event {
  String title;
  Event(this.title);

  @override
  String toString() => title;
}

Map<DateTime, dynamic> eventSource = {
  DateTime(2023, 12, 23): [Event('통통 겨울 MT')],
};
