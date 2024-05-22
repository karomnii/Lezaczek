// lib/pages/calendar/calendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/data/static_data.dart';
import 'event_details.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Calendar',
        ),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildDateBar(),
          Expanded(
            child: ListView.builder(
              itemCount: 24,
              itemBuilder: (context, index) {
                return _buildHourRow(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateBar() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.subtract(Duration(days: 1));
              });
            },
          ),
          Text(
            DateFormat('EEEE, MMM d').format(selectedDate),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.add(Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHourRow(int hour) {
    DateTime currentHour = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
    );
    List<Event> eventsAtThisHour = staticEvents.where((event) {
      return event.dateStart.year == currentHour.year &&
          event.dateStart.month == currentHour.month &&
          event.dateStart.day == currentHour.day &&
          event.startingTime!.hour <= currentHour.hour &&
          event.endingTime!.hour >= currentHour.hour;
    }).toList();

    return Row(
      children: [
        SizedBox(
          width: 60.0, // Width of the hour column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${hour.toString().padLeft(2, '0')}:00',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                '${(hour + 1).toString().padLeft(2, '0')}:00',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: eventsAtThisHour.map((event) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventDetails(event: event.toMap()),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.blue, width: 2.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          event.description ?? '',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
