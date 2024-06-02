// lib/pages/calendar/calendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/event.dart';
import 'package:frontend/data/static_data.dart';
import 'package:frontend/pages/calendar/event_details.dart';
import 'package:frontend/pages/calendar/event_form.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  int nextIndex = 1;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    setState(() {});
  }

  void _addEvent(Event event) {
    setState(() {
      staticEvents.add(event);
    });
  }

  void _updateEvent(Event updatedEvent) {
    setState(() {
      int index = staticEvents.indexWhere((event) => event.eventId == updatedEvent.eventId);
      if (index != -1) {
        staticEvents[index] = updatedEvent;
      }
    });
  }

  void _deleteEvent(Event event) {
    setState(() {
      staticEvents.removeWhere((e) => e.eventId == event.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Calendar'),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventForm(
                    onSave: (newEvent) {
                      _addEvent(newEvent);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateBar(),
          Expanded(
            child: _buildEventList(),
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
              _refreshEvents();
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
              _refreshEvents();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    List<Event> eventsForSelectedDay = staticEvents.where((event) {
      return event.dateStart.year == selectedDate.year &&
          event.dateStart.month == selectedDate.month &&
          event.dateStart.day == selectedDate.day;
    }).toList();

    // Sort events by starting time
    eventsForSelectedDay.sort((a, b) =>
    a.startingTime!.hour.compareTo(b.startingTime!.hour) != 0
        ? a.startingTime!.hour.compareTo(b.startingTime!.hour)
        : a.startingTime!.minute.compareTo(b.startingTime!.minute));

    return ListView.builder(
      itemCount: eventsForSelectedDay.length,
      itemBuilder: (context, index) {
        Event event = eventsForSelectedDay[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetails(
                  event: event.toMap(),
                  onDelete: () {
                    _deleteEvent(event);
                  },
                  onUpdate: (updatedEvent) {
                    _updateEvent(updatedEvent);
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            padding: const EdgeInsets.all(12.0),
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
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  event.description ?? '',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${event.startingTime!.format(context)} - ${event.endingTime!.format(context)}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
