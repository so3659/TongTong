import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Map<DateTime, List<dynamic>> _fetchedEvents = {};

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirestore();
  }

  Future<void> _fetchEventsFromFirestore() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    Map<DateTime, List<dynamic>> events = {};
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime date = (data['date'] as Timestamp).toDate();
      String title = data['title'];
      DateTime dateOnly = DateTime(date.year, date.month, date.day);
      if (events[dateOnly] != null) {
        events[dateOnly]!.add(title);
      } else {
        events[dateOnly] = [title];
      }
    }
    setState(() {
      _fetchedEvents = events; // 상태 변수 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _floatingActionButton(context),
        body: SingleChildScrollView(
            // 스크롤 가능하게 만듭니다.
            child: Column(// Column을 사용해 리스트를 구성합니다.
                children: <Widget>[
          // TableCalendar and other widgets here...
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
              final eventsForDay =
                  _fetchedEvents[dateOnly] ?? []; // 상태 변수를 사용합니다.
              return eventsForDay;
            },
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
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

          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _fetchedEvents.length,
            itemBuilder: (context, index) {
              var key = _fetchedEvents.keys.elementAt(index);
              var value = _fetchedEvents[key];
              if (isSameDay(key, _selectedDay)) {
                return Column(
                  children: value!
                      .map((event) => Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Card(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    )),
                                child: ListTile(
                                  leading: Image.asset(
                                    'assets/images/tong_logo.png',
                                    width: 50, // Adjust the width as desired
                                    height: 50, // Adjust the height as desired
                                  ),
                                  title: Text(event),
                                  tileColor: Colors.white,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {},
                                  ),
                                )),
                          ))
                      .toList(),
                );
              } else {
                return const SizedBox
                    .shrink(); // Hide the ListTile if it's not the selected date
              }
            },
          ),
        ])));
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
