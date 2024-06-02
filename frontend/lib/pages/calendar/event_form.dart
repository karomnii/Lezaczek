// lib/pages/calendar/event_form.dart

import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  final Event? initialEvent;
  final Function(Event) onSave;

  EventForm({this.initialEvent, required this.onSave});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late int _userID;
  late String _name;
  late String? _description;
  late String? _place;
  late EventType _eventType;
  late DateTime _dateStart;
  late DateTime _dateEnd;
  late TimeOfDay _startingTime;
  late TimeOfDay _endingTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialEvent != null) {
      _userID = widget.initialEvent!.userID;
      _name = widget.initialEvent!.name;
      _description = widget.initialEvent!.description;
      _place = widget.initialEvent!.place;
      _eventType = widget.initialEvent!.eventType;
      _dateStart = widget.initialEvent!.dateStart;
      _dateEnd = widget.initialEvent!.dateEnd;
      _startingTime = widget.initialEvent!.startingTime;
      _endingTime = widget.initialEvent!.endingTime;
    } else {
      _userID = 0;
      _name = '';
      _description = '';
      _place = '';
      _eventType = EventType.SINGLE;
      _dateStart = DateTime.now();
      _dateEnd = DateTime.now();
      _startingTime = TimeOfDay.now();
      _endingTime = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialEvent == null ? 'Add Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              TextFormField(
                initialValue: _place,
                decoration: InputDecoration(labelText: 'Place'),
                onSaved: (value) {
                  _place = value;
                },
              ),
              DropdownButtonFormField<EventType>(
                value: _eventType,
                decoration: InputDecoration(labelText: 'Event Type'),
                items: EventType.values.map((type) {
                  return DropdownMenuItem<EventType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
              ),
              DatePickerFormField(
                initialValue: _dateStart,
                label: 'Start Date',
                onDateSelected: (date) {
                  setState(() {
                    _dateStart = date;
                  });
                },
              ),
              DatePickerFormField(
                initialValue: _dateEnd,
                label: 'End Date',
                onDateSelected: (date) {
                  setState(() {
                    _dateEnd = date;
                  });
                },
              ),
              TimePickerFormField(
                initialValue: _startingTime,
                label: 'Starting Time',
                onTimeSelected: (time) {
                  setState(() {
                    _startingTime = time;
                  });
                },
              ),
              TimePickerFormField(
                initialValue: _endingTime,
                label: 'Ending Time',
                onTimeSelected: (time) {
                  setState(() {
                    _endingTime = time;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Event newEvent = Event(
                      eventId: widget.initialEvent?.eventId ?? 0,
                      userID: _userID,
                      name: _name,
                      description: _description,
                      place: _place,
                      eventType: _eventType,
                      dateStart: _dateStart,
                      dateEnd: _dateEnd,
                      startingTime: _startingTime,
                      endingTime: _endingTime,
                    );
                    widget.onSave(newEvent);
                  }
                },
                child: Text(widget.initialEvent == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePickerFormField extends StatelessWidget {
  final DateTime initialValue;
  final String label;
  final ValueChanged<DateTime> onDateSelected;

  DatePickerFormField({required this.initialValue, required this.label, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialValue,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(DateFormat('yyyy-MM-dd').format(initialValue)),
      ),
    );
  }
}

class TimePickerFormField extends StatelessWidget {
  final TimeOfDay initialValue;
  final String label;
  final ValueChanged<TimeOfDay> onTimeSelected;

  TimePickerFormField({required this.initialValue, required this.label, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: initialValue,
        );
        if (selectedTime != null) {
          onTimeSelected(selectedTime);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(initialValue.format(context)),
      ),
    );
  }
}
