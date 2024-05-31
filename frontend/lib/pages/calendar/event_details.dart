// lib/pages/calendar/event_details.dart

import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'package:intl/intl.dart';
import 'event_form.dart';

class EventDetails extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onDelete;
  final Function(Event) onUpdate;

  EventDetails({required this.event, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    Event currentEvent = Event.fromJson(event);

    // Convert DateTime and TimeOfDay to strings
    String dateStart = DateFormat('yyyy-MM-dd').format(currentEvent.dateStart);
    String dateEnd = DateFormat('yyyy-MM-dd').format(currentEvent.dateEnd);
    String startingTime = currentEvent.startingTime.format(context);
    String endingTime = currentEvent.endingTime.format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentEvent.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventForm(
                    initialEvent: currentEvent,
                    onSave: (updatedEvent) {
                      onUpdate(updatedEvent);
                      Navigator.pop(context);
                      Navigator.pop(context); // Close the EventDetails page
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete();
              Navigator.pop(context); // Go back to the calendar page after deletion
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentEvent.description ?? 'No description available',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Place: ${currentEvent.place ?? 'Not specified'}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Type: ${currentEvent.eventType}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Start: $dateStart $startingTime',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'End: $dateEnd $endingTime',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
