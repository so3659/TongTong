import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tongtong/theme/theme.dart';
import 'dart:collection';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Future<Map<DateTime, List<dynamic>>> _fetchEventsFromFirestore() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    Map<DateTime, List<dynamic>> events = {};
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map;
      // Firestore에서 UTC로 저장된 Timestamp를 로컬 시간으로 변환
      DateTime eventDate = (data['date'] as Timestamp).toDate();
      String eventTitle = data['title'];

      // 날짜만 비교하기 위해 시간 정보를 제거
      DateTime dateOnly =
          DateTime(eventDate.year, eventDate.month, eventDate.day);

      if (events[dateOnly] == null) {
        events[dateOnly] = [];
      }
      events[dateOnly]?.add(eventTitle);
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _floatingActionButton(context),
        body: FutureBuilder<Map<DateTime, List<dynamic>>>(
            future: _fetchEventsFromFirestore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("데이터를 불러오는 중 오류가 발생했습니다."));
              }

              return Column(children: [
                TableCalendar(
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  eventLoader: (day) {
                    // 날짜만 비교하기 위해 시간 정보를 제거
                    DateTime dateOnly = DateTime(day.year, day.month, day.day);
                    final eventsForDay = snapshot.data?[dateOnly] ?? [];
                    return eventsForDay;
                  },
                  calendarStyle: const CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.red),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay =
                          focusedDay; // update `_focusedDay` here as well
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
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: _buildEventsMarker(date, events),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ]);
            }));
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'MakeAppointment',
      shape: const CircleBorder(),
      onPressed: () {
        _addEvent();
      },
      backgroundColor: Colors.indigo.shade400,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  void _addEvent() async {
    TextEditingController eventController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("새 이벤트 추가"),
              content: TextField(
                controller: eventController,
                decoration: const InputDecoration(hintText: "이벤트 타이틀"),
              ),
              actions: [
                TextButton(
                  child: const Text("취소"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text("저장"),
                  onPressed: () async {
                    if (eventController.text.isEmpty) return;
                    await FirebaseFirestore.instance.collection('events').add({
                      'title': eventController.text,
                      'date': Timestamp.fromDate(_selectedDay),
                    });
                    Navigator.pop(context);
                    eventController.clear();
                    setState(() {});
                  },
                ),
              ],
            ));
  }
}
