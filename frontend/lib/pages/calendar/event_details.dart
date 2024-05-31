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
        title: Text(
          currentEvent.name,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
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
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.description, 'Description', currentEvent.description ?? 'No description available'),
                SizedBox(height: 16.0),
                _buildDetailRow(Icons.location_on, 'Place', currentEvent.place ?? 'Not specified'),
                SizedBox(height: 16.0),
                _buildDetailRow(Icons.event, 'Type', currentEvent.eventType.toString().split('.').last),
                SizedBox(height: 16.0),
                _buildEventSpecificDetails(currentEvent, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 28.0),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventSpecificDetails(Event event, BuildContext context) {
    String dateStart = DateFormat('yyyy-MM-dd').format(event.dateStart);
    String dateEnd = DateFormat('yyyy-MM-dd').format(event.dateEnd);
    String startingTime = event.startingTime.format(context);
    String endingTime = event.endingTime.format(context);

    if (event.eventType == EventType.SINGLE) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.calendar_today, 'Date', dateStart),
          SizedBox(height: 16.0),
          _buildTimeRow('Start Time', startingTime, context),
          SizedBox(height: 16.0),
          _buildTimeRow('End Time', endingTime, context),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.calendar_today, 'Start Date', dateStart),
          SizedBox(height: 16.0),
          _buildDetailRow(Icons.calendar_today, 'End Date', dateEnd),
          SizedBox(height: 16.0),
          _buildTimeRow('Start Time', startingTime, context),
          SizedBox(height: 16.0),
          _buildTimeRow('End Time', endingTime, context),
        ],
      );
    }
  }

  Widget _buildTimeRow(String label, String time, BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time, color: Colors.blue, size: 28.0),
        SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                time,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
