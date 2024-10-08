import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

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
      String uid = data['uid'];
      String documentId = data['documentId'];
      DateTime dateOnly = DateTime(date.year, date.month, date.day);
      if (events[dateOnly] != null) {
        events[dateOnly]!.add({
          'title': title,
          'uid': uid,
          'documentId': documentId,
        });
      } else {
        events[dateOnly] = [
          {
            'title': title,
            'uid': uid,
            'documentId': documentId,
          }
        ];
      }
    }
    if (mounted) {
      setState(() {
        _fetchedEvents = events;
      });
    }
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
                  children: value!.map((event) {
                    var data = event as Map<String, dynamic>;
                    var eventTitle = data['title'];
                    var eventUid = data['uid'];
                    var eventDocumentId = data['documentId'];
                    return Container(
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
                            title: Text(eventTitle),
                            tileColor: Colors.white,
                            trailing: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: eventUid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Colors.black87
                                    : Colors.grey[400],
                              ),
                              onPressed: () {
                                eventUid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon:
                                                        const Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.delete),
                                                      title: const Text('삭제'),
                                                      onTap: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'events')
                                                            .doc(
                                                                eventDocumentId)
                                                            .delete();
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              '일정이 삭제되었습니다.'), //snack bar의 내용. icon, button같은것도 가능하다.
                                                          duration: Duration(
                                                              seconds:
                                                                  3), //올라와있는 시간
                                                        ));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ]);
                                        },
                                      )
                                    : null;
                              },
                            ),
                          )),
                    );
                  }).toList(),
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
        GoRouter.of(context).push('/makeAppointment');
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
}
